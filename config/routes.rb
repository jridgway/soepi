Soepi::Application.routes.draw do
  get '/search(/:page)', :controller => 'search', :action => 'index', :as => :search
  get '/quick_search', :controller => 'search', :action => 'quick_search'

  get '/subscribe', :controller => 'welcome', :action => 'subscribe', :as => :subscribe
  post '/subscribe', :controller => 'welcome', :action => 'subscribe', :as => :new_subscriber
  get '/your/notifications', :controller => 'welcome', :action => 'notifications', :as => :your_notifications
  get '/your/surveys', :controller => 'welcome', :action => 'surveys', :as => :your_surveys
  get '/your/reports', :controller => 'welcome', :action => 'reports', :as => :your_reports
  get '/your/statuses', :controller => 'welcome', :action => 'statuses', :as => :your_statuses
  get '/your/follows', :controller => 'welcome', :action => 'follows', :as => :your_follows
  get '/your/member_followers', :controller => 'welcome', :action => 'member_followers', :as => :your_member_followers
  
  get '/addresses/states_for_country', :to => 'addresses#states_for_country'
  get '/addresses/cities_for_country_and_state_autocomplete', :to => 'addresses#cities_for_country_and_state_autocomplete'

  devise_for :members, :path => '/account', :controllers => {:registrations => 'members/accounts', :sessions => 'members/sessions', :passwords => 'members/passwords', :omniauth_callbacks => 'members/omniauth_callbacks'} 
  
  devise_scope :member do
    match '/account/change_password', :controller => 'members/accounts', :action => 'change_password', :as => :member_change_password
    put '/account/update_password', :controller => 'members/accounts', :action => 'update_password', :as => :member_update_password
    match '/account/cancel_account', :controller => 'members/accounts', :action => 'cancel_account', :as => :member_cancel_account
    match '/account/subscriptions', :controller => 'members/accounts', :action => 'subscriptions', :as => :member_subscriptions
    put '/account/update_subscriptions', :controller => 'members/accounts', :action => 'update_subscriptions', :as => :member_update_subscriptions
    match '/account/privacy', :controller => 'members/accounts', :action => 'privacy', :as => :member_privacy
    put '/account/update_privacy', :controller => 'members/accounts', :action => 'update_privacy', :as => :member_update_privacy
    put '/account/follow_toggle/:followable_type/:followable_id', :controller => 'members/accounts', :action => 'follow_toggle', :as => :follow_toggle
    match '/account/load_current_member', :controller => 'members/accounts', :action => 'load_current_member'    
    get '/account/participant/new', :controller => 'participants', :action => 'new', :as => :member_new_participant
    post '/account/participant/create', :controller => 'participants', :action => 'create', :as => :member_create_participant    
    get '/account/participant/edit', :controller => 'participants', :action => 'edit', :as => :member_edit_participant
    put '/account/participant/update', :controller => 'participants', :action => 'update', :as => :member_update_participant    
    get '/account/participant/enter_your_pin', :controller => 'participants', :action => 'enter_your_pin', :as => :member_enter_your_pin_participant 
    put '/account/participant/store_pin', :controller => 'participants', :action => 'store_pin', :as => :member_store_pin_participant
  end

  resources :members, :controller => 'members/profiles', :path => '/members', :only => [:index, :show] do 
    collection do
      get '(page/:page)', :action => 'index'
      get 'publishers(/page/:page)', :action => 'publishers', :as => :publishers
      get 'tagged/:tag(/page/:page)', :action => 'by_tag'
      get 'autocomplete', :action => 'autocomplete'
    end
    member do
      get '(page/:page)', :action => 'show'
      get 'surveys(/page/:page)', :action => 'surveys', :as => :surveys
      get 'reports(/page/:page)', :action => 'reports', :as => :reports
      get 'following', :action => 'following', :as => :following
      get 'followed-by', :action => 'followed_by', :as => :followed_by
    end
  end
  
  resources :member_statuses, :controller => 'members/statuses', :path => '/statuses', :only => [:index, :show, :new, :create, :destroy] do 
    collection do
      get '(page/:page)', :action => 'index'
      get 'tagged/:tag(/page/:page)', :action => 'by_tag'
    end
  end

  match '/~', :controller => 'members/profiles', :action => 'your_profile', :as => :member_your_profile

  resources :member_tokens, :only => [:index, :destroy], :controller => 'members/tokens', :path => '/account/sign-in-tokens'

  resources :participants, :only => [:index, :show] do 
    member do 
      get 'show_responses/:survey_taken_id', :action => 'show_responses', :as => :show_responses
    end
    collection do 
      get 'gmap'
      match 'by_city'
      match 'by_anonymous_key'
      get 'by_categories'
    end
  end
  
  resources :messages, :only => [:index, :show, :new, :create] do 
    collection do 
      get 'unread'
    end
  end
  
  resources :reports do 
    member do
      put 'save_and_run'
      put 'save_and_continue'
      put 'save_and_exit'
      put 'publish' 
      put 'forkit' 
      get 'output'
      get 'surveys(/page/:page)', :action => 'surveys', :as => :surveys
      get 'forks(/page/:page)', :action => 'forks', :as => :forks
      get 'code'
      get 'results'
      get 'view_code'
    end
    collection do 
      get '(page/:page)', :action => 'index'
      get 'pending(/page/:page)', :action => 'pending', :as => :pending
      get 'published(/page/:page)', :action => 'published', :as => :published
      get 'passing(/page/:page)', :action => 'passing', :as => :passing
      get 'failing(/page/:page)', :action => 'failing', :as => :failing
      get 'tagged/:tag(/page/:page)', :action => 'by_tag', :as => :tagged
    end
  end

  resources :surveys, :except => [:index] do
    collection do
      get '(page/:page)', :action => 'index'
      get 'drafting(/page/:page)', :action => 'drafting', :as => :drafting
      get 'review_requested(/page/:page)', :action => 'review_requested', :as => :review_requested
      get 'rejected(/page/:page)', :action => 'rejected', :as => :rejected
      get 'open(/page/:page)', :action => 'launched', :as => :launched
      get 'published(/page/:page)', :action => 'published', :as => :published
      get 'tagged/:tag(/page/:page)', :action => 'by_tag', :as => :tagged
      get 'find_and_add_target_survey', :action => 'find_and_add_target_survey', :as => :find_and_add_target_survey
      put 'add_target_survey', :action => 'add_target_survey', :as => :add_target_survey
    end
    member do
      put 'submit_for_review'
      put 'launch'
      put 'reject'
      put 'request_changes'
      put 'close'
      match 'participate'
      put 'store_pin'
      match 'new_participant'
      post 'create_participant'
      post 'create_response'
      get 'demographics'
      get 'downloads(/page/:page)', :action => 'downloads', :as => 'downloads'
      get 'reports(/page/:page)', :action => 'reports', :as => 'reports'
      put 'forkit'
      get 'forks(/page/:page)', :action => 'forks', :as => :forks
      get 'followed-by(/page/:page)', :action => 'followed_by', :as => :followed_by
    end
    resources :survey_questions, :path => 'questions', :as => :questions do
      member do        
        get 'results' 
      end
      collection do
        put 'update_positions'
        get 'survey_question_choice_id_options'
      end
    end
    resources :participant_responses
  end
   
  root :to => 'welcome#index'
  
  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  mount Refinery::Core::Engine, :at => '/'
end
