Rails.application.routes.draw do
   get '/index', to: 'app/front#index', as: :app_index
  
  #get '/index', to: 'app/front#index', as: :app_index
  root to: 'app/front#index'

  devise_for :users, skip: KepplerConfiguration.skip_module_devise

  namespace :admin do
    resources :stack_banks, except: [:edit] do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :percentage_costs, except: [:destroy] do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :payments, except: [:destroy] do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      get '/inspect', action: 'inspect'
      get '/history', action: 'history'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :asignations do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      get '/inspect', action: 'inspect'
      get '/history', action: 'history'
      get '/report',action: :report, on: :collection, as: 'report'
      post '/create_report',action: :create_report,on: :collection, as: 'create_report'
      get '/report_order',action: :report_order, on: :collection, as: 'report_order'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :states do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :customizes do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/install_default', action: 'install_default'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    root to: 'admin#root'

    resources :users, except: [:destroy] do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/inspect', action: 'inspect'
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :meta_tags do
      get '(page/:page)', action: :index, on: :collection, as: ''
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :google_adwords do
      get '(page/:page)', action: :index, on: :collection, as: ''
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :google_analytics_tracks do
      get '(page/:page)', action: :index, on: :collection, as: ''
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :settings, only: [] do
      collection do
        get '/:config', to: 'settings#edit', as: ''
        put '/:config', to: 'settings#update', as: 'update'
        put '/:config/appearance_default', to: 'settings#appearance_default', as: 'appearance_default'
      end
    end
  end

  ##desde aqui lo nuevo
  ##asignation en las ordedes
  get'/asignations/:order_id', to: "admin/asignations#order", as: :asignation_order
 
  post 'admin/asignations/order', as: 'asignations_order'##esta   es una   usad
  post 'admin/asignations/phase', as: 'asignations_phase' ## esa es de la actividad
  post 'admin/payments/asignation', as: 'payments_asignation'##esta la use en los pagos
  post 'admin/asignations/user', as: 'asignations_user' ##este me da los trabajadores
  post 'app/banks/cod', as: 'banks_name' ##este es el codigo de banco

  
  ##frontend


  resources :banks, controller:"app/banks", as: :banks, except: [:index,:show,:delete]
  resources :experiences, controller:"app/experiences", as: :experiences, except: [:index,:show,:delete]
  
  get "/employees/index", to: "app/employees#index", as: :app_employees_index
  get "/employees/asignation", to: "app/employees#asignation", as: :app_employees_asignation
  get "/employees/payment", to: "app/employees#payment", as: :app_employees_payment
  get "/employees/report", to: "app/employees#report", as: :app_employees_report
  post "app/employees/create_report", to: "app/employees#create_report", as: :app_employees_create_report
  
  get "app/employees/:asignation_id", to: "app/employees#partial_asignation", as: :app_employees_partial_asignation
  get "app/employees/payment/:asignation_id", to: "app/employees#partial_payment", as: :app_employees_partial_payment
   
  get "users/pending",to:"app/users#pending", as: :app_users_pending
  get "users/locked",to:"app/users#locked", as: :app_users_locked
  

  # Errors routes
  match '/403', to: 'errors#not_authorized', via: :all, as: :not_authorized
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Dashboard route engine
  mount KepplerGaDashboard::Engine, at: 'admin/dashboard', as: 'dashboard'
end
