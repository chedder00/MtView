# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the filter module is to add feature
# to support report tool to add custom and predefined filters

require 'query_report/comparator'

module QueryReport
  module FilterModule
    attr_accessor :filters, :search

    # Creates a filter
    # @param column the column on which the filter is done on, for manual filter the column name can be anything
    # @option options [Symbol] :type date | text | whatever
    # @option options [Array] :comp the comparators used for ransack search, [:gteq, :lteq]
    # @option options [Boolean] :manual if set to true then that filter will not be applied, only will appear and can be used for custom application
    # @option options :default support default filter value, can be one value or for range filter can be array
    #
    # @example Custom type
    #  filter :invoiced_to_id, type: :user
    #
    #  # In a helper file define method
    #  def query_report_user_filter(name, user_id, options={})
    #    user = User.find(user_id)
    #    concat hidden_field_tag name, user_id, options
    #    text_field_tag "#{name}", user.name, class: 'user_search' #implement the filter, it can be autocomplete
    #  end
    #

    def filter(column, options={}, &block)
      debugger
      @filters ||= []
      @filters << Filter.new(@params, column, options, &block)
    end

    def apply_filters(query, http_params)
      # apply default filter
      params = load_default_values_in_param(http_params) #need for ransack filter
      @search = query.ransack(params[:q])
      query = @search.result

      #this is to fix a bug from ransack, as for ransack when the sorting is done from a joined table it does not sort by default
      query = query.order(params[:q][:s]) if params[:q][:s]

      #apply custom filter
      @filters.select(&:custom?).each do |filter|
        ordered_custom_param_values = ordered_param_value_objects(filter)
        has_no_user_input = ordered_custom_param_values.all? { |p| p.nil? or p == '' }
        query = filter.block.call(query, *ordered_custom_param_values) if filter.block and !has_no_user_input
      end
      query
    end

    class Filter
      attr_reader :params, :column, :type, :comparators, :block, :options

      # Initializes filter with the proper parameters
      # @param params [Hash] The params from the http request
      # @param column [Symbol] the name of the filter or the column name for the filter to be applied on
      # @param block The block is passed for a manual query, The first param the block will receive is the query chain, and the rest is the values for that particular filter.
      # @see FilterModule#filter options
      def initialize(params, column, options, &block)
        debugger
        @params, @column, @options, @comparators, @block = params, column, options, [], block
        @type = options.kind_of?(String) ? options : options[:type]
        generate_comparators
      end

      def self.supported_types
        [:date, :datetime, :text, :boolean]
      end

      supported_types.each do |supported_type|
        define_method("#{supported_type.to_s}?") do
          @type == supported_type
        end
      end

      def custom?
        (@block || @options[:manual]) ? true : false
      end

      def search_keys
        @comparators.collect(&:search_key)
      end

      def has_default?
        @comparators.any?(&:has_default?)
      end

      def params_key
        custom? ? :custom_search : :q
      end

      private
      def generate_comparators
        @options[:comp] ||= case @type
                              when :date
                                {gteq: I18n.t('query_report.filters.from'), lteq: I18n.t('query_report.filters.to')}
                              when :datetime
                                {gteq: I18n.t('query_report.filters.from'), lteq: I18n.t('query_report.filters.to')}
                              when :text
                                {cont: I18n.t("query_report.filters.#{@column.to_s}.contains")}
                              else
                                {eq: I18n.t("query_report.filters.#{@column.to_s}.equals")}
                            end

        if @options[:comp]
          @options[:comp].each_with_index do |(ransack_search_key, filter_name), i|
            default = nil
            default = @options[:default].kind_of?(Array) ? @options[:default][i] : @options[:default] unless @options[:default].nil?
            @comparators << Comparator.new(self, ransack_search_key, filter_name, default)
          end
        end
      end
    end

    def has_filter?
      filters.present?
    end

    def ordered_param_value_objects(filter)
      filter.comparators.collect do |comp|
        comp.objectified_param_value
      end
    end

    def load_default_values_in_param(http_params)
      params = http_params.clone
      params = params.merge(q: {}) unless params[:q]
      params = params.merge(custom_search: {}) unless params[:custom_search]
      @filters.each do |filter|
        filter.comparators.each do |comparator|
          params[filter.params_key][comparator.search_key] ||= comparator.param_value
        end
      end
      params
    end
  end
end