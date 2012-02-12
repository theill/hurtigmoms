# encoding: utf-8

module ApplicationHelper
  def title
    I18n.t('application.name') + (' - ' + @meta[:title]) if @meta
  end
  
  def description
    @meta[:description] if @meta
  end
  
  def company_title
  	[current_user.company, I18n.t('application.name')].reject(&:blank?).first
  end
  
  def menu_tag(name, options = {}, html_options = nil)
    content_tag(:li, link_to(name, options, html_options), :class => request.path == options ? 'selected' : '')
  end
end
