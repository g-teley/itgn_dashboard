class DataController < ApplicationController

  before_action :require_login

  def report1
    begin
      user_id = params[:user_id].nil? ? User.current.id : params[:user_id]
      settings = ItgnDashboardSetup.where(:user_id => user_id, :report_id => 1).first
      if settings.enabled == 0
        data = nil
      else
        data = getData(settings)
      end
    rescue StandardError => ex
      logger.error('Report 1 error : ' + ex.message)
      data = nil
    end
    if request.xhr?
      render json: data
    end
  end

  def report2
    begin
      user_id = params[:user_id].nil? ? User.current.id : params[:user_id]
      settings = ItgnDashboardSetup.where(:user_id => user_id, :report_id => 2).first
      if settings.enabled == 0
        data = nil
      else
        data = getData(settings)
      end
    rescue StandardError => ex
      logger.error('Report 2 error : ' + ex.message)
      data = nil
    end
    render json: data
  end

  def report3
    begin
      user_id = params[:user_id].nil? ? User.current.id : params[:user_id]
      settings = ItgnDashboardSetup.where(:user_id => user_id, :report_id => 3).first
      if settings.enabled == 0
        data = nil
      else
        data = getData(settings)
      end
    rescue StandardError => ex
      logger.error('Report 3 error : ' + ex.message)
      data = nil
    end
    if request.xhr?
      render json: data
    end
  end

  def report4
    begin
      user_id = params[:user_id].nil? ? User.current.id : params[:user_id]
      settings = ItgnDashboardSetup.where(:user_id => user_id, :report_id => 4).first
      if settings.enabled == 0
        data = nil
      else
        data = getData(settings)
      end
    rescue StandardError => ex
      logger.error('Report 4 error : ' + ex.message)
      data = nil
    end
    if request.xhr?
      render json: data
    end
  end

  def report5
    begin
      user_id = params[:user_id].nil? ? User.current.id : params[:user_id]
      settings = ItgnDashboardSetup.where(:user_id => user_id, :report_id => 5).first
      if settings.enabled == 0
        data = nil
      else
        data = getData(settings)
      end
    rescue StandardError => ex
      logger.error('Report 5 error : ' + ex.message)
      data = nil
    end
    if request.xhr?
      render json: data
    end
  end

  def report6
    begin
      user_id = params[:user_id].nil? ? User.current.id : params[:user_id]
      settings = ItgnDashboardSetup.where(:user_id => user_id, :report_id => 6).first
      if settings.enabled == 0
        data = nil
      else
        data = getData(settings)
      end
    rescue StandardError => ex
      logger.error('Report 6 error : ' + ex.message)
      data = nil
    end
    if request.xhr?
      render json: data
    end
  end

private
  # Specify standard reports which are selectable thrue the user settings
  # Don't change these without changing the descriptions in the locale file!
  def getData(settings)
    report_id = settings.std_report_id
    data = case report_id
    when 1 then std_report1(settings)
    when 2 then std_report2(settings)
    when 3 then std_report3(settings)
    when 4 then std_report4(settings)
    when 5 then std_report5(settings)
    when 6 then std_report6(settings)
    when 7 then std_report7(settings)
    when 8 then std_report8(settings)
    when 9 then std_report9(settings)
    when 10 then std_report10(settings)
    when 11 then std_report11(settings)
    else ''
    end
    data
  end

  # Actual reporting work done here in their respective models
  #
  # Report on Projects with privacy risk
  def std_report1(settings)
    r1 = Report1.new(settings)
    r1.data
  end
  # Report on Number of issues per project where the due date is passed
  def std_report2(settings)
    r2 = Report2.new(settings)
    r2.data
  end
  # Report on Process per Done ratio
  def std_report3(settings)
    r3 = Report3.new(settings)
    #logger.info("Report 3 fetched #{r3.num_series} series")
    r3.data
  end
  # Report on Statuses per Process
  def std_report4(settings)
    r4 = Report4.new(settings)
    r4.data
  end
  # Report on Time spent per project per activity
  def std_report5(settings)
    r5 = Report5.new(settings)
    r5.data
  end
  # Report on Done ratio per Process activity
  def std_report6(settings)
    r6 = Report6.new(settings)
    r6.data
  end
  # Report on Capability rating
  def std_report7(settings)
    r7 = Report7.new(settings)
    r7.data
  end
  # Report on Status per tracker
  def std_report8(settings)
    r8 = Report8.new(settings)
    r8.data
  end
  # Report on Custom field with trackers
  def std_report9(settings)
    r9 = Report9.new(settings)
    r9.data
  end
  # Report on Custom Field
  def std_report10(settings)
    r10 = Report10.new(settings)
    r10.data
  end
  # Test Report on %Done
  def std_report11(settings)
    r11 = Report11.new(settings)
    r11.data
  end

  def require_login
    if User.current.nil?
      render json: "No valid user!"
    end
  end
end
