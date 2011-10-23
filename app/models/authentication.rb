class Authentication < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :provider, :uid

  #TODO
  attr_accessible :name, :desc, :original_auth

  attr_accessible :image, :remote_image_url
  mount_uploader :image, ImageUploader
  
  def self.reprocess_omniauth!(omniauth)
    provider = omniauth['provider']

    if omniauth['uid'].blank?
      fallback = APP_CONFIG[:omni_auth_uid_fallback]
      raise "No uid fallback for all providers! => #{APP_CONFIG.ya2yaml}" if fallback.nil?
      if fallback.has_key? provider.to_sym
      omniauth['uid'] = omniauth['user_info'][fallback[provider.to_sym]]
      else
      raise "No uid or uid fallback available for provider[#{provider}]!"
      end
    end
    
    #fix email
    # allow no email, fill in a dummy one
    omniauth['user_info']['email'] = "#{omniauth['uid']}@#{omniauth['provider']}-dummy-please-change-it.com" if omniauth['user_info']['email'].blank?
    
    # fix desc
    #TODO ugly, make it provider-wise
    omniauth['user_info']['description'] = omniauth['extra']['user_hash']['data']['introduction'] if omniauth['provider'] == 'tqq'
    
    # fix image
    #TODO ugly
    image_url = omniauth['user_info']['image']
    
    if(omniauth['provider'] == 'tqq' && !image_url.match(/120$/))
      omniauth['user_info']['image'] = "#{image_url}/120"
    end
    
    omniauth['extra'].delete('access_token') 
    
    omniauth
  end
  
 def self.new_with_omniauth(omniauth)
   
   omniauth = Authentication.reprocess_omniauth!(omniauth)
   
# https://open.t.qq.com/cgi-bin/access_token
# 请求参数:
# 参数   意义
# oauth_consumer_key   AppKey
# oauth_token  第一步中获得的Request Token
# oauth_signature_method   签名方法，暂只支持HMAC-SHA1
# oauth_signature  签名值，密钥为：App Secret&Request Token Secret。计算说明。
# oauth_timestamp  时间戳, 其值是距1970 00:00:00 GMT的秒数，必须是大于0的整数
# oauth_nonce  单次值，随机生成的32位字符串，防止重放攻击（每次请求必须不同）
# oauth_verifier   上一步请求授权request token时返回的验证码
# oauth_version(可选)  版本号，有的话必须为“1.0”
# 返回参数:
# 参数   意义
# oauth_token  Access Token
# oauth_token_secreate   Access Token Secret
    #raise auth['user_info'].to_yaml
   
    Authentication.new do |authentication|
      authentication.provider = omniauth['provider']
      authentication.uid = omniauth['uid']
      authentication.name = omniauth['user_info']['name']
      authentication.desc = omniauth['user_info']['description']
      authentication.original_auth = omniauth.ya2yaml
      
      begin
        logger.debug "Using remote_image_url[#{omniauth['user_info']['image']}]"
        authentication.remote_image_url = "#{omniauth['user_info']['image']}"
      rescue
        #allow no image
      end
           
      #raise authentication.to_yaml
    end
  end

  def provider_name
    if provider == 'open_id'
    "OpenID"
    else
    provider.titleize
    end
  end

  def access_token
    @auth_hash ||= YAML.load(original_auth)
    @access_token ||= ::OAuth::AccessToken.new consumer, @auth_hash['credentials']['token'], @auth_hash['credentials']['secret']
    @access_token
  end

  private

  def consumer
    #TODO make it provider-wise
    client_options = {
      :site               => 'https://open.t.qq.com',
      :request_token_path => '/cgi-bin/request_token',
      :access_token_path  => '/cgi-bin/access_token',
      :authorize_path     => '/cgi-bin/authorize',
      :realm              => 'OmniAuth',
      :scheme             => :query_string,
      :nonce              => nonce,
      :http_method        => :get,
    }

    prov_sym = provider.to_sym
    #client = ::OAuth::Client.new prov_info[1], prov_info[2]
    @consumer ||= ::OAuth::Consumer.new(SECRET_CONFIG["#{prov_sym}_KEY"], SECRET_CONFIG["#{prov_sym}_SECRET"], client_options)
    # consumer.http.open_timeout = options[:open_timeout] if options[:open_timeout]
    # consumer.http.read_timeout = options[:read_timeout] if options[:read_timeout]
    @consumer
  end

  def nonce
    Base64.encode64(OpenSSL::Random.random_bytes(32)).gsub(/\W/, '')[0, 32]
  end
end
