class SetupController < ApplicationController

  MY_VERSION = "2.5.0"

  def index
    begin
      @chart_types = [ # Standard chart type per report
        'pie',
        'column',
        'bar',
        'column',
        'bar',
        'line',
        'bar',
        'bar',
        'bar',
        'bar'
      ]
      # Fixed defined color schemes are placed in the settings.series after selection
      @color_schemes = {
        0 => { # Standard = let Chartkick decide
        },
        1 => { # Qualitative
          0 => { :color => '#a6cee3'},
          1 => { :color => '#1f78b4'},
          2 => { :color => '#b2df8a'},
          3 => { :color => '#33a02c'},
          4 => { :color => '#fb9a99'},
          5 => { :color => '#e31a1c'},
          6 => { :color => '#fdbf6f'},
          7 => { :color => '#ff7f00'},
          8 => { :color => '#cab2d6'},
          9 => { :color => '#6a3d9a'}
        },
        2 => { # Red -> Green 5 steps from http://colorbrewer2.org
          0 => { :color => '#d7191c'},
          1 => { :color => '#fdae61'},
          2 => { :color => '#ffffbf'},
          3 => { :color => '#a6d96a'},
          4 => { :color => '#1a9641'}
        },
        3 => { # Red -> Green 10 step from http://colorbrewer2.org
          0 => { :color => '#a50026'},
          1 => { :color => '#d73027'},
          2 => { :color => '#f46d43'},
          3 => { :color => '#fdae61'},
          4 => { :color => '#fee08b'},
          5 => { :color => '#d9ef8b'},
          6 => { :color => '#a6d96a'},
          7 => { :color => '#66bd63'},
          8 => { :color => '#1a9850'},
          9 => { :color => '#006837'}
        },
        4 => { # Red -> Green 6 steps with first grey
          0 => { :color => 'grey'},
          1 => { :color => '#d7191c'},
          2 => { :color => '#fdae61'},
          3 => { :color => '#ffffbf'},
          4 => { :color => '#a6d96a'},
          5 => { :color => '#1a9641'}
        },
        5 => { # Red -> Green 11 steps with first grey
          0 => { :color => 'grey'},
          1 => { :color => '#a50026'},
          2 => { :color => '#d73027'},
          3 => { :color => '#f46d43'},
          4 => { :color => '#fdae61'},
          5 => { :color => '#fee08b'},
          6 => { :color => '#d9ef8b'},
          7 => { :color => '#a6d96a'},
          8 => { :color => '#66bd63'},
          9 => { :color => '#1a9850'},
          10 => { :color => '#006837'}
        },
        6 => { # Brown -> Blue 5 steps from http://colorbrewer2.org
          0 => { :color => '#a6611a'},
          1 => { :color => '#dfc27d'},
          2 => { :color => '#f5f5f5'},
          3 => { :color => '#80cdc1'},
          4 => { :color => '#018571'}
        },
        7 => { # Brown -> Blue 10 step from http://colorbrewer2.org
          0 => { :color => '#543005'},
          1 => { :color => '#8c510a'},
          2 => { :color => '#bf812d'},
          3 => { :color => '#dfc27d'},
          4 => { :color => '#f6e8c3'},
          5 => { :color => '#c7eae5'},
          6 => { :color => '#80cdc1'},
          7 => { :color => '#35978f'},
          8 => { :color => '#01665e'},
          9 => { :color => '#003c30'}
        },
        8 => { # Brown -> Blue 6 steps with first grey
          0 => { :color => 'grey'},
          1 => { :color => '#a6611a'},
          2 => { :color => '#dfc27d'},
          3 => { :color => '#f5f5f5'},
          4 => { :color => '#80cdc1'},
          5 => { :color => '#018571'}
        },
        9 => { # Brown -> Blue 11 steps with first grey
          0 => { :color => 'grey'},
          1 => { :color => '#543005'},
          2 => { :color => '#8c510a'},
          3 => { :color => '#bf812d'},
          4 => { :color => '#dfc27d'},
          5 => { :color => '#f6e8c3'},
          6 => { :color => '#c7eae5'},
          7 => { :color => '#80cdc1'},
          8 => { :color => '#35978f'},
          9 => { :color => '#01665e'},
          10 => { :color => '#003c30'}
        },
        10 => {},
        11 => {}
        # 10 and 11 are overridden by calculating the scaled series from Red -> Green or Green -> Red
      }
      # Get users
      @users = User.where("type <> 'Anonymoususer'").select([:id, :firstname, :lastname]).order(:lastname)
      @user_id = (params[:user_id].nil? || !User.exists?(:id => params[:user_id])) ? User.current.id : params[:user_id]
      @settingsR1 = ItgnDashboardSetup.where({:user_id => @user_id, :report_id => 1}).first_or_initialize
      if (@settingsR1.new_record?)
        @settingsR1.std_report_id = 1
        @settingsR1.chart_type = @chart_types[0]
        @settingsR1.chart_title = I18n.t("std_report1_chart_title")
        @settingsR1.x_title = I18n.t("std_report1_x_title")
        @settingsR1.y_title = I18n.t("std_report1_y_title")
        @settingsR1.save
      end
      @settingsR2 = ItgnDashboardSetup.where({:user_id => @user_id, :report_id => 2}).first_or_initialize
      if (@settingsR2.new_record?)
        @settingsR2.std_report_id = 2
        @settingsR2.chart_type = @chart_types[1]
        @settingsR2.chart_title = I18n.t("std_report2_chart_title")
        @settingsR2.x_title = I18n.t("std_report2_x_title")
        @settingsR2.y_title = I18n.t("std_report2_y_title")
        @settingsR2.save
      end
      @settingsR3 = ItgnDashboardSetup.where({:user_id => @user_id, :report_id => 3}).first_or_initialize
      if (@settingsR3.new_record?)
        @settingsR3.std_report_id = 3
        @settingsR3.chart_type = @chart_types[2]
        @settingsR3.chart_title = I18n.t("std_report3_chart_title")
        @settingsR3.x_title = I18n.t("std_report3_x_title")
        @settingsR3.y_title = I18n.t("std_report3_y_title")
        @settingsR3.save
      end
      @settingsR4 = ItgnDashboardSetup.where({:user_id => @user_id, :report_id => 4}).first_or_initialize
      if (@settingsR4.new_record?)
        @settingsR4.std_report_id = 4
        @settingsR4.chart_type = @chart_types[3]
        @settingsR4.chart_title = I18n.t("std_report4_chart_title")
        @settingsR4.x_title = I18n.t("std_report4_x_title")
        @settingsR4.y_title = I18n.t("std_report4_y_title")
        @settingsR4.save
      end
      @settingsR5 = ItgnDashboardSetup.where({:user_id => @user_id, :report_id => 5}).first_or_initialize
      if (@settingsR5.new_record?)
        @settingsR5.std_report_id = 5
        @settingsR5.chart_type = @chart_types[4]
        @settingsR5.chart_title = I18n.t("std_report5_chart_title")
        @settingsR5.x_title = I18n.t("std_report5_x_title")
        @settingsR5.y_title = I18n.t("std_report5_y_title")
        @settingsR5.save!
      end
      @settingsR6 = ItgnDashboardSetup.where({:user_id => @user_id, :report_id => 6}).first_or_initialize
      if (@settingsR6.new_record?)
        @settingsR6.std_report_id = 6
        @settingsR6.chart_type = @chart_types[5]
        @settingsR6.chart_title = I18n.t("std_report6_chart_title")
        @settingsR6.x_title = I18n.t("std_report6_x_title")
        @settingsR6.y_title = I18n.t("std_report6_y_title")
        @settingsR6.save!
      end
    rescue StandardError => msg
      logger.error("Setup#Index error #{msg}")
      @errormes = msg
    end
  end

  def report1
    std_report(1)
  end
  def report2
    std_report(2)
  end
  def report3
    std_report(3)
  end
  def report4
    std_report(4)
  end
  def report5
    std_report(5)
  end
  def report6
    std_report(6)
  end

  private

  def std_report(id)
    if request.xhr?
      if request.get?
        settings = ItgnDashboardSetup.where(:user_id => params[:user_id], :report_id => id).first
        if settings.nil?
          render json: {message: I18n.t('error_setting_not_found')}, status: :not_found
        end
        render json: settings, status: :ok
      end
      if request.post?
        settings = ItgnDashboardSetup.where(:user_id => params[:user_id], :report_id => id).first_or_initialize
        settings.enabled = params["enabled"]
        settings.std_report_id = params["std_report_id"]
        settings.chart_type = params["chart_type"]
        settings.chart_title = params["chart_title"]
        settings.x_title = params["x_title"]
        settings.y_title = params["y_title"]
        settings.custom_field = params["custom_field"]
        settings.projects = params["projects"]
        settings.include_subprojects = params["include_subprojects"]
        settings.exclude_related = params["exclude_related"]
        settings.trackers = params["trackers"]
        settings.issues = params["issues"]
        settings.version = params["version"]
        settings.category = params["category"]
        settings.isStacked = params["isStacked"]
        settings.color_scheme = params["color_scheme"]
        settings.series = params["series"]
        if settings.save
          render json: {message: I18n.t('notice_successful_update')}, status: :ok
        else
          render json: {message: I18n.t('error_updating_setting')}, status: 500
        end
      end
    else
      settings = ItgnDashboardSetup.where(:user_id => params[:user_id], :report_id => id).first_or_initialize
      settings.enabled = params["enabled"]
      settings.std_report_id = params["std_report_id"]
      settings.chart_type = params["chart_type"]
      settings.chart_title = params["chart_title"]
      settings.x_title = params["x_title"]
      settings.y_title = params["y_title"]
      settings.custom_field = params["custom_field"]
      settings.projects = params["projects"]
      settings.include_subprojects = params["include_subprojects"]
      settings.exclude_related = params["exclude_related"]
      settings.trackers = params["trackers"]
      settings.issues = params["issues"]
      settings.version = params["version"]
      settings.category = params["category"]
      settings.isStacked = params["isStacked"]
      settings.color_scheme = params["color_scheme"]
      settings.series = params["series"]
      if settings.save
        flash[:notice] = "R#{id} Saved"
      end
      redirect_to :action => 'index', :user_id => params[:user_id]
    end
  end
end
