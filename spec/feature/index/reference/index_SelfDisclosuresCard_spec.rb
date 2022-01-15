# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/SelfDisclosuresCard'

describe 'iPhone SE', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit "#{data[:path]}reference/"
        render_lazy_contents
        page.scroll_to('#SelfDisclosuresCard')
      end

      describe '自主公表(SelfDisclosuresCard)' do
        it '項目の値' do
          has_self_disclosures_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#SelfDisclosuresCard')
        end
      end
    end
  end
end
