module CoffeescriptTagHelper
  def coffeescript_tag(content_or_options_with_block = nil, html_options = {}, &block)
    content =
      if block_given?
        html_options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        capture(&block)
      else
        content_or_options_with_block
      end

    content_tag(:script, javascript_cdata_section(CoffeeScript.compile(content)), html_options.merge(:type => Mime::JS))
  end
end
