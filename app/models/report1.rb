 # Report on Projects with privacy risk

class Report1 < Report
  attr_accessor :data, :num_series

  def initialize (settings = nil)
    super
    sp = self.projects
    if self.incl_sp
      sp = self.include_subprojects(sp)
    end
    pcf = ProjectCustomField.where(:name => "Privacy risk").select(:id).first
    @data = CustomValue.joins('INNER JOIN projects ON projects.id = custom_values.customized_id')
    .where("projects.id IN (?)",sp.flatten)
    .where(:custom_field_id => pcf)
    .where(:value => ['Low','Medium','High'])
    .group(:value)
    .count
    # Change privacy level labels for ordering
    mappings = {"Low" => "01 Low", "Medium" => "02 Medium","High" => "03 High"}
    @data = data.map { |k,v| [mappings[k],v]}.to_h.sort
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
