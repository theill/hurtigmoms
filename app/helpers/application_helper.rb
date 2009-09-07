# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    @meta[:title] if @meta
  end
  
  def description
    @meta[:description] if @meta
  end
end
