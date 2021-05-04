# frozen_string_literal: true

module Dedup
  VERSION = "0.1.4"

  DEDUP_FROZEN_STRINGS = begin
    rand_string = rand.to_s
    (-rand_string.freeze).equal?(-(+rand_string))
  end

  DEDUP_HASH_ASET = begin
    h = {}
    x = {}
    r = rand.to_s
    h[%W(#{r}).join('')] = 1
    x[%W(#{r}).join('')] = 1
    x.keys[0].equal?(h.keys[0])
  end

  DEDUP_HASH_ASET_FROZEN = begin
    h = {}
    x = {}
    r = rand.to_s
    h[%W(#{r}).join('').freeze] = 1
    x[%W(#{r}).join('').freeze] = 1
    x.keys[0].equal?(h.keys[0])
  end
end
