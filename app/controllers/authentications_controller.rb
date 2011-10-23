class AuthenticationsController < ApplicationController
  
  def index  
    @authentications = current_user.authentications if current_user  
  end

  def create  
    omniauth = Authentication.reprocess_omniauth!(request.env["omniauth.auth"])
    #logger.debug "omniauth.auth.user_hash = #{omniauth.ya2yaml}"  
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'].to_s)
      
    if authentication
      logger.debug "Authentication[#{omniauth['provider']}][#{omniauth['uid']}] found, login for user[#{authentication.uid}]."  
      flash[:notice] = t("devise.omniauth_callbacks.success", :kind => t("auth_provider.#{omniauth['provider']}"))
      sign_in_and_redirect(:user, authentication.user)  
    elsif current_user
      logger.debug "Using [#{omniauth['provider']}][#{omniauth['uid']}] as user[#{current_user.id}]'s login method."  
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'].to_s)  
      flash[:notice] = t("devise.omniauth_callbacks.enable_success", :kind => t("auth_provider.#{omniauth['provider']}"))  
      redirect_to authentications_url  
    else
      user = User.new  
      user.apply_omniauth(omniauth)      
      logger.debug "Creating user from [#{omniauth['provider']}][#{omniauth['uid']}] => #{user.ya2yaml}."
      if user.save
        logger.debug "Email available for [#{omniauth['provider']}][#{omniauth['uid']}]."  
        flash[:notice] = t("devise.sessions.sign_in")  
        sign_in_and_redirect(:user, user)  
      else
        logger.debug "Request further fillin for [#{omniauth['provider']}][#{omniauth['uid']}]."    
        session[:omniauth] = omniauth.except('extra')  #TODO
        redirect_to new_user_registration_url  
      end
      
      # user = User.new  
      # user.authentications.build(:provider => omniauth
        # ['provider'], :uid => omniauth['uid'])  
      # user.save!  
      # flash[:notice] = "Signed in successfully."  
      # sign_in_and_redirect(:user, user)  
    end  
  end

  def destroy  
    @authentication = current_user.authentications.find(params[:id]) 
    provider = @authentication.provider 
    @authentication.destroy  
    flash[:notice] = t("devise.omniauth_callbacks.destroy", :kind => t("auth_provider.#{provider}")) 
    redirect_to authentications_url  
  end  
end
