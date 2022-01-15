# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/WhatsNewCard'

describe 'iPhone SE', type: :feature do
  context 'page [/]' do
    before do
      visit '/reference/'
      render_lazy_contents
      page.scroll_to('#WhatsNewCard')
    end

    describe '最新のお知らせ(WhatsNewCard)' do
      it '項目の値' do
        has_whats_new_card
        has_no_breadcrumbs(id: '#WhatsNewCard')
      end
    end
  end
end
