module Users
  class RegistrationsController < Devise::RegistrationsController 
    
    def create  
      super  
      #FIXME
      #session[:omniauth] = nil unless @user.new_record?   
    end
    
    private  
    def build_resource(*args)  
      super  
      if session[:omniauth]  
        @user.apply_omniauth(session[:omniauth]) 
        logger.debug "Devise::RegistrationsController#build_resource => #{@user.ya2yaml}" 
        @user.valid?  
      end  
    end
  end
end