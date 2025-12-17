# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'itgn_dashboard_setup', :to => 'setup#index'
post 'itgn_dashboard/setup/report1', :to => 'setup#report1'
post 'itgn_dashboard/setup/report2', :to => 'setup#report2'
post 'itgn_dashboard/setup/report3', :to => 'setup#report3'
post 'itgn_dashboard/setup/report4', :to => 'setup#report4'
post 'itgn_dashboard/setup/report5', :to => 'setup#report5'
post 'itgn_dashboard/setup/report6', :to => 'setup#report6'
get 'itgn_dashboard', :to => 'report#index'
get 'itgn_dashboard/setup/report1', :to => 'setup#report1'
get 'itgn_dashboard/setup/report2', :to => 'setup#report2'
get 'itgn_dashboard/setup/report3', :to => 'setup#report3'
get 'itgn_dashboard/setup/report4', :to => 'setup#report4'
get 'itgn_dashboard/setup/report5', :to => 'setup#report5'
get 'itgn_dashboard/setup/report6', :to => 'setup#report6'
get 'itgn_dashboard/data/report1', :controller => 'data', :action => 'report1', :via => [:get]
get 'itgn_dashboard/data/report2', :controller => 'data', :action => 'report2', :via => [:get]
get 'itgn_dashboard/data/report3', :controller => 'data', :action => 'report3', :via => [:get]
get 'itgn_dashboard/data/report4', :controller => 'data', :action => 'report4', :via => [:get]
get 'itgn_dashboard/data/report5', :controller => 'data', :action => 'report5', :via => [:get]
get 'itgn_dashboard/data/report6', :controller => 'data', :action => 'report6', :via => [:get]

