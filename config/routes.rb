Soepi::Application.routes.draw do
  get '/search(/:page)', :controller => 'search', :action => 'index', :as => :search
  get '/quick_search', :controller => 'search', :action => 'quick_search'

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
  
  resources :members, :controller => 'members/profiles', :path => '/members', :only => [:show] do 
    collection do
      get 'tagged/:tag(/:page)', :action => 'by_tag'
      get 'autocomplete', :action => 'autocomplete'
    end
    member do
      get '(page/:page)', :action => 'show'
      get 'r_scripts(/page/:page)', :action => 'r_scripts', :as => :r_scripts
      get 'reports(/page/:page)', :action => 'reports', :as => :reports
      get 'following', :action => 'following', :as => :following
      get 'followed-by', :action => 'followed_by', :as => :followed_by
    end
  end

  match '/~', :controller => 'members/profiles', :action => 'my_profile', :as => :member_my_profile

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

  resources :r_scripts do 
    member do 
      put 'forkit'
      put 'run'
      get 'code'
      put 'save_and_run'
      put 'save_and_continue'
      put 'save_and_exit'
      get 'settings'
      get 'forks(/page/:page)', :action => 'forks', :as => :forks
      get 'reports(/page/:page)', :action => 'reports', :as => :reports
      get 'followed-by(/page/:page)', :action => 'followed_by', :as => :followed_by
    end
    collection do 
      get '(page/:page)', :action => 'index'
      get 'pending(/page/:page)', :action => 'pending', :as => :pending
      get 'failing(/page/:page)', :action => 'failing', :as => :failing
      get 'passing(/page/:page)', :action => 'passing', :as => :passing
      get 'tagged/:tag(/page/:page)', :action => 'by_tag', :as => :tagged
    end
  
    resources :r_script_inputs, :path => 'inputs', :as => :inputs, :only => [:new, :create, :edit, :update, :destroy] do 
      collection do 
        get 'surveys_auto_complete'
      end
    end
  end
  
  resources :reports do 
    member do
      get 'tagged/:tag(/page/:page)', :action => 'by_tag', :as => :tagged
      get 'output' 
      get 'code'
      put 'publish' 
    end
    collection do 
      get '(page/:page)', :action => 'index'
      get 'drafting(/page/:page)', :action => 'drafting', :as => :drafting
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
      get 'completes'
      get 'downloads'
      put 'forkit'
      get 'forks(/page/:page)', :action => 'forks', :as => :forks
      get 'followed-by(/page/:page)', :action => 'followed_by', :as => :followed_by
    end
    resources :survey_questions, :path => 'questions', :as => :questions do
      collection do
        put 'update_positions'
        get 'survey_question_choice_id_options'
      end
    end
    resources :participant_responses
  end
  
  resources :pages, :only => [:show]
  
  # Temp patch until fix is posted for rails_admin
  match '/members/sign_out', :controller => 'devise/sessions', :action => 'destroy'
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
   
  root :to => 'pages#home'
  get '/notifications', :to => 'pages#notifications'
  
  match '*path' => 'pages#show', :constraints => lambda{ |req|  
    (req.env["REQUEST_PATH"] =~ /\/members\/auth\//).nil? 
  }
end
