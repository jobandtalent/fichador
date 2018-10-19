# frozen_string_literal: true

module WebpackHelper
  class MissingEntryError < StandardError; end

  def asset_pack_path(name, **options)
    asset_path(manifest_lookup!(name), **options)
  end

  def asset_pack_url(name, **options)
    asset_url(manifest_lookup!(name), **options)
  end

  def image_pack_tag(name, **options)
    image_tag(asset_path(manifest_lookup!(name)), **options)
  end

  def javascript_pack_tag(*names, **options)
    javascript_include_tag(*sources_from_pack_manifest(names, type: :javascript), **options)
  end

  def stylesheet_pack_tag(*names, **options)
    return nil if hot_replace_enabled?

    stylesheet_link_tag(*sources_from_pack_manifest(names, type: :stylesheet), **options)
  end

  protected

  def manifest_location
    File.expand_path(File.join(dist_path, 'manifest.json'))
  end

  def data
    if cache_manifest?
      Thread.current['webpack_manifest'] ||= load
    else
      refresh
    end
  end

  private

  def sources_from_pack_manifest(names, type:)
    names.map { |name| manifest_lookup!(pack_name_with_extension(name, type: type)) }
  end

  def pack_name_with_extension(name, type:)
    "#{name}#{compute_asset_extname(name, type: type)}"
  end

  def manifest_lookup!(name)
    manifest_lookup(name) || handle_missing_entry(name)
  end

  def manifest_lookup(name)
    data[name.to_s].presence
  end

  def refresh
    Thread.current['request_id'] = request.object_id
    Thread.current['webpack_manifest'] = load
  end

  def load
    JSON.parse File.read(manifest_location)
  rescue Errno::ENOENT
    raise "Manifest for assets not found at '#{manifest_location}'"
  end

  def handle_missing_entry(name)
    raise MissingEntryError.new("Can't find '#{name}' in manifest.js")
  end

  def dist_path
    File.join('public', Rails.env.test? && !ENV['CI'] ? 'packs-test' : 'packs')
  end

  def cache_manifest?
    !Rails.env.development? || Thread.current['request_id'] == request.object_id
  end

  def hot_replace_enabled?
    Rails.env.development? && manifest_lookup('hmr')
  end
end
