# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/WhatsNewCard'

describe 'iPhone SE', type: :feature do
  context 'page [/cards/whats-new/]' do
    before do
      visit '/cards/whats-new/'
      render_lazy_contents
      page.scroll_to('#WhatsNewCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['WhatsNewCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/whats-new/").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:url' do
        # JS解釈したog:url
        expect(find('head meta[property="og:url"]', visible: false)[:content]).to eq "https://iwate.stopcovid19.jp/cards/whats-new/"
        # JS解釈しないog:url
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/whats-new/").open).css('head meta[property="og:url"]').first['content']).to eq "https://iwate.stopcovid19.jp/cards/whats-new/"
      end
    end

    describe '最新のお知らせ(WhatsNewCard)' do
      it '項目の値' do
        has_whats_new_card
        has_breadcrumbs(id: '#WhatsNewCard', title: JA_JSON['WhatsNewCard']['title'])
      end
    end
  end
end
