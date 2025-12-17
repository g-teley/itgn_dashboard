Redmine::Plugin.register :itgn_dashboard do
  name 'ITGN Reports Dashboard'
  author 'Guus Teley'
  description 'This plugin for Redmine provides a reporting Dashboard for IT Governance and Compliance Management'
  version '2.6.0'
  url 'https://github.com/gteley/itgn_dashboard'
  author_url 'https://www.teley.nl'
  permission :itgn_dashboard, :itgn_dashboard => :dashboard
  menu :admin_menu, :itgn_dashboard, {:controller => 'setup', :action => 'index'}, :caption => 'ITGN Dashboard'
  menu :application_menu, :itgn_dashboard, { :controller => 'report', :action => 'index' }, :caption => 'Dashboard', :first => true, :if => Proc.new {
      ItgnDashboardSetup.where(:user_id => User.current.id, :enabled => 1).count > 0
    }
  settings :default => { 'empty' => true}, :partial => 'setup/itgn_dashboard_setup'
end
=begin

ITGN Dashboard plugin
Copyright Teley Consultancy BV 2015-2025
Licensed under MIT License

Provide a dashboard for IT Governance & Compliance Management Systems

Version History:
2.0.0 - First version named "ITGN Dashboard"
2.1.0 - Changed subprocess handling
2.2.0 - Documentation walkthrough and adjustments
2.3.1 - Fixed empty charts when switching users
2.4.0 - Extended to 11 Standard Reports, upgraded to ChartKick 3
2.5.0 - Fixed issues with migration to Redmine 5.x/Rails 7
2.6.0 - Open source release, removed phone-home, fixed translations
=end