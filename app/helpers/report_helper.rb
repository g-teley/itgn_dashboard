module ReportHelper

  def get_opts(settings)
    opts = {}
    begin
      series = settings.series
      # If color_scheme > 9, calculate the colors for the actual amount of series
      # Unfortunately, we have to do most of the report work to find out how many series there will be
      cs = settings.color_scheme.to_i
      colors = [] # Used for Pie chart colors
      if cs > 9
        # For what report is this?
        p1 = cs == 10 ? 0:120
        p2 = cs == 10 ? 120:0
        case settings.std_report_id
          when 1 # Report on Projects with privacy risk
            r1 = Report1.new(settings)
            series = r1.scale_colors(p1,p2,r1.num_series)
            (1..r1.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 2 # Report on Number of issues per project where the due date is passed
            r2 = Report4.new(settings)
            series = r2.scale_colors(p1,p2,r2.num_series)
            (1..r2.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 3 # Report on Process per Done ratio
             r3 = Report3.new(settings)
            series = r3.scale_colors(p1,p2,r3.num_series)
            (1..r3.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 4
            r4 = Report4.new(settings)
            series = r4.scale_colors(p1,p2,r4.num_series)
            (1..r4.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 5
            r5 = Report5.new(settings)
            series = r5.scale_colors(p1,p2,r5.num_series)
            (1..r5.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 6
            r6 = Report6.new(settings)
            series = r6.scale_colors(p1,p2,r6.num_series)
            (1..r6.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 7
            r7 = Report7.new(settings)
            series = r7.scale_colors(p1,p2,r7.num_series)
            (1..r7.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 8
            r8 = Report8.new(settings)
            series = r8.scale_colors(p1,p2,r8.num_series)
            (1..r8.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 9
            r9 = Report9.new(settings)
            series = r9.scale_colors(p1,p2,r9.num_series)
            (1..r9.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 10
            r10 = Report10.new(settings)
            series = r10.scale_colors(p1,p2,r10.num_series)
            (1..r10.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
          when 11
            r11 = Report11.new(settings)
            series = r11.scale_colors(p1,p2,r11.num_series)
            (1..r11.num_series).each do |c|
              i = c-1
              colors[i] = series[i][:color]
            end
        else
        end
      end
      case settings.chart_type
        when 'line'
          opts = {
          :isStacked => settings.isStacked,
          :title => settings.chart_title,
          :chartArea => {left:'10%', width:'65%'},
          :legend => {position: "right"},
          :hAxis => { title: settings.x_title},
          :vAxis => { title: settings.y_title},
          :series => series
        }
      when 'bar'
        opts = {
          :isStacked => settings.isStacked,
          :title => settings.chart_title,
          :chartArea => {left:'10%', width:'65%'},
          :legend => {position: "right"},
          :hAxis => { title: settings.x_title},
          :vAxis => { title: settings.y_title},
          :series => series
        }
      when 'pie'
        # Pie needs colors in separate array

        opts = {
          :title => settings.chart_title,
          :chartArea => {left:'10%', width:'85%'},
          :legend => {position: "right"},
          :series => series,
          :colors => colors
        }
      when 'area'
        opts = {
          :isStacked => settings.isStacked,
          :title => settings.chart_title,
          :chartArea => {left:'10%', width:'65%'},
          :legend => {position: "right"},
          :hAxis => { title: settings.x_title},
          :vAxis => { title: settings.y_title},
          :series => series
        }
      when 'column'
        opts = {
          :isStacked => settings.isStacked,
          :title => settings.chart_title,
          :chartArea => {left:'10%', width:'65%'},
          :legend => {position: "right"},
          :hAxis => { title: settings.x_title},
          :vAxis => { title: settings.y_title},
          :series => series
        }
      else
        opts = {
          :title => settings.chart_title,
          :position => "center",
          :chartArea => {left:0, width:'70%'},
          :hAxis => {
            :title => settings.x_title
          },
          :vAxis => {
            # Adds titles to each axis.
            0 => {title: 'vA0 Title'},
            1 => {title: 'vA1 Title'}
          },
          :series => {
            0 => {targetAxisIndex: 0},
            1 => {targetAxisIndex: 1}
          }
        }
      end
    rescue StandardError => ex
      logger.error("Error getting options: #{ex.message}")
      opts = {
        :isStacked => false,
        :title => "Chart Title",
        :chartArea => {left:'10%', width:'65%'},
        :legend => {position: "right"},
        :hAxis => { title: "X-Title"},
        :vAxis => { title: "Y-Title"},
        :series => {}
      }
    end
    #logger.info("GetOpts => #{opts.inspect}")
    opts
  end
  # Get all users who have a dashboard configured
  def select_configured_users(sel_id)
    @html = select_tag(:user_id, options_for_select(User.joins("INNER JOIN itgn_dashboard_setups ON itgn_dashboard_setups.user_id = users.id").where("itgn_dashboard_setups.enabled=1").uniq.collect{|u| ["#{u}",u.id]}, sel_id))
    @html
  end

end
