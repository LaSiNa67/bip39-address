cat > README.md << 'EOF'
# bip39-address

Small Ruby learning project:

1. Generate or check a BIP-39 seed phrase
2. Derive the first Bitcoin receive address from it (`bc1q…`, BIP-84)

**This is not a production wallet.** Do not store real funds with it.

## What you need

- Ruby 3.2 or newer (`ruby -v`)
- Bundler (`gem install bundler`)

## Setup (once)

From the project folder:

    bundle install

This reads the `Gemfile` and installs:

- `rspec` — tests
- `bitcoinrb` — keys and Bitcoin addresses

## Tests

    bundle exec rspec

`bundle exec` means: use the gems from this project, not random system gems.
`rspec` runs the files in `spec/`.

Green means:

- the English wordlist has 2048 words
- official Trezor test vectors encode and decode correctly
- the demo phrase derives the well-known address
  `bc1qcr8te4kr609gcawutmrza0j4xv80jy8z306fyu`

## Try it in Ruby

From the project folder:

    irb

Then:

    $LOAD_PATH.unshift "lib"
    require "bip39"

`$LOAD_PATH.unshift "lib"` tells Ruby your code lives in `lib/`.
`require "bip39"` loads this library.

Check a phrase (public test vector, not a secret):

    Bip39::Mnemonic.valid?("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about")

Create a practice phrase (12 words):

    Bip39::Mnemonic.generate(words: 12)

First receive address for a phrase:

    Bip39::Address.from_mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about")

Expected:

    bc1qcr8te4kr609gcawutmrza0j4xv80jy8z306fyu

That is Native SegWit at path `m/84'/0'/0'/0/0` (same default many modern Bitcoin wallets use).

Testnet address (`tb1…`):

    Bip39::Address.from_mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about", network: :testnet)

Leave irb:

    exit

## Safety

- Do not commit, chat, or screenshot a phrase from `generate`
- Receiving coins at the address is possible; spending needs a real wallet
- To spend, import the **same** phrase into Sparrow or BlueWallet as Native SegWit
- The first address there must match this library; if it does not, do not send funds
- After a known RNG or code change, treat old practice phrases as burned

## How the pieces fit

    phrase  →  BIP-39 seed  →  BIP-32 master key  →  m/84'/0'/0'/0/0  →  bc1q address
EOF
