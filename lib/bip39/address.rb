# frozen_string_literal: true

require "bitcoin"

module Bip39
  class Address
    PATH = [84, 0, 0, 0, 0].freeze

    def self.from_mnemonic(phrase, passphrase: "", network: :mainnet)
      raise InvalidMnemonic, "invalid mnemonic" unless Mnemonic.valid?(phrase)

      Bitcoin.chain_params = network
      seed_hex = Mnemonic.to_seed(phrase, passphrase: passphrase).unpack1("H*")
      master = Bitcoin::ExtKey.generate_master(seed_hex)

      key = master
        .derive(PATH[0], true)
        .derive(PATH[1], true)
        .derive(PATH[2], true)
        .derive(PATH[3], false)
        .derive(PATH[4], false)

      key.addr
    end
  end
end
