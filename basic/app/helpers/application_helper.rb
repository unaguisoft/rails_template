module ApplicationHelper

  def flash_message(klass, message)
    snack_klass = "#{klass} callout "
    snack_klass += 'callout-success' if klass == 'success'
    snack_klass += 'callout-danger'  if klass == 'error' || klass == 'danger'
    snack_klass += 'callout-warning'  if klass == 'warning'
    flash.discard(klass)
    content_tag :span, '', class: "snackbar-message klass",
                data: {toggle: :snackbar, style: snack_klass, content: message, timeout: 10000}
  end

  def flash_messages
    capture do
      flash.each do |type, message|
        concat flash_message(type, message)
      end
    end
  end

  def close_button(target = :modal)
    link_to '&times;'.html_safe, '', class: :close, data: {dismiss: target}
  end

  def icon(name, html_options={})
    html_options[:class] = ['fa', "fa-#{name}", html_options[:class]].compact
    content_tag(:i, nil, html_options)
  end

  # Link del menú lateral
  def side_link(text:'', path:'', icon_class:'', klass:'', html_options:{}, extra:'')
    link_class = html_options[:class]
    html_options[:class] = link_class
    html_options[:title] = text
    klass += current_page?(path) ? 'active' : url_for(path)
    content_tag(:li, class: klass) do
      (link_to path, html_options do
        "<i class='fa fa-fw fa-#{icon_class}'></i> <span> #{text} </span>".html_safe
      end) +
          extra.html_safe
    end
  end

  def sidebar_state
    'sidebar-mini sidebar-collapse' if content_for :hide_sidebar
  end

  def sub_menu(klass = '', &block)
    klass += ' ' if klass.present?
    klass += 'treeview-menu'
    tree = ''

    if block_given?
      tree = content_tag(:ul, class: klass) do
        capture(&block)
      end
    end

    return tree
  end

  def back_to_link(link_text, link_path='', klass='', html_options={})
    link_path = 'javascript:history.back()' if link_path.blank?
    content_tag(:div, class: 'return-back ' + klass) do
      link_to(link_path, options = {}, html_options = {}) do
        icon('angle-left').html_safe +
        "<span> #{link_text} </span>".html_safe
      end
    end
  end

end

