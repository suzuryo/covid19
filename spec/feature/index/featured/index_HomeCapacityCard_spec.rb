# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/HomeCapacityCard'

describe 'iPhone 6/7/8', type: :feature do
  LOCALES.each do |lang, data|
    context "page #{data[:path]}" do
      before do
        visit data[:path]
        render_lazy_contents
        page.scroll_to('#HomeCapacityCard')
      end

      describe '自宅療養の状況(HomeCapacityCard)' do
        it '項目の値' do
          has_home_capacity_card(lang: lang, lang_json: data[:json])
          has_no_breadcrumbs(id: '#HomeCapacityCard')
        end
      end
    end
  end
end
