# frozen_string_literal: true

require 'spec_helper'
require 'typhoeus'

# 1. Vue.js を chrome (mobile emulation iPhone SE) で解釈する
# 2. ページ上の a href を 全部探す
# 3. href を GET してみて、 status code が 200 を確認
# なぜなら、盛岡市の個別事例ページがよく URL が変更になって 404 になるから。

describe 'iPhone SE', type: :feature do
  context 'page [/]' do
    urls = []

    # news.json の 個別ページのURL は直接読み込む
    NEWS_JSON['newsItems'].each do |item|
      urls << URI(item['url']['ja']) unless item['url']['ja'].blank? || item['url']['ja'].match(/www\.youtube\.com/)
      urls << URI(item['url']['en']) unless item['url']['en'].blank? || item['url']['en'].match(/www\.youtube\.com/)
    end

    # alert.json の 個別ページのURL は直接読み込む
    ALERT_JSON['alertItems'].each do |item|
      urls << URI(item['url']['ja']) unless item['url']['ja'].blank?
      urls << URI(item['url']['en']) unless item['url']['en'].blank?
    end

    # urls.json の URL は直接読み込む
    URLS_JSON['items'].each do |item|
      urls << URI(item['url'])
    end

    # SELF_DISCLOSURES_JSON.url は、ページが削除されても記録として 404になってもよいとする

    before do
      # chromeで / にアクセスして a タグを全部探す
      visit '/'
      render_lazy_contents
      page.all('a').each do |a|
        urls << URI(a['href'])
      end

      visit '/about/'
      render_lazy_contents
      page.all('a').each do |a|
        urls << URI(a['href'])
      end

      visit '/flow/'
      render_lazy_contents
      page.all('a').each do |a|
        urls << URI(a['href']) unless a['href'].match(/^tel:/)
      end

      visit '/vaccine/'
      render_lazy_contents
      page.all('a').each do |a|
        urls << URI(a['href'])
      end
    end

    it 'has no broken links' do
      hydra = Typhoeus::Hydra.new(max_concurrency: 10)

      # すべての href に対して
      requests = urls.uniq.map do |url|
        # http から始まらない場合はHOST名を補完
        url = "https://iwate.stopcovid19.jp#{url}" if !/^http/.match(url.to_s)
        request = Typhoeus::Request.new(
          url,
          headers: {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15 '
          },
          method: :get,
          followlocation: true,
          timeout: 10
        )
        hydra.queue(request)
        request
      end

      hydra.run

      requests.map do |request|
        p "#{request.response.response_code} #{request.response.redirect_count} #{request.base_url}"
        if ['https://clarity.microsoft.com/terms', 'https://privacy.microsoft.com/privacystatement'].include? "#{request.base_url}"
          expect(request.response.response_code).to eq 400
        else
          expect(request.response.response_code).to eq 200
        end
      end
    end
  end
end
