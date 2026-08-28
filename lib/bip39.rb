# frozen_string_literal: true

require_relative "bip39/mnemonic"
require_relative "bip39/address"

module Bip39
  WORD_COUNTS = {
    12 => 128,
    15 => 160,
    18 => 192,
    21 => 224,
    24 => 256
  }.freeze
end
