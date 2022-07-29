# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/removed/WeeklyMapCard'

describe 'iPhone SE', type: :feature do
  LOCALES.each do |lang, data|
    skip "page #{data[:path]}" do
      before do
        visit "#{data[:path]}cards/weekly-map/"
        render_lazy_contents
        page.scroll_to('#WeeklyMapCard')
      end

      describe 'meta' do
        it 'title' do
          expect(title).to eq "#{LOCALES[lang][:json]['WeeklyMapCard']['title']} | #{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:title' do
          # JS解釈したog:title
          expect(find('head meta[property="og:title"]', visible: false)[:content]).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
          # JS解釈しないog:title
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/weekly-map/").open).css('head meta[property="og:title"]').first['content']).to eq "#{LOCALES[lang][:json]['Common']['岩手県']} #{LOCALES[lang][:json]['Common']['新型コロナウイルス感染症']}#{LOCALES[lang][:json]['Common']['対策サイト']}"
        end

        it 'og:url' do
          # JS解釈したog:url
          expect(find('head meta[property="og:url"]', visible: false)[:content]).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/weekly-map/"
          # JS解釈しないog:url
          expect(Nokogiri::HTML(URI.parse("#{Capybara.app_host}#{data[:path]}cards/weekly-map/").open).css('head meta[property="og:url"]').first['content']).to eq "https://iwate.stopcovid19.jp#{data[:path]}cards/weekly-map/"
        end
      end

      describe '直近1週間の陽性例マップ(WeeklyMapCard)' do
        it '項目の値' do
          has_weekly_map_card(lang: lang, lang_json: data[:json])
          has_breadcrumbs(id: '#WeeklyMapCard', title: data[:json]['WeeklyMapCard']['title'], lang_json: data[:json])
        end
      end
    end
  end
end
