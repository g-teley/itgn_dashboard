# Report on Process per Done ratio


# Nog bezien wat we hiermee doen.
# Voorlopig is Report 6 een veel zinnigere invulling!


class Report3 < Report

  attr_accessor :data, :num_series
  def initialize (settings = nil)
    super
    sp = self.projects
    if self.incl_sp
      sp = self.include_subprojects(sp)
    end
    #Rails.logger.info("Report 3 - #{sp.inspect}")
    # Determine what done_ratio's have data
    dr = Issue.select(:done_ratio)
      .where(:project_id => sp.flatten)
      .where('issues.id NOT IN (?)', self.related_to == [] ? '':self.related_to)
      .where(self.version_query)
      .where(self.category_query)
      .uniq(:done_ratio)
      .pluck(:done_ratio)
      .sort
    @num_series = dr.count
    #Rails.logger.info("Report 3 - #{dr.inspect}")

    # We need to get all activities, so the related to activities inclusive
    issues = get_all_issue_ids(sp)
    #Rails.logger.info("Report 3 - Issues : #{issues.flatten.inspect}")

    @data = dr.map { |d| {
        :name => "#{d.to_s}%",
        :data => Issue.select(:id)
        .joins(:project)
        .where(:id => issues)
        .where(self.version_query)
        .where(self.category_query)
        .where(:done_ratio => d)
        .group("SUBSTR(projects.name,1,#{self.maxlen})")
        .count
      }
    }
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

