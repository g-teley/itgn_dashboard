# Report on Number of issues per project where the due date is passed

class Report2 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super
    @data = []
    self.projects.map { |p|
      #Rails.logger.info("Report 2 - #{p}")
      sp = [p]
      if self.incl_sp
        sp = self.include_subprojects(sp)
      end
      #Rails.logger.info("Report pids - #{sp}")
      temp = {
        :name => Project.select("name").find(p).name[0..self.maxlen],
        :data => Issue.where("project_id IN (?) and due_date < ?",sp.flatten,Date.today)
        .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
        .where(self.version_query)
        .where(self.category_query)
        .joins(:project)
        .group("SUBSTR(projects.name,1,#{self.maxlen})")
        .count
      }
      # Discard empty processes
      unless temp[:data].keys.count == 0
        @data << temp
      end
    }
    @num_series = @data.count
    @data
  end

  def data
    @data
  end

  def num_series
    @num_series
  end
end
