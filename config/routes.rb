ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resource :privacy_policy
  map.resource :sitemap
  
  map.resources :iterations, :collection => { :finished => :get, :planned => :get }
  map.resources :keyboard_shortcuts
  map.resources :payment_methods
  map.resources :invoices
  map.resources :story_team_members

  map.resources :organisations do |organisation|
    organisation.resources :members, :controller => 'organisation_members'
    # organisation.resource :payment_method
  end

  map.resources :stories, :except => :index
  map.resources :projects do |project|
    project.resources :iterations do |iteration|
      iteration.resources :stories
    end
    project.resources(:stories, 
                      :member => {
                        :estimate => :get
                      },
                      :collection => { 
                        :backlog => :get,
                        :finished => :get 
                      }) do |story|
      story.resources :acceptance_criteria
    end
  end

  map.resources :users do |user|
    user.resource :verification, :controller => 'user_verifications', :only => [:new]
    user.resource :acknowledgement, :controller => 'user_acknowledgements'
  end
  map.verification '/users/:user_id/verification',
    :controller => 'user_verifications', :action => 'create'

  map.resources :iterations do |iteration|
    iteration.resource :burndown
    iteration.resource :active_iteration
  end

  map.resource :verification_notification
  map.resource :home, :controller => 'home'

  map.agile_terminology '/agile_terminology/:action', :controller => 'agile_terminology'

  map.root :controller => 'public', :action => 'show'
end
