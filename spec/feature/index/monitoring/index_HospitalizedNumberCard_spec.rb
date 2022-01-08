# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/HospitalizedNumberCard'

describe 'iPhone 6/7/8', type: :feature do
  context 'page [/]' do
    before do
      visit '/monitoring/'
      render_lazy_contents
      page.scroll_to('#HospitalizedNumberCard')
    end

    describe '療養者数の推移(HospitalizedNumberCard)' do
      it '項目の値' do
        has_hospitalized_number_card
        has_no_breadcrumbs(id: '#HospitalizedNumberCard')
      end
    end
  end
end
