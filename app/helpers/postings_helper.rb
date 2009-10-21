module PostingsHelper
  def text_box_with_value(form, object, form_method, method, value, options={})
    if object.send(method).blank?
      show_value = value
      use_color = '#7f7f7f'
    else
      show_value = object.send(method)
      use_color = '#000000'
    end
    form.send(form_method, method, {
      :value => show_value,
      :onblur  => "setDefaultValue(this, '#{value}');",
      :onfocus => "unsetDefaultValue(this, '#{value}');",
      :style => "color: #{use_color};"}.merge(options)
    )
  end
end
