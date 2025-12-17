# Base class for handling default settings/actions for a report
class Report
=begin
  Extract data for Chartkick reporting
  Remember: Chartkick data is offered as a 2-dimensional data table.
  The column headers are the Legend data
  The row labels are the main series
  The cell data are the values for the legend data per serie
=end

  attr_accessor :maxlen, :projects, :incl_sp, :trackers, :version_query, :category_query, :related_to

  def initialize(settings = nil)
    @maxLen = 20
    @projects = []
    @trackers = []
    @related_to = []
    @version_query = ""
    @category_query = ""
    @incl_sp = false

    unless settings.nil?
      @projects = YAML::load(settings.projects)
      @incl_sp = settings.include_subprojects.to_s.eql?('true') ? true : false
      @trackers = YAML::load(settings.trackers)
      if  settings.exclude_related.to_s.eql?('true')
        @related_to = IssueRelation.select(:issue_from_id).uniq.pluck(:issue_from_id)
      else
        @related_to = []
      end
      if settings.version == 0
        @version_query = "issues.fixed_version_id IS NULL"
      else
        @version_query = ["issues.fixed_version_id = ?",settings.version]
      end
      if settings.category == 0
        @category_query = "issues.category_id IS NULL"
      else
        @category_query = ["issues.category_id = ?", settings.category]
      end
    end
  end
  def maxlen
    @maxLen
  end
  def projects
      @projects
  end
  def incl_sp
    @incl_sp
  end
  def trackers
    @trackers
  end
  def version_query
    @version_query
  end
  def category_query
    @category_query
  end
  def related_to
    @related_to
  end

  # Scale colors in HSL scheme in N steps
  # From red to Green = 0 -> 120
  # From Green to Red = 120 -> 0
  def scale_colors(hue0, hue1, steps)
    series = {}
    (1..steps).each do |i|
      hsl = percentageToHsl((i * 1.0)/steps, hue0, hue1) # Calculate percentage in Nth step
#      print("HSL = #{hsl.inspect}\n")
      rgb = numberToColorHsl(hsl[0])
#      print("RGB = #{rgb.inspect}\n")
      series[i-1] = { :color => '#' + "#{rgb[0].to_s(16).rjust(2, "0")}#{rgb[1].to_s(16).rjust(2, "0")}#{rgb[2].to_s(16).rjust(2, "0")}"  }
    end
#    Rails.logger.info("SC #{steps}-steps => #{series.inspect}")
    series
  end

  # Add subprojects to passed projects list
  def include_subprojects(projects)
    nomore = false
    spids = []
    while nomore == false do
      spids = Project.select(:id).where("parent_id IN (?)",projects).where("id NOT in (?)",projects).pluck(:id)
      if spids != []
        projects += spids
      else
        nomore = true
      end
    end
    projects
  end

  # Fetch all Issue Id's, related Issues included
  # Note that check on project membership is done here!
  def get_all_issue_ids(projects)
    sqlQuery = "SELECT DISTINCT(id) FROM issues WHERE id IN "
    sqlQuery += "( SELECT ir.id FROM ("
    sqlQuery += "   ( 	SELECT issues.id FROM issues INNER JOIN projects ON projects.id = issues.project_id WHERE project_id IN (#{projects.join(',')}) ) UNION ALL"
    sqlQuery += "   ( 	SELECT issue_to_id AS id FROM issue_relations INNER JOIN issues ON issues.id = issue_relations.issue_from_id WHERE project_id IN (#{projects.join(',')}) AND relation_type = 'relates') "
    sqlQuery += ") AS ir )"
    Issue.find_by_sql(sqlQuery)
  end

  private

  # Color conversion routines
  def percentageToHsl(percentage, hue0, hue1)
    hue = (percentage * (hue1 - hue0)) + hue0;
    return [hue, 1, 0.5];
  end

  def numberToColorHsl(i)
    # as the function expects a value between 0 and 1, and red = 0° and green = 120°
    # we convert the input to the appropriate hue value
    hue = i * 1.2 / 360
    # we convert hsl to rgb (saturation 100%, lightness 50%)
    rgb = hslToRgb(hue, 1, 0.5)
    return [ rgb[0],rgb[1],rgb[2] ]
  end

  # adapted from http://en.wikipedia.org/wiki/HSL_color_space
  # h,s,l = hue, saturation, lightness in range 0..1
  # returns r,g,b in range 0..255
  def hslToRgb(h, s, l)
    r=0
    g=0
    b=0
    if(s == 0.0)
        r = g = b = l # achromatic
    else
      q = l < 0.5 ? l * (1.0 + s) : l + s - l * s
      p = 2.0 * l - q
      r = hue2rgb(p, q, (h + 1.0/3.0)) # Need to be float!!
      g = hue2rgb(p, q, h)
      b = hue2rgb(p, q, (h - 1.0/3.0))
    end
    return [(r * 255).round, (g * 255).round, (b * 255).round]
  end

  def hue2rgb(p, q, t)
    if (t < 0.0)
      t += 1.0
    end
    if (t > 1.0)
      t -= 1.0
    end
    if(t < 1.0/6.0)
      return p + (q - p) * 6.0 * t
    end
    if(t < 1.0/2.0)
     return q
    end
    if(t < 2.0/3.0)
      return p + (q - p) * (2.0/3.0 - t) * 6.0
    end
    return p
  end
end
