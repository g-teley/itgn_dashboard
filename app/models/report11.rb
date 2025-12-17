# Report on total hourse spent per Process activity in a COBIT way
# Assume Selected projects are level 1 processes
# Sub processes are 'Base Practices'
# All Issues per 'Base Practice' are activities with their subtasks
# Report on Main Level, with all 'Base Practices' total estimated hours' (and calculated hours done)

class Report11 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super settings
    @data = []
#    Rails.logger.info("R11>> Start with #{settings.inspect}")
#    old_logger = ActiveRecord::Base.logger
#    ActiveRecord::Base.logger = Logger.new("/usr/local/www/redmine/log/sql.log")

    # Walk through all Base Practices (= all processes with Main level as parent)
    # Per BP, totalise all estimated_hours * done_ratio for all activities with project_id IN [BP]

    self.projects.map { |p| # Main level
      mp = [p]
      bps = self.include_subprojects(mp) - mp # 'Base Practices' minus main process
      bps.map {|bp|
        begin
          temp = {
            :name => Project.select("name").find(bp).name[0..self.maxlen],
            :data => {Project.select("name").find(p).name[0..self.maxlen] => Issue.where(:project_id => bp)
            .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
            .where(self.version_query)
            .where(self.category_query)
            .where('NOT estimated_hours IS NULL') #
            .sum("ROUND((done_ratio * 0.01) * estimated_hours,2)")
          }}
#          Rails.logger.info "R11 Fetched: #{temp.inspect}"
        rescue StandardError => msg
          Rails.logger.error "R11 Error #{msg}"
        end
#        Rails.logger.info("R11>> Data: #{@data.inspect}")
        @data << temp
      }
    }
#    ActiveRecord::Base.logger = old_logger
    @num_series = @data.count
  end

  def data
    @data
  end

  def num_series
    @num_series
  end
end
