# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/ConfirmedCasesAttributesCard'

describe 'iPhone SE', type: :feature do
  context 'page [/]' do
    before do
      visit "/reference/"
      render_lazy_contents
      page.scroll_to('#ConfirmedCasesAttributesCard')
    end

    describe '陽性者の属性(ConfirmedCasesAttributesCard)' do
      it '項目の値' do
        has_confirmed_case_attributes_card
        has_no_breadcrumbs(id: '#ConfirmedCasesAttributesCard')
      end
    end
  end
end
