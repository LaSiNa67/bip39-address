# frozen_string_literal: true

require "digest"
require "openssl"
require "securerandom"

module Bip39
  class InvalidMnemonic < StandardError; end

  class Mnemonic
    WORDLIST_PATH = File.expand_path("../../wordlists/english.txt", __dir__)

    def self.wordlist
      @wordlist ||= File.readlines(WORDLIST_PATH, chomp: true).tap do |words|
        raise "English wordlist must contain 2048 words" unless words.size == 2048
      end
    end

    def self.word_index
      @word_index ||= wordlist.each_with_index.to_h
    end

    def self.generate(words: 12)
      bits = WORD_COUNTS[words]
      raise ArgumentError, "words must be 12, 15, 18, 21, or 24" unless bits

      from_entropy(SecureRandom.random_bytes(bits / 8))
    end

    def self.from_entropy(entropy)
      bits = entropy.bytesize * 8
      raise ArgumentError, "entropy must be 128–256 bits" unless WORD_COUNTS.value?(bits)

      checksum_len = bits / 32
      hash_bits = Digest::SHA256.digest(entropy).unpack1("B*")
      all_bits = entropy.unpack1("B*") + hash_bits[0, checksum_len]

      all_bits.chars.each_slice(11).map { |chunk| wordlist[chunk.join.to_i(2)] }.join(" ")
    end

    def self.valid?(phrase)
      validate!(phrase)
      true
    rescue InvalidMnemonic
      false
    end

    def self.validate!(phrase)
      words = normalize(phrase)
      bits = WORD_COUNTS[words.size]
      raise InvalidMnemonic, "wrong word count" unless bits

      indexes = words.map do |word|
        word_index[word] || raise(InvalidMnemonic, "unknown word: #{word}")
      end

      all_bits = indexes.map { |i| format("%011b", i) }.join
      entropy_bits = bits
      entropy_bitstring = all_bits[0, entropy_bits]
      checksum_bits = all_bits[entropy_bits..]

      entropy = [entropy_bitstring].pack("B*")
      expected = Digest::SHA256.digest(entropy).unpack1("B*")[0, bits / 32]
      raise InvalidMnemonic, "bad checksum" unless checksum_bits == expected

      words.join(" ")
    end

    def self.to_seed(phrase, passphrase: "")
      mnemonic = validate!(phrase)
      OpenSSL::KDF.pbkdf2_hmac(
        mnemonic.unicode_normalize(:nfkd),
        salt: "mnemonic#{passphrase.unicode_normalize(:nfkd)}",
        iterations: 2048,
        length: 64,
        hash: "sha512"
      )
    end

    def self.normalize(phrase)
      phrase.to_s.strip.downcase.split
    end
    private_class_method :normalize
  end
end
