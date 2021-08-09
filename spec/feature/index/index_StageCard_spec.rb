# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/BreadCrumbs'
require_relative '../../lib/StageCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('#StageCard')
      end

      describe 'ステージ判断の指標(StageCard)' do
        it '項目の値' do
          has_stage_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#StageCard')
        end
      end
    end
  end
end
