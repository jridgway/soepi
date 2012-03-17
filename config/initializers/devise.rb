require 'devise'
require 'openid/store/filesystem'

# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class with default "from" parameter.
  config.mailer_sender = "no-reply@soepi.org"

  # Configure the class responsible to send e-mails.
  # config.mailer = "Devise::Mailer"

  # Automatically apply schema changes in tableless databases
  config.apply_schema = false

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating a user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # You can also supply a hash where the value is a boolean determining whether
  # or not authentication should be aborted when the value is not present.
  config.authentication_keys = [ :email ]

  # Configure parameters from the request object used for authentication. Each entry
  # given should be a request method and it will automatically be passed to the
  # find_for_authentication method and considered in your model lookup. For instance,
  # if you set :request_keys to [:subdomain], :subdomain will be used on authentication.
  # The same considerations mentioned for authentication_keys also apply to request_keys.
  # config.request_keys = []

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = []

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  # config.strip_whitespace_keys = [ :email ]

  # Tell if authentication through request.params is enabled. True by default.
  # It can be set to an array that will enable params authentication only for the
  # given stratragies, for example, `config.params_authenticatable = [:database]` will
  # enable it only for database (email + password) authentication.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Basic Auth is enabled. False by default.
  # It can be set to an array that will enable http authentication only for the
  # given stratragies, for example, `config.http_authenticatable = [:token]` will
  # enable it only for token authentication.
  # config.http_authenticatable = false

  # If http headers should be returned for AJAX requests. True by default.
  # config.http_authenticatable_on_xhr = true

  # The realm used in Http Basic Authentication. "Application" by default.
  # config.http_authentication_realm = "Application"

  # It will change confirmation, password recovery and other workflows
  # to behave the same regardless if the e-mail provided was right or wrong.
  # Does not affect registerable.
  # config.paranoid = true

  # By default Devise will store the user in session. You can skip storage for
  # :http_auth and :token_auth by adding those symbols to the array below.
  # Notice that if you are skipping storage for all authentication paths, you
  # may want to disable generating routes to Devise's sessions controller by
  # passing :skip => :sessions to `devise_for` in your config/routes.rb
  config.skip_session_storage = [:http_auth]

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 10. If
  # using other encryptors, it sets how many times you want the password re-encrypted.
  #
  # Limiting the stretches to just one in testing will increase the performance of
  # your test suite dramatically. However, it is STRONGLY RECOMMENDED to not use
  # a value less than 10 in other environments.
  config.stretches = Rails.env.test? ? 1 : 10

  # Setup a pepper to generate the encrypted password.
  # config.pepper = <%= SecureRandom.hex(64).inspect %>

  # ==> Configuration for :confirmable
  # A period that the user is allowed to access the website even without
  # confirming his account. For instance, if set to 2.days, the user will be
  # able to access the website for two days without confirming his account,
  # access will be blocked just in the third day. Default is 0.days, meaning
  # the user cannot access the website without confirming his account.
  # config.allow_unconfirmed_access_for = 2.days

  # If true, requires any email changes to be confirmed (exctly the same way as
  # initial account confirmation) to be applied. Requires additional unconfirmed_email
  # db field (see migrations). Until confirmed new email is stored in
  # unconfirmed email column, and copied to email column on successful confirmation.
  # config.reconfirmable = true

  # Defines which key will be used when confirming an account
  # config.confirmation_keys = [ :email ]

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  # config.remember_for = 2.weeks

  # If true, extends the user's remember period when remembered via cookie.
  # config.extend_remember_period = false

  # If true, uses the password salt as remember token. This should be turned
  # to false if you are not using database authenticatable.
  config.use_salt_as_remember_token = true

  # Options to be passed to the created cookie. For instance, you can set
  # :secure => true in order to force SSL only cookies.
  # config.cookie_options = {}

  # ==> Configuration for :validatable
  # Range for password length. Default is 6..128.
  config.password_length = 8..128

  # Email regex used to validate email formats. It simply asserts that
  # an one (and only one) @ exists in the given string. This is mainly
  # to give user feedback and not to assert the e-mail validity.
  # config.email_regexp = /\A[^@]+@[^@]+\z/

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again. Default is 30 minutes.
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts to sign in.
  # :none            = No lock strategy. You should handle locking by yourself.
  # config.lock_strategy = :failed_attempts

  # Defines which key will be used when locking and unlocking an account
  # config.unlock_keys = [ :email ]

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  # config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  # config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  # config.unlock_in = 1.hour

  # ==> Configuration for :recoverable
  #
  # Defines which key will be used when recovering the password for an account
  # config.reset_password_keys = [ :email ]

  # Time interval you can reset your password with a reset password key.
  # Don't put a too small interval or your users won't have the time to
  # change their passwords.
  config.reset_password_within = 6.hours

  # ==> Configuration for :encryptable
  # Allow you to use another encryption algorithm besides bcrypt (default). You can use
  # :sha1, :sha512 or encryptors from others authentication tools as :clearance_sha1,
  # :authlogic_sha512 (then you should set stretches above to 20 for default behavior)
  # and :restful_authentication_sha1 (then you should set stretches to 10, and copy
  # REST_AUTH_SITE_KEY to pepper)
  # config.encryptor = :sha512

  # ==> Configuration for :token_authenticatable
  # Defines name of the authentication token params key
  # config.token_authentication_key = :auth_token

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "users/sessions/new". It's turned off by default because it's slower if you
  # are using only default views.
  config.scoped_views = true

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  config.default_scope = :member

  # Configure sign_out behavior.
  # Sign_out action can be scoped (i.e. /users/sign_out affects only :user scope).
  # The default is true, which means any logout action will sign out all active scopes.
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  #
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists.
  #
  # The "*/*" below is required to match Internet Explorer requests.
  # config.navigational_formats = ["*/*", :html]

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on setting
  # up on your models and hooks.
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', :scope => 'user,public_repo'
  
  if Rails.env.production?
    config.omniauth :facebook, "309296215778440", "e4a30059977a584363acd6d2499f2917"
    config.omniauth :twitter, "BjaXvp2XM3XBHRwIf9LZ0g", "FHKOedvp3fR8FPFe0rLr0QqA7R6naN1FYdVVkTuMEfE"
    config.omniauth :google_apps, :store => OpenID::Store::Filesystem.new(Rails.root.join('tmp').to_s), :domain => 'gmail.com'
    config.omniauth :yahoo, "dj0yJmk9Y0kzRGxvMk1paDZFJmQ9WVdrOWFFRk1SRlJUTkRnbWNHbzlNVGsxTnpRNE1ESTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD05Zg--", "d72b3cce1052030ef6b66cd410c329e4a5843171"
    #config.omniauth :linked_in, "9n_yjSwmo0UwDr_NPs6eOknneS7MgRgbvTx0kXK5ooOz-zZ-0dYH-uwXvvuYqkh1", "iz0-SnJoyTKjzuDWUhhRekT5WYst9Qzx5nstK2MYjDT4t1nyqfS4ZhEUoP1zzN5l"
    config.omniauth :github, "b8ee2c197c6d68fe64fd", "1e62eb237909f135b8a2842ac45a900a76661e2b"
    config.omniauth :open_id, :store => OpenID::Store::Filesystem.new(Rails.root.join('tmp').to_s), :require => 'omniauth-openid'
    #config.omniauth :vimeo, "9b1e82c3b79bf3a7d288824e00ba0138", "b7a1c3eb264a5c50"
    #config.omniauth :presently, "jr6d9Ao5z16TD5c4bD8A", "olHOV9h7ufdT3O0XA1zCLtskTTyzes6SKNX92Daihq8"
  else
    config.omniauth :facebook, "113742618704445", "d4df7ff48a0f6602857200894231bba9"
    config.omniauth :twitter, "Q795shC8Qj5NdzXZ2AS35w", "SAhMYcaTDSpWqNN1qkjizR8YvZW9EIUMjaOmfIw6j4"
    config.omniauth :google_apps, :store => OpenID::Store::Filesystem.new(Rails.root.join('tmp').to_s), :domain => 'gmail.com'
    config.omniauth :yahoo, "dj0yJmk9MzRjNDN3QWNWNm42JmQ9WVdrOVRXVlFjV0p4Tm5NbWNHbzlNVE0yT0RnMk5UWXkmcz1jb25zdW1lcnNlY3JldCZ4PWUw", "ee42d4e29a965408394f83917f47b373c34e777c"
    #config.omniauth :linked_in, "Y1KogHrjY5Yi-ozxrc8DGCh2FQOG3VPvvWEuZqfpWmECA46MszuTRyLOlyX59VYf", "106Tn8QxoH35KmGh_Ris2C0X7WoO8ZpCeq9Oe8Xr4Q27q4ABE1lmPjs4tXAZ7C6S"
    config.omniauth :github, "fb30d950652ddea58ee2", "759d5fec5f0f05d4bff39fe20ddad0afbbd1e379"
    config.omniauth :open_id, :store => OpenID::Store::Filesystem.new(Rails.root.join('tmp').to_s), :require => 'omniauth-openid'
    #config.omniauth :vimeo, "af3e7f56f4f9e56ed45915b057785df0", "7c829bf66cb1e51b"
    #config.omniauth :presently, "8Qmj3gEPTHSpCxeIuVjaA", "viTZ0CGTZOnhyzJSzC0AJO8SxSQf5xolMpvTsvjf3qs"
  end

  # ==> Warden configuration
  # If you want to use other strategies, that are not supported by Devise, or
  # change the failure app, you can configure them inside the config.warden block.
  #
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(:scope => :user).unshift :some_external_strategy
  # end

  # Please do not change the router_name away from :refinery
  # otherwise Refinery may not function properly. Thanks!
  config.router_name = :refinery
end
