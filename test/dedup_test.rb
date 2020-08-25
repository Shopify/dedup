require "test_helper"

require 'objspace'

module Dedup
  class DedupTest < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Dedup::VERSION
    end

    def test_deduplicate_hash_values
      hash = { ("foo" * 3).freeze => "bar" * 3 }

      refute_interned hash.keys.first
      refute_interned hash.values.first
      Native.deep_intern!(hash)

      assert_interned hash.keys.first
      assert_interned hash.values.first
    end

    def test_various_types
      Native.deep_intern!(
        true => false,
        nil => /foo/,
        Object.new => [1].freeze,
        ("fuzz" * 4).freeze => 0,
        4.2 => 1..3,
      )
    end

    def test_ar_table_size
      hash = { 1 => 2 }
      # AR table are 168B, improper use of the API can convert hashes to ST table which is minumum 192B
      assert_equal 168, ObjectSpace.memsize_of(hash)
      Native.deep_intern!(hash)
      assert_equal 168, ObjectSpace.memsize_of(hash)
    end

    def test_st_table_hash
      hash = {
        ("foo" * 3).freeze => "bar" * 3,
        ("bar" * 3).freeze => "bar" * 3,
        ("baz" * 3).freeze => "bar" * 3,
        ("quz" * 3).freeze => "bar" * 3,
        ("fum" * 3).freeze => "bar" * 3,
        ("bim" * 3).freeze => "bar" * 3,
        ("bam" * 3).freeze => "bar" * 3,
        ("boon" * 3).freeze => "bar" * 3,
        ("egg" * 3).freeze => "bar" * 3,
        ("spam" * 3).freeze => "bar" * 3,
      }

      refute_interned hash.keys.first
      refute_interned hash.values.first
      Native.deep_intern!(hash)

      assert_interned hash.keys.first
      assert_interned hash.values.first
    end

    private

    def refute_interned(str)
      repr = ObjectSpace.dump(str)
      refute repr.include?('"fstring":true'), "Expected this to not be interned: #{repr}"
    end

    def assert_interned(str)
      repr = ObjectSpace.dump(str)
      assert repr.include?('"fstring":true'), "Expected this to be interned: #{repr}"
    end
  end
end
