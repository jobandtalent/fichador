# frozen_string_literal: true

require 'test_helper'

class ClockPageTest < ApplicationSystemTestCase
  test 'the clock allow to mark the start' do
    visit clock_url

    assert_selector '#clock button', text: 'Comenzar'
  end
end
