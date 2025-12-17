class CreateItgnDashboardSetups < ActiveRecord::Migration[7.1]
  def self.up
    begin
      drop_table :itgn_dashboard_setups
    rescue
    end
    create_table :itgn_dashboard_setups do |t|
      t.integer :user_id
      t.integer :report_id
      t.integer :enabled, :default => false
      t.integer :std_report_id
      t.integer :version
      t.integer :category
      t.integer :custom_field
      t.string  :chart_type, :default => 'line'
      t.string  :chart_title, :default => ''
      t.string  :x_title, :default => ''
      t.string  :y_title, :default => ''
      t.text  :projects
      t.text  :issues
      t.text  :trackers
      t.text  :options
    end
    add_index :itgn_dashboard_setups, [ :user_id, :report_id ]
    # Migrate data from previous version?
    begin
      if ItgnReportsSetup.exists?
        ItgnReportsSetup.all.each do |i|
          ItgnDashboardSetup.create(
            :user_id => i.user_id,
            :report_id => i.report_id,
            :enabled => i.enabled,
            :std_report_id => i.std_report_id,
            :version => i.version,
            :category => i.category,
            :chart_type => i.chart_type,
            :chart_title => i.chart_title,
            :x_title => i.x_title,
            :y_title => i.y_title,
            :custom_field => i.custom_field,
            :projects => i.projects,
            :issues => i.issues,
            :trackers => i.trackers,
            :options => i.options
          )
        end
      end
    rescue => ex
      print "Error in migrating existing ITGN-Reports data: #{ex.message}\n"
    end
  end

  def self.down
    drop_table :itgn_dashboard_setups
  end
end

