# Report on Issue Status per tracker

class Report8 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super
    # Fetch only statuses with data
    @data = []
    IssueStatus.order(:position).uniq.map { |is|
      temp = {
        :name => is.name,
        :data => Issue.where(:status_id => is.id)
        .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
        .where(self.version_query)
        .where(self.category_query)
        .where("tracker_id in (?)",self.trackers)
        .joins('INNER JOIN issue_statuses ON issues.status_id = issue_statuses.id')
        .joins('INNER JOIN trackers ON issues.tracker_id = trackers.id')
        .group('trackers.name').count
      }
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

