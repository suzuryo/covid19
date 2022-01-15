# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'

describe 'iPhone SE', type: :feature do
  context 'page [/]' do
    before do
      visit '/reference/'
      page.scroll_to('.v-tabs')
      render_lazy_contents
    end

    describe '一般相談 受付件数(TelephoneAdvisoryReportsNumberCard)' do
      it '項目の値' do
        # TelephoneAdvisoryReportsNumberCard は削除した
        expect(page).not_to have_selector('#TelephoneAdvisoryReportsNumberCard')
        has_no_breadcrumbs(id: '#TelephoneAdvisoryReportsNumberCard')
      end
    end
  end
end
