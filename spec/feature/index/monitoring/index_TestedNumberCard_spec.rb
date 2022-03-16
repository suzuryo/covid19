# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/TestedNumberCard'

describe 'iPhone SE', type: :feature do
  LOCALES.each do |lang, data|
    context 'page [/monitoring]' do
      before do
        visit "#{data[:path]}monitoring/"
        render_lazy_contents
        page.scroll_to('#TestedNumberCard')
      end

      describe '検査実施件数(TestedNumberCard)' do
        it '項目の値' do
          has_tested_number_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#TestedNumberCard')
        end
      end
    end
  end
end
