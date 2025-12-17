# Report on Time spent per project per activity
class Report5 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super
    @data = []
    self.projects.map { |p|
      sp = [p]
      if self.incl_sp
        sp = self.include_subprojects(sp)
      end
      temp = {
        :name => Project.select("name").find(p).name[0..self.maxlen],
        :data => TimeEntry.joins(:project,:activity).joins(:issue)
        .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
        .where(self.version_query)
        .where(self.category_query)
        .where(:project_id => sp.flatten)
        .group("enumerations.name")
        .sum(:hours)
      }
      @data << temp
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
