# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/removed/EffectiveReproductionNumberCard'

describe 'iPhone SE', type: :feature do
  LOCALES.each do |lang, data|
    skip "page #{data[:path]}" do
      before do
        visit "#{data[:path]}monitoring/"
        render_lazy_contents
        page.scroll_to('#EffectiveReproductionNumberCard')
      end

      describe '実効再生産数(推定値)(EffectiveReproductionNumberCard)' do
        it '項目の値' do
          has_effective_reproduction_number_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#EffectiveReproductionNumberCard')
        end
      end
    end
  end
end
