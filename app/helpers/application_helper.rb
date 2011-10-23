module ApplicationHelper
  def current_authentications
    if current_user
      authentications ||= current_user.authentications
    else
      nil
    end
  end
  
 def user_image_tag(url)
    if url.blank?
      #view_context.
      image_tag '/images/guest.jpg'
    else
      image_tag url
    end
  end
end
