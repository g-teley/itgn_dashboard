class ItgnDashboardSetup < ActiveRecord::Base

  attr_accessor :include_subprojects, :exclude_related, :isStacked, :series, :color_scheme

  before_save :set_options
  after_initialize :get_options
  #
  # NOTE!
  # Because of jQuery handling of the correct selected color series, this value is stored in JSON format
  # although the rest of the options is stored in YAML format.
  # So here we handle this when fetching a record (at storing it is in JSON format coming from the POSTed parameter)
  #
  # Define the various variables we store in the options field
  def initialize (user_id = User.current.id, report_id = 1)
    # Initialize record without parameters(!)
    super()
    @include_subprojects = false
    @exclude_related = false
    @isStacked = false
    @series = {}
    @color_scheme = 0
    @options = {}
  end

  def include_subprojects
    @include_subprojects
  end
  def exclude_related
    @exclude_related
  end
  def isStacked
    @isStacked
  end
  def series
    @series
  end
  def color_scheme
    @color_scheme
  end

  def get_options
    begin
      if self.options.nil? # Load with default values
        logger.info("Options = nil!")
        self.options = YAML::dump({
            :include_subprojects => false,
            :exclude_related => false,
            :isStacked => false,
            :series => {},
            :color_scheme => 0})
        self.include_subprojects = false
        self.exclude_related = false
        self.isStacked = false
        self.series = {}
        self.color_scheme = 0
      else
        opts = YAML::load(self.options)
        if opts.has_key?(:include_subprojects)
          self.include_subprojects = opts[:include_subprojects]
        else
          self.include_subprojects = false
        end
        if opts.has_key?(:exclude_related)
          self.exclude_related = opts[:exclude_related]
        else
          self.exclude_related = false
        end
        if opts.has_key?(:isStacked)
          self.isStacked = opts[:isStacked]
        else
          self.isStacked = false
        end
        if opts.has_key?(:series)
          begin
            self.series = JSON.parse(opts[:series])
          rescue
            self.series = {0 => { :type => 'line', :discrete => true, :color => 'b5b5b5'}}
          end
        else
          self.series = {0 => { :type => 'line', :discrete => true, :color => 'b5b5b5'}}
        end
        if opts.has_key?(:color_scheme)
          self.color_scheme = opts[:color_scheme]
        else
          self.color_scheme = 0
        end
      end
    rescue StandardError => ex # Provide some defaults in case of error
      logger.error("ItgnDashboardSetup: provided defaults after initialize error = #{ex.message}")
      self.include_subprojects = false
      self.exclude_related = false
      self.isStacked = false
      self.series = {}
      self.color_scheme = 0
    end
  end

  def set_options
    begin
      if self.user_id.nil?
        self.user_id = User.current.id
      end
      if self.projects.nil?
        self.projects = ""
      end
      if self.trackers.nil?
        self.trackers = ""
      end
      if self.issues.nil?
        self.issues = ""
      end
      if self.version.nil?
        self.version = 0
      end
      if self.category.nil?
        self.category = 0
      end
      if self.enabled.nil?
        self.enabled = 0
      end
      if self.series == ""
        self.series = {}
      end
      self.options = YAML::dump({
          :include_subprojects => self.include_subprojects,
          :exclude_related => self.exclude_related,
          :isStacked => self.isStacked,
          :series => self.series,
          :color_scheme => self.color_scheme
        }
      );
      #logger.info("Set options to : #{self.options.inspect}")
    rescue StandardError => ex
      # may fail when migrating database
      logger.error("Error in before_save: #{ex.message}")
    end
  end
end
