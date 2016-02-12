SpreeSocial::OAUTH_PROVIDERS.each do |provider|
  SpreeSocial.init_provider(provider[1])
end

config.omniauth :twitter, 'gW9eV5SvhnJGoeR9UCiOo0ebe', '5mgLwqpQyRVlgdIHA19CYULYgCTjRQRQLEEida5VgHVs0lm40P', {:scope => 'offline_access,email'}

OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = 'omniauth'

OmniAuth.config.on_failure = proc do |env|
  env['devise.mapping'] = Devise.mappings[Spree.user_class.table_name.singularize.to_sym]
  controller_name  = ActiveSupport::Inflector.camelize(env['devise.mapping'].controllers[:omniauth_callbacks])
  controller_klass = ActiveSupport::Inflector.constantize("#{controller_name}Controller")
  controller_klass.action(:failure).call(env)
end
