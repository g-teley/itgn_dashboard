# Report on Done ratio per Process activity

class Report6 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super
    @data = []
    self.projects.map { |p|
      sp = [p]
      if self.incl_sp
        sp = self.include_subprojects(sp)
      end
#Rails.logger.info("Report 6 - #{sp.inspect}")

      temp = {
        :name => Project.select("name").find(p).name[0..self.maxlen],
        :data => Issue.where(:project_id => sp.flatten)
        .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
        .where(self.version_query)
        .where(self.category_query)
        .group(:done_ratio).count
      }
      # Discard empty items
      #unless temp[:data].keys.count == 0
        @data << temp
      #end
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
