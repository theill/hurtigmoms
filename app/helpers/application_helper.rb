module ApplicationHelper
  def title
    @meta[:title] if @meta
  end
  
  def description
    @meta[:description] if @meta
  end
  
  def company_title
  	[current_user.company, I18n.t('application.name')].reject(&:blank?).first
  end
end
