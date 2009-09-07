module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/i
      root_path
    when /the sign up page/i
      new_user_path
    when /the sign in page/i
      new_session_path
    when /the password reset request page/i
      new_password_path
    
    # Add more page name => path mappings here

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" + 
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end
 
World(NavigationHelpers)