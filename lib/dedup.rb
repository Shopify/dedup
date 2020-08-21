require "dedup/version"

module Dedup
  EMPTY_HASH = {}.freeze
  EMPTY_ARRAY = [].freeze
  class Error < StandardError; end

  module Ruby
    module_function

    def deep_intern!(data)
      case data
      when Hash
        data.transform_keys! { |k| deep_intern!(k) }
        data.transform_values! { |v| deep_intern!(v) }
        data.freeze
      when Array
        data.map! { |d| deep_intern!(d) }.freeze
      when String
        -data.freeze
      else
        data.freeze
      end
    end
  end
end

begin
  require "dedup/dedup"
  Dedup.extend(Dedup::Native)
rescue LoadError
  Dedup.extend(Dedup::Ruby)
end
