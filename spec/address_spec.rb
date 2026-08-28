# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bip39::Address do
  let(:phrase) do
    "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
  end

  it "matches the well-known BIP-84 first receive address" do
    expect(described_class.from_mnemonic(phrase)).to eq(
      "bc1qcr8te4kr609gcawutmrza0j4xv80jy8z306fyu"
    )
  end
end
