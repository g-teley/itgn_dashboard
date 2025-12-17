class ReportController < ApplicationController

  def index
    begin
      @user_id = (params[:user_id].nil? || !User.exists?(:id => params[:user_id])) ? User.current.id : params[:user_id]

      @settingsR1 = ItgnDashboardSetup.where(:user_id => @user_id, :report_id => 1).first_or_initialize
      if (@settingsR1.new_record?)
        @settingsR1.std_report_id = 1
        @settingsR1.chart_type = 'line'
        @settingsR1.chart_title = ""
        @settingsR1.x_title = ""
        @settingsR1.y_title = ""
        @settingsR1.save
      end
      @settingsR1.chart_title += filtered(@settingsR1)
      @settingsR2 = ItgnDashboardSetup.where(:user_id => @user_id, :report_id => 2).first_or_initialize
      if (@settingsR2.new_record?)
        @settingsR2.std_report_id = 2
        @settingsR2.chart_type = 'pie'
        @settingsR2.chart_title = ""
        @settingsR2.x_title = ""
        @settingsR2.y_title = ""
        @settingsR2.save
      end
      @settingsR2.chart_title += filtered(@settingsR2)
      @settingsR3 = ItgnDashboardSetup.where(:user_id => @user_id, :report_id => 3).first_or_initialize
      if (@settingsR3.new_record?)
        @settingsR3.std_report_id = 3
        @settingsR3.chart_type = 'column'
        @settingsR3.chart_title = "Logins per IP address"
        @settingsR3.x_title = ""
        @settingsR3.y_title = ""
        @settingsR3.save
      end
      @settingsR3.chart_title += filtered(@settingsR3)
      @settingsR4 = ItgnDashboardSetup.where(:user_id => @user_id, :report_id => 4).first_or_initialize
      if (@settingsR4.new_record?)
        @settingsR4.std_report_id = 4
        @settingsR4.chart_type = 'pie'
        @settingsR4.chart_title = ""
        @settingsR4.x_title = ""
        @settingsR4.y_title = ""
        @settingsR4.save
      end
      @settingsR4.chart_title += filtered(@settingsR4)
      @settingsR5 = ItgnDashboardSetup.where(:user_id => @user_id, :report_id => 5).first_or_initialize
      if (@settingsR5.new_record?)
        @settingsR5.std_report_id = 5
        @settingsR5.chart_type = 'line'
        @settingsR5.chart_title = ""
        @settingsR5.x_title = ""
        @settingsR5.y_title = ""
        @settingsR5.save!
      end
      @settingsR5.chart_title += filtered(@settingsR5)
      @settingsR6 = ItgnDashboardSetup.where(:user_id => @user_id, :report_id => 6).first_or_initialize
      if (@settingsR6.new_record?)
        @settingsR6.std_report_id = 6
        @settingsR6.chart_type = 'bar'
        @settingsR6.chart_title = "% Done per process"
        @settingsR6.x_title = ""
        @settingsR6.y_title = ""
        @settingsR6.save!
      end
      @settingsR6.chart_title += filtered(@settingsR6)
    rescue StandardError => msg
      logger.error("ReportController error: #{msg}")
      @errormes = msg
    end
  end
  def filtered(settings)
    if settings.version == 0 and settings.category == 0
      return ''
    end
    if settings.version != 0 and settings.category == 0
      return ' ' + I18n.t("label_filtered_on_version")
    end
    if settings.version == 0 and settings.category != 0
      return ' ' + I18n.t("label_filtered_on_category")
    end
    if settings.version != 0 and settings.category != 0
      return ' ' + I18n.t("label_filtered_on_version_and_category")
    end
  end
end