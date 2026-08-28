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


ELI18:

Use it only in **Terminal**, from the project folder `bip39-address`. GitHub is just storage.

---

## 1. Open the folder

```bash
cd ~/bip39-address
pwd
ls
```

You must see `Gemfile`, `lib`, `spec`, `wordlists`.

If `cd` fails, find the folder:

```bash
ls ~
```

Then `cd` into the name you actually used.

---

## 2. One-time setup (if you already did this on this Mac, skip)

```bash
bundle install
```

Wait until it finishes.

---

## 3. Run tests (optional, good check)

```bash
bundle exec rspec
```

You want `0 failures`. If that is red, stop and paste the error. Do not generate phrases yet.

---

## 4. Start Ruby

```bash
irb
```

The prompt changes (often `irb(main):001:0>`).  
Do **not** type German or English sentences here — only Ruby.

Load the project (once per `irb` session):

```ruby
$LOAD_PATH.unshift "lib"
require "bip39"
```

If that errors, you are not in `bip39-address`. Type `exit`, go back to step 1.

---

## 5. Commands you can run inside `irb`

**Check the public demo phrase** (safe to type):

```ruby
Bip39::Mnemonic.valid?("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about")
```

Should print `true`.

**Make a practice phrase:**

```ruby
Bip39::Mnemonic.generate(words: 12)
```

or 24 words:

```ruby
Bip39::Mnemonic.generate(words: 24)
```

Ruby prints the words. That is the seed phrase.

**Address for the demo phrase:**

```ruby
Bip39::Address.from_mnemonic("abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about")
```

Should print:

`bc1qcr8te4kr609gcawutmrza0j4xv80jy8z306fyu`

**Address for a phrase you just generated:**

```ruby
phrase = Bip39::Mnemonic.generate(words: 12)
puts phrase
puts Bip39::Address.from_mnemonic(phrase)
```

First line = words. Second line = `bc1q…` receive address.

**Testnet address** (starts with `tb1`):

```ruby
Bip39::Address.from_mnemonic(phrase, network: :testnet)
```

---

## 6. Leave Ruby

```ruby
exit
```

You are back in zsh (`%` or `$`).

---

## Do not

- Put a generated phrase in Git, GitHub, or chat
- Type `generate` output into the README
- Expect this program to send coins (it only prints an address)

To receive a **test** amount, copy the `bc1q` / `tb1` line. To spend later you must import the **same words** into a real wallet (Sparrow, Native SegWit) and check the first address matches.

---

Typical session, copied in order:

```bash
cd ~/bip39-address
bundle exec rspec
irb
```

```ruby
$LOAD_PATH.unshift "lib"
require "bip39"
Bip39::Mnemonic.generate(words: 12)
exit
```

If any line is red, paste that line and the error only.
