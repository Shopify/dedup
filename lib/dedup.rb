# frozen_string_literal: true

require "dedup/version"

module Dedup
  EMPTY_HASH = {}.freeze
  EMPTY_ARRAY = [].freeze
  class Error < StandardError; end

  module Ruby
    extend self

    if DEDUP_FROZEN_STRINGS
      def deep_intern!(data)
        case data
        when Hash
          return EMPTY_HASH if data.empty?
          return data if data.frozen?

          data.transform_keys! { |k| deep_intern!(k) }
          data.transform_values! { |v| deep_intern!(v) }
          data.freeze
        when Array
          return EMPTY_ARRAY if data.empty?
          return data if data.frozen?

          data.map! { |d| deep_intern!(d) }.freeze
        when String
          -data.freeze
        else
          data.freeze
        end
      end
    else
      def deep_intern!(data)
        case data
        when Hash
          return data if data.frozen?

          data.transform_keys! { |k| deep_intern!(k) }
          data.transform_values! { |v| deep_intern!(v) }
          data.freeze
        when Array
          return data if data.frozen?

          data.map! { |d| deep_intern!(d) }.freeze
        when String
          -(+data)
        else
          data.freeze
        end
      end
    end
  end
end

begin
  require "dedup/#{RUBY_VERSION[/^\d+\.\d+/]}/dedup"
rescue LoadError
  begin
    require "dedup/dedup"
  rescue LoadError
    Dedup.extend(Dedup::Ruby)
  end
ensure
  if defined?(Dedup::Native)
    Dedup::Native.extend(Dedup::Native)
    Dedup.extend(Dedup::Native)
  end
end
