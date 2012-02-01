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

  devise_for :members, :controllers => {:registrations => 'members/accounts', :sessions => 'members/sessions', :omniauth_callbacks => 'members/omniauth_callbacks'} do
    match '/members/change_password', :controller => 'members/accounts', :action => 'change_password', :as => :member_change_password
    put '/members/update_password', :controller => 'members/accounts', :action => 'update_password', :as => :member_update_password
    match '/members/cancel_account', :controller => 'members/accounts', :action => 'cancel_account', :as => :member_cancel_account
    match '/members/subscriptions', :controller => 'members/accounts', :action => 'subscriptions', :as => :member_subscriptions
    put '/members/update_subscriptions', :controller => 'members/accounts', :action => 'update_subscriptions', :as => :member_update_subscriptions
    match '/members/privacy', :controller => 'members/accounts', :action => 'privacy', :as => :member_privacy
    put '/members/update_privacy', :controller => 'members/accounts', :action => 'update_privacy', :as => :member_update_privacy
    put '/members/follow_toggle/:followable_type/:followable_id', :controller => 'members/accounts', :action => 'follow_toggle', :as => :follow_toggle
    match '/members/load_current_member', :controller => 'members/accounts', :action => 'load_current_member'
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

  resources :member_tokens, :only => [:index, :destroy], :controller => 'members/tokens', :path => '/members/accounts/sign-in-tokens'

  resources :participants, :only => [:index, :show, :new, :create] do 
    member do 
      get 'show_responses/:survey_taken_id', :action => 'show_responses', :as => :show_responses
    end
    collection do 
      get 'gmap'
      match 'by_city'
      match 'by_anonymous_key'
      get 'by_categories'
      get 'edit'
      put 'update'
      get 'enter_your_pin'
      put 'store_pin'
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
  
  resources :pages, :only => [:show], :path => '/', :constraints => lambda { |req|  
      (req.env["REQUEST_PATH"] =~ /\/members\/auth\//).nil? 
    }
  
  # Temp patch until fix is posted for rails_admin
  match '/members/sign_out', :controller => 'devise/sessions', :action => 'destroy'
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
   
  root :to => 'welcome#index'
end
