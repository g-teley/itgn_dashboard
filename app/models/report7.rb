# Report on Capability rating
# fixed_version_id == nil => 0 Incomplete Process
# Do not show level 0
# Fetch all activities with their respective assessed rating and report on this
#
# This report does ignore the version setting because it reports on all versions! (Except 0)

class Report7 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    if settings.nil?
      return nil
    end
    super
    sp = self.projects
    if self.incl_sp
      sp = self.include_subprojects(sp)
    end
    sql = "name LIKE '%5.2%'"
    sql += " OR name LIKE '%5.1%'"
    sql += " OR name LIKE '%4.2%'"
    sql += " OR name LIKE '%4.1%'"
    sql += " OR name LIKE '%3.2%'"
    sql += " OR name LIKE '%3.1%'"
    sql += " OR name LIKE '%2.2%'"
    sql += " OR name LIKE '%2.1%'"
    sql += " OR name LIKE '%1.1%'"
    @versions = Version.where(sql).order(name: :desc).pluck(:id,:name)
    @data = []
    @data += IssueCustomField.select(:possible_values).find(settings.custom_field).possible_values.map {|pv| {
        :name => pv,
        :data => @versions.map {|v| {
            v[1] => CustomValue.where(:custom_field_id => settings.custom_field, :value => pv)
            .joins('INNER JOIN issues ON issues.id = custom_values.customized_id')
            .joins('INNER JOIN projects ON issues.project_id = projects.id')
            .where('projects.id IN (?)', sp.flatten)
            .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
            .where(v[0] == nil ? "issues.fixed_version_id IS NULL":["issues.fixed_version_id = ?",v[0]])
            .count
          }
        }
      }
    }
    # flatten double array to one for Chartkick to recognize it
    @data.each { |d|
      d[:data] = d[:data].flat_map { |a| a.first.is_a?(Array) ? a.map(&:flatten) : [a] }
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

