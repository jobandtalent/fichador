# frozen_string_literal: true

require 'webpack_helper'

module WebpackHelper
  def check_assets_manifest!
    return if @check_ok

    data_present!
    manifest_is_up_to_date!
    @check_ok = true
  end

  private

  def manifest_is_up_to_date!
    age = Time.zone.now - File.ctime(manifest_location)
    raise 'Manifest is too old (> 30 minutes)' if age > 30.minutes
  end

  def data_present!
    data
    raise 'Manifest is empty' if data.blank?
  end
end
