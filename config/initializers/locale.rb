# set default locale to something other than :en
I18n.default_locale = :"zh-CN"

require "i18n/backend/fallbacks" 
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

I18n.fallbacks.map(:"zh-CN" => :en)
