# frozen_string_literal: true

require 'spec_helper'

# sw.js で ServiceWorkerのunregisterをする

describe 'iPhone SE', type: :feature do
  context 'page [/]' do
    before do
      visit '/sw.js'
    end

    it 'has unregister code' do
      expect(page.html).to have_content('self.registration.unregister()')
    end
  end
end
