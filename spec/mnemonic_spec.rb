# frozen_string_literal: true

require "json"
require "spec_helper"

RSpec.describe Bip39::Mnemonic do
  let(:vectors) do
    JSON.parse(File.read("spec/fixtures/vectors.json")).fetch("english")
  end

  it "loads 2048 English words" do
    expect(described_class.wordlist.size).to eq(2048)
    expect(described_class.wordlist.first).to eq("abandon")
    expect(described_class.wordlist.last).to eq("zoo")
  end

  it "encodes official entropy into the official mnemonic" do
    vectors.each do |entropy_hex, mnemonic, *_rest|
      entropy = [entropy_hex].pack("H*")
      expect(described_class.from_entropy(entropy)).to eq(mnemonic)
    end
  end

  it "accepts official mnemonics" do
    vectors.each do |_entropy, mnemonic, *_rest|
      expect(described_class.valid?(mnemonic)).to be true
    end
  end

  it "rejects a checksum error" do
    words = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon"
    expect(described_class.valid?(words)).to be false
  end

  it "derives official seeds with passphrase TREZOR" do
    vectors.each do |_entropy, mnemonic, seed_hex, *_rest|
      expect(described_class.to_seed(mnemonic, passphrase: "TREZOR").unpack1("H*")).to eq(seed_hex)
    end
  end

  it "generates a valid 12-word phrase" do
    phrase = described_class.generate(words: 12)
    expect(phrase.split.size).to eq(12)
    expect(described_class.valid?(phrase)).to be true
  end

  it "generates a valid 24-word phrase" do
    phrase = described_class.generate(words: 24)
    expect(phrase.split.size).to eq(24)
    expect(described_class.valid?(phrase)).to be true
  end
end
