# frozen_string_literal: true

module Rparam
  class Calculator
    using DateExt

    def initialize(params = nil, memory = nil)
      @params = params || {}
      @memory = {}
      @result = {}
      begin
        @memory.merge! memory
      rescue
      end
    end

    def add(name, options)
      options ||= {}
      value = @params[name]

      if options[:save].present?
        if value.nil?
          value = read_memory(name, options)
        else
          write_memory(name, value, options)
        end
      end

      if options[:inclusion].present?
        inclusion = Array.wrap options[:inclusion]
        if value.is_a? Array
          value = value & inclusion
        else
          value = nil unless value.in? inclusion
        end
      end

      if options.has_key? :exclusion
        exclusion = Array.wrap options[:exclusion]
        if value.is_a? Array
          value = value - exclusion
        else
          value = nil if value.in? exclusion
        end
      end

      if options[:default].present? and value.nil?
        value = default_value(options)
      end

      if options[:type].present?
        value = Parser.parse(value, options[:type])
      end

      if value.nil? && options[:type] == Array
        value = []
      end

      @result[name] = value
    end

    def write_memory(name, value, options)
      if options[:save] == :relative_date
        date = Parser.parse_date(value)
        value = date&.difference_in_day
      elsif options[:save] == :relative_month
        date = Parser.parse_date(value)
        value = date&.difference_in_month
      end
      @memory[name] = value
    end

    def read_memory(name, options)
      value = @memory[name]
      if options[:save] == :relative_date and @memory.has_key? name
        difference = Parser.parse_int(value)
        if difference.nil?
          return ''
        end
        date = Time.zone.today + difference
        date.strftime '%F'
      elsif options[:save] == :relative_month and @memory.has_key? name
        difference = Parser.parse_int(value)
        if difference.nil?
          return ''
        end
        date = Time.zone.today.next_month difference
        date.strftime '%Y-%m'
      else
        value
      end
    rescue
      nil
    end

    def result
      @result.dup
    end

    def memory
      @memory.dup
    end

    private

      def default_value(options)
        value = options[:default]
        if options[:save] == :relative_date
          value.to_s
        elsif options[:save] == :relative_month
          date = Parser.parse_date(value)
          date.start_of_month.strftime '%Y-%m'
        else
          value
        end
      end

  end
end
