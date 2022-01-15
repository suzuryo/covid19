# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/BreadCrumbs'
require_relative '../../../lib/UntrackedRateCard'

describe 'iPhone SE', type: :feature do
  context 'page [/]' do
    before do
      visit '/monitoring/'
      render_lazy_contents
      page.scroll_to('#UntrackedRateCard')
    end

    describe '接触歴等不明者数(7日間移動平均)(UntrackedRateCard)' do
      it '項目の値' do
        has_untracked_rate_card
        has_no_breadcrumbs(id: '#UntrackedRateCard')
      end
    end
  end
end
