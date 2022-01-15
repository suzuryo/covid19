# frozen_string_literal: true

require 'spec_helper'

describe 'iPhone SE', type: :feature do
  context 'page [/]' do
    before do
      visit '/'
      # render_lazy_contents
    end

    it 'title' do
      expect(title).to eq "#{JA_JSON['Common']['岩手の最新感染動向']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
    end

    it 'og:title' do
      # JS解釈したog:title
      expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      # JS解釈しないog:title
      expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
    end

    it 'og:url' do
      # JS解釈したog:url
      expect(find('head meta[property="og:url"]', visible: false)[:content]).to eq "https://iwate.stopcovid19.jp/"
      # JS解釈しないog:url
      expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}").open).css('head meta[property="og:url"]').first['content']).to eq "https://iwate.stopcovid19.jp/"
    end

    it 'h1/h2' do
      expect(find('#app > div > div.appContainer > div > div > header > h1').text).to eq "#{JA_JSON['Common']['新型コロナウイルス感染症']}\n#{JA_JSON['Common']['対策サイト']}"
      expect(find('#app > div > div.appContainer > main > div > div > div.PageHeader.mb-3 > h2').text).to eq (JA_JSON['Common']['岩手の最新感染動向']).to_s
    end

  end
end
