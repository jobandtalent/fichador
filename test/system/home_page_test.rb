# frozen_string_literal: true

require 'test_helper'

class HomePageTest < ApplicationSystemTestCase
  test 'home page show the content without special JS' do
    visit root_url

    assert_selector 'h1', text: 'Fichador'
  end
end
