# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/HospitalizedNumberCard'

describe 'iPhone SE', type: :feature do
  context 'page [/cards/number-of-hospitalized/]' do
    before do
      visit '/cards/number-of-hospitalized/'
      render_lazy_contents
      page.scroll_to('#HospitalizedNumberCard')
    end

    describe 'meta' do
      it 'title' do
        expect(title).to eq "#{JA_JSON['HospitalizedNumberCard']['title']} | #{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:title' do
        # JS解釈したog:title
        expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
        # JS解釈しないog:title
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/number-of-hospitalized/").open).css('head meta[property="og:title"]').first['content']).to eq "#{JA_JSON['Common']['岩手県']} #{JA_JSON['Common']['新型コロナウイルス感染症']}#{JA_JSON['Common']['対策サイト']}"
      end

      it 'og:url' do
        # JS解釈したog:url
        expect(find('head meta[property="og:url"]', visible: false)[:content]).to eq "https://iwate.stopcovid19.jp/cards/number-of-hospitalized/"
        # JS解釈しないog:url
        expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}/cards/number-of-hospitalized/").open).css('head meta[property="og:url"]').first['content']).to eq "https://iwate.stopcovid19.jp/cards/number-of-hospitalized/"
      end
    end

    describe '療養者数の推移(HospitalizedNumberCard)' do
      it '項目の値' do
        has_hospitalized_number_card
        has_breadcrumbs(id: '#HospitalizedNumberCard', title: '療養者数の推移')
      end
    end
  end
end
