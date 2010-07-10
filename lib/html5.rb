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

end

module ActionView::Helpers::TagHelper
  # When served as text/html, tags do not need to be self-closed.
  # http://www.whatwg.org/specs/web-apps/current-work/#void-elements
  VOID_ELEMENTS = %w(base command link meta hr br img embed param area col input source)
  
  def tag_with_skip_self_closing(name, options = nil, open = false, escape = true)
    open = true if VOID_ELEMENTS.include?(name.to_s) && ::SKIP_SELF_CLOSE_TAGS
    
    tag_without_skip_self_closing(name, options, open, escape)
  end
  alias_method_chain :tag, :skip_self_closing
end

require 'action_view/helpers/form_helper'

module ActionView::Helpers
  module FormHelper
    def email_field(object_name, method, options = {})
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("email", options)
    end
  
    def url_field(object_name, method, options = {})
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("url", options)
    end
  
    def search_field(object_name, method, options = {})
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("search", options)
    end
  
    def number_field(object_name, method, options = {})
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("number", options)
    end
  
    def range_field(object_name, method, options = {})
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("range", options)
    end

    def tel_field(object_name, method, options = {})
      InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("tel", options)
    end
  end

  class FormBuilder
    self.field_helpers = (FormHelper.instance_methods - ['form_for'])
    
    (field_helpers - %w(label check_box radio_button fields_for hidden_field)).each do |selector|
      src = <<-end_src
        def #{selector}(method, options = {})  # def text_field(method, options = {})
          @template.send(                      #   @template.send(
            #{selector.inspect},               #     "text_field",
            @object_name,                      #     @object_name,
            method,                            #     method,
            objectify_options(options))        #     objectify_options(options))
        end                                    # end
      end_src
      class_eval src, __FILE__, __LINE__
    end
  end
end


module ActionView::Helpers::FormTagHelper
  def email_field_tag(name, value = nil, options = {})
    text_field_tag(name, value, options.stringify_keys.update("type" => "email"))
  end

  def url_field_tag(name, value = nil, options = {})
    text_field_tag(name, value, options.stringify_keys.update("type" => "url"))
  end

  def search_field_tag(name, value = nil, options = {})
    text_field_tag(name, value, options.stringify_keys.update("type" => "search"))
  end
  
  def number_field_tag(name, value = nil, options = {})
    text_field_tag(name, value, options.stringify_keys.update("type" => "number"))
  end
  
  def range_field_tag(name, value = nil, options = {})
    text_field_tag(name, value, options.stringify_keys.update("type" => "range"))
  end

  def tel_field_tag(name, value = nil, options = {})
    text_field_tag(name, value, options.stringify_keys.update("type" => "tel"))
  end
end