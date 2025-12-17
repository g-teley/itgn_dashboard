# Report on Custom Field and process

class Report10 < Report

  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super
    sp = self.projects
    if self.incl_sp
      sp = self.include_subprojects(sp)
    end
    @data = []
    IssueCustomField.where(:id => settings.custom_field).select([:id,:possible_values]).each {|i|
      @data += i.possible_values.map { |pv| {
          :name => pv,
          :data => CustomValue.where(:custom_field_id => i.id, :value => pv)
          .joins('INNER JOIN issues ON issues.id = custom_values.customized_id')
          .joins('INNER JOIN projects ON projects.id = issues.project_id')
          .where('issues.id NOT IN (?)',self.related_to == [] ? '':self.related_to)
          .where(self.version_query)
          .where(self.category_query)
          .where("projects.id IN (?)",sp.flatten)
          .group("SUBSTR(projects.name,1,#{self.maxlen})")
          .count
        }
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
      #data[0][:data] = data[0][:data].sort
    end

    @data.each { |d|
      d[:data] = d[:data].sort
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

