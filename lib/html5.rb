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
    tag("link", { "rel" => "stylesheet", "media" => "screen", "href" => html_escape(path_to_stylesheet(source)) }.merge(options), ::SKIP_SELF_CLOSE_TAGS, false)
  end
  
  def image_tag(source, options = {})
    options.symbolize_keys!

    options[:src] = path_to_image(source)
    options[:alt] ||= File.basename(options[:src], '.*').split('.').first.to_s.capitalize

    if size = options.delete(:size)
      options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
    end

    if mouseover = options.delete(:mouseover)
      options[:onmouseover] = "this.src='#{image_path(mouseover)}'"
      options[:onmouseout]  = "this.src='#{image_path(options[:src])}'"
    end

    tag("img", options, ::SKIP_SELF_CLOSE_TAGS)
  end
    
  def auto_discovery_link_tag(type = :rss, url_options = {}, tag_options = {})
    tag(
      "link",
      {"rel"   => tag_options[:rel] || "alternate",
      "type"  => tag_options[:type] || Mime::Type.lookup_by_extension(type.to_s).to_s,
      "title" => tag_options[:title] || type.to_s.upcase,
      "href"  => url_options.is_a?(Hash) ? url_for(url_options.merge(:only_path => false)) : url_options}, ::SKIP_SELF_CLOSE_TAGS
    )
  end
end