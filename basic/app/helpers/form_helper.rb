module FormHelper
  
  def datepicker_input(form, attribute, html_options = {})
    append_input(form, attribute, :calendar, :datepicker, html_options)
  end

  def append_input(form, attribute, icon_name, wrapper = :append, html_options = {})
    html_options[:wrapper] = wrapper
    form.text_field attribute, html_options do
      concat form.input_field(attribute, as: :string, class: html_options[:class])
      concat content_tag :span, (form.label attribute, icon(icon_name)), id: "#{form.object.class}-#{attribute}", class: 'input-group-addon'
    end
  end
  
  def optional_label(form, name, html_options = {})
    @content = form.label name
    @content << content_tag(:span, ' - opcional', class: 'optional-input')
  end
  

end

