# Report on Statuses per Process

class Report4 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super
    sp = self.projects
    if self.incl_sp
      sp = self.include_subprojects(sp)
    end
    issues = get_all_issue_ids(sp.flatten)
    # Get all possible values
    pv = Issue.where(:id => issues).select(:status_id).uniq.pluck(:status_id)
    # Get results in the right order
    pvs = IssueStatus.where(:id=>pv).select(:id).order(:position).pluck(:id)

    @data = pvs.map { |s| {
        :name => IssueStatus.find(s).name,
        :data => Issue.where(:status_id => s)
        .where(:id => issues)
        .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
        .where(self.version_query)
        .where(self.category_query)
        .joins(:project)
        .group("SUBSTR(projects.name,1,#{self.maxlen})")
        .count
      }
    }
    # Make first series include all possible processes to make chartkick display all processes on the x-axis in the correct order
    unless @data.count < 2 # Must have at least 2 series
      for i in 1..@data.count - 1 do # traverse other series
        @data[i][:data].keys.each do |k|
          if !@data[0][:data].key?(k) # check if key is in first series
            @data[0][:data][k] = 0 # if not, add it with value 0
          end
        end
      end
      data[0][:data] = data[0][:data].sort
    end
    @num_series = @data.count
    @data
  end

  def data
    @data
  end

  def num_series
    @num_series
  end

private
  def get_all_issue_ids(projects = nil)
    super
  end
end
