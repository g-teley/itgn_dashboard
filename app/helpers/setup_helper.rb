module SetupHelper
  $textLen = 49
  # Note! Rails escapes strings added in here, so call html_safe for each!
  def std_tab(nr,settings)
    @html = form_tag("/itgn_dashboard/setup/report#{nr}", {:id => "form#{nr}", :remote => true})
    @html += "<div id=\"tabs#{nr}\">".html_safe()
    @html += "<ul><li><a href=\"#tab-1\">Report #{nr}</a></li><li><a href=\"#tab-2\">Options</a></li></ul>".html_safe()
    @html += '<div id="tab-1">'.html_safe()
    @html += hidden_field_tag(:user_id,settings.user_id)
    @html += hidden_field_tag(:series,settings.series)
    @html += select_enabled(settings.enabled)
    @html += '<br>'.html_safe()
    @html += std_reports(settings.std_report_id)
    @html += '<br>'.html_safe()
    @html += std_custom_field(settings.custom_field)
    @html += '<br>'.html_safe()
    @html += std_projects(YAML::load(settings.projects))
    @html += '<br>'.html_safe()
    @html += std_trackers(YAML::load(settings.trackers))
    @html += '<br>'.html_safe()
    @html += std_version(settings.version)
    @html += '<br>'.html_safe()
    @html += std_category(settings.category)
    @html += '</div>'.html_safe()
    @html += '<div id="tab-2">'.html_safe()
    @html += chart_type(settings.chart_type)
    @html += '<br>'.html_safe()
    @html += select_include_subprojects(settings.include_subprojects)
    @html += '<br>'.html_safe()
    @html += select_exclude_related(settings.exclude_related)
    @html += '<br>'.html_safe()
    @html += label_tag(:chart_title,I18n.t("label_std_chart_title"))
    @html += text_field_tag(:chart_title,settings.chart_title)
    @html += '<br>'.html_safe()
    @html += label_tag(:x_title,I18n.t("label_std_x_title"))
    @html += text_field_tag(:x_title,settings.x_title)
    @html += '<br>'.html_safe()
    @html += label_tag(:y_title,I18n.t("label_std_y_title"))
    @html += text_field_tag(:y_title,settings.y_title)
    @html += '<br>'.html_safe()
    @html += select_stacked(settings.isStacked)
    @html += '<br>'.html_safe()
    @html += std_color_scheme(settings.color_scheme)
    @html += '<br>'.html_safe()
    @html += '<table id="color_table" style="float:right"><tr><td id="c1"></td><td id="c2"></td><td id="c3"></td><td id="c4"></td><td id="c5"></td><td id="c6"></td><td id="c7"></td><td id="c8"></td><td id="c9"></td><td id="c10"></td><td id="c11"></td></tr></table>'.html_safe();
    @html += '</div>'.html_safe()
    @html += submit_tag(value = I18n.t("button_save"))
    @html += '<div id="result_message" class="message">'.html_safe()
    @html += '</div>'.html_safe()
    @html += '</div>'.html_safe()
    @html += '</form>'.html_safe()
    @html
  end
  def select_include_subprojects(sel_id)
    @html = label_tag(:include_subprojects,I18n.t("label_std_include_subprojects"))
    @html += select_tag(:include_subprojects, options_for_select([[I18n.t("general_text_Yes"),true],[I18n.t("general_text_No"),false]], sel_id))
    @html
  end
  def select_exclude_related(sel_id)
    @html = label_tag(:exclude_related,I18n.t("label_std_exclude_related"))
    @html += select_tag(:exclude_related, options_for_select([[I18n.t("general_text_Yes"),true],[I18n.t("general_text_No"),false]], sel_id))
    @html
  end
  def select_users(sel_id)
    @html = select_tag(:user_id, options_for_select(@users.collect{|u| ["#{u}", u.id] }, sel_id))
    @html
  end
  def select_enabled(sel_id)
    @html = label_tag(:enabled,I18n.t("label_enabled"))
    @html += select_tag(:enabled, options_for_select([[I18n.t("general_text_Yes"),1],[I18n.t("general_text_No"),0]], sel_id))
    @html
  end
  def select_stacked(sel_id)
    @html = label_tag(:isStacked,I18n.t("label_std_stacked"))
    @html += select_tag(:isStacked, options_for_select([
          [I18n.t("general_text_Yes"),true],
          [I18n.t("general_text_No"),false],
          ['percent','percent']
        ], sel_id))
    @html
  end
  def chart_type(sel_id)
    @html = label_tag(:chart_type,I18n.t("label_chart_type"),:id => "label_chart_type")
    @html += select_tag(:chart_type, options_for_select([
          ['line','line'],
          ['pie','pie'],
          ['bar','bar'],
          ['column','column'],
          ['area','area']
        ], sel_id)
    )
    @html
  end
  def std_reports(sel_id)
    @html = label_tag(:std_report_id,I18n.t("label_std_chart"))
    @html += select_tag(:std_report_id, options_for_select([
          [I18n.t("std_report1_text"),1],
          [I18n.t("std_report2_text"),2],
          [I18n.t("std_report3_text"),3],
          [I18n.t("std_report4_text"),4],
          [I18n.t("std_report5_text"),5],
          [I18n.t("std_report6_text"),6],
          [I18n.t("std_report7_text"),7],
          [I18n.t("std_report8_text"),8],
          [I18n.t("std_report9_text"),9],
          [I18n.t("std_report10_text"),10],
          [I18n.t("std_report11_text"),11]
        ], sel_id)
    )
    @html
  end
  def std_custom_field(sel_id)
    @html = label_tag(:custom_field,I18n.t("label_std_custom_field"))
    custom_fields = IssueCustomField.where(:field_format => 'list').collect{|c| [c.name,c.id]}
    @html += select_tag(:custom_field, options_for_select(custom_fields, sel_id))
    @html
  end
  def std_projects(sel_ids)
    @html = label_tag(:projects,I18n.t("label_std_projects"))
    # get projects user is allowed to see
    projs = Project.visible(User.find(@user_id))
    plist = []
    Project.project_tree(projs, :init_level => true) do |project, level|
      spacer = ""
      unless level.nil?
        level.times {spacer += "»" }
      end
      plist << [spacer + project.name[0..$textLen], project.id]
    end
    #projs = Project.visible(User.find(@user_id)).order(:lft).collect{|p| [p.name[0..$textlen],p.id]}
    #@html += select_tag(:projects, options_for_select(projs, sel_ids),:multiple => true)
    logger.info(plist.inspect)
    @html += select_tag(:projects, options_for_select(plist, sel_ids),:multiple => true)
    @html
  end
  def std_trackers(sel_ids)
    @html = label_tag(:trackers,I18n.t("label_std_trackers"))
    tracks = Tracker.order(:name).all.collect{|t| [t.name[0..$textLen],t.id]}
    @html += select_tag(:trackers, options_for_select(tracks, sel_ids),:multiple => true)
    @html
  end
  def std_issues(sel_ids)
    @html = label_tag(:issues,I18n.t("label_std_issues"))
    # Get issues user is allowed to see
    iss = Issue.visible(User.find(@user_id)).order(:subject).collect{|i| [i.subject[0..$textLen],i.id]}
    @html += select_tag(:issues, options_for_select(iss, sel_ids),:multiple => true)
    @html
  end
  def std_version(sel_id)
    @html = label_tag(:version,I18n.t("label_std_version"))
    versions = Version.all.collect{|v| [v.name,v.id]}
    versions.unshift(["0 Incomplete Process",0]) # 0 version = "1.0 Incomplete Process"
    @html += select_tag(:version, options_for_select(versions, sel_id))
    @html
  end
  def std_category(sel_id)
    @html = label_tag(:category,I18n.t("label_std_category"))
    categories = IssueCategory.all.collect{|ic| [ic.name,ic.id]}
    categories.unshift([I18n.t("label_all"),0]) # 0 version = "1.0 Incomplete Process"
    @html += select_tag(:category, options_for_select(categories, sel_id))
    @html
  end
  def std_color_scheme(sel_id)
    @html = label_tag(:color_scheme,I18n.t("label_std_color_scheme"))
    @html += select_tag(:color_scheme, options_for_select([
          [I18n.t("std_color_scheme_0"),0],
          [I18n.t("std_color_scheme_1"),1],
          [I18n.t("std_color_scheme_2"),2],
          [I18n.t("std_color_scheme_3"),3],
          [I18n.t("std_color_scheme_4"),4],
          [I18n.t("std_color_scheme_5"),5],
          [I18n.t("std_color_scheme_6"),6],
          [I18n.t("std_color_scheme_7"),7],
          [I18n.t("std_color_scheme_8"),8],
          [I18n.t("std_color_scheme_9"),9],
          [I18n.t("std_color_scheme_10"),10],
          [I18n.t("std_color_scheme_11"),11]
        ], sel_id)
    )
    @html
  end
end
