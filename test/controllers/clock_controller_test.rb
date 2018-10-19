# frozen_string_literal: true

require 'test_helper'

class ClockControllerTest < ActionDispatch::IntegrationTest
  test 'should get a placeholder for the clock' do
    get clock_url
    assert_response :success

    assert_select '#clock', 'Reloj de Fichar'
  end
end
