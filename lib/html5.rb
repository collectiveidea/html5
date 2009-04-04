require 'action_view/helpers/asset_tag_helper'

module ActionView::Helpers::AssetTagHelper
  
private
  
  # type attribute defaults to text/javascript so it can be omitted.
  # http://www.whatwg.org/specs/web-apps/current-work/#the-link-element
  def javascript_src_tag_with_empty_type(source, options)
    javascript_src_tag_without_empty_type(source, {'type' => nil}.merge(options))
  end
  alias_method_chain :javascript_src_tag, :empty_type

  # type attribute defaults to text/css so it can be omitted.
  # http://www.whatwg.org/specs/web-apps/current-work/#script
  def stylesheet_tag(source, options)
    tag("link", { "rel" => "stylesheet", "media" => "screen", "href" => html_escape(path_to_stylesheet(source)) }.merge(options), false, false)
  end
end