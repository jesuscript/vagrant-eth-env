#!/bin/bash

PARITY_DEB_URL=http://d1h4xl4cr1h0mo.cloudfront.net/beta/x86_64-unknown-linux-gnu/parity_1.4.0_amd64.deb
PASSWORD=password
export HOME="/root"

echo "home: $HOME"
echo "user: $(whoami)"

echo "Installing parity"

sudo apt-get update -qq
sudo apt-get install -y -qq curl expect expect-dev

##################
# install parity #
##################
file=/tmp/parity.deb
curl -Lk $PARITY_DEB_URL > $file
sudo dpkg -i $file
rm $file


#####################
# create an account #
#####################
echo $PASSWORD > $HOME/.parity-pass

expect_out= expect -c "
spawn sudo parity account new
puts $HOME
expect \"Type password: \"
send ${PASSWORD}\n
expect \"Repeat password: \"
send ${PASSWORD}\n
interact
"

echo $expect_out

address=0x$(parity account list | awk 'END{print}' | tr -cd '[[:alnum:]]._-')

echo "address: $address"

cat > $HOME/chain.json <<EOL
{
  "name": "Private",
  "engine": {
    "InstantSeal": null
  },
  "params": {
    "accountStartNonce": "0x00",
    "maximumExtraDataSize": "0x20",
    "minGasLimit": "0x1388",
    "networkID" : "0xad"
  },
  "genesis": {
    "seal": {
      "ethereum": {
        "nonce": "0x00006d6f7264656e",
        "mixHash": "0x00000000000000000000000000000000000000647572616c65787365646c6578"
      }
    },
    "difficulty": "0x20000",
    "author": "0x0000000000000000000000000000000000000000",
    "timestamp": "0x00",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "0x",
    "gasLimit": "0x1312d00"
  },
  "nodes": [
  ],
  "accounts": {
    "0000000000000000000000000000000000000001": { "balance": "1", "nonce": "1048576", "builtin": { "name": "ecrecover", "pricing": { "linear": { "base": 3000, "word": 0 } } } },
    "0000000000000000000000000000000000000002": { "balance": "1", "nonce": "1048576", "builtin": { "name": "sha256", "pricing": { "linear": { "base": 60, "word": 12 } } } },
    "0000000000000000000000000000000000000003": { "balance": "1", "nonce": "1048576", "builtin": { "name": "ripemd160", "pricing": { "linear": { "base": 600, "word": 120 } } } },
    "0000000000000000000000000000000000000004": { "balance": "1", "nonce": "1048576", "builtin": { "name": "identity", "pricing": { "linear": { "base": 15, "word": 3 } } } },
    "${address}": {
      "balance": "1606938044258990275541962092341162602522202993782792835301376"
    }
  }
}
EOL

command="parity --chain $HOME/chain.json --author ${address} --unlock ${address} --password $HOME/.parity-pass --rpccorsdomain \"*\" --jsonrpc-interface all >&1 1>>/var/log/parity.log 2>&1 &"

parity daemon parity.pid --chain $HOME/chain.json --author ${address} --unlock ${address} --password $HOME/.parity-pass --rpccorsdomain "*" --jsonrpc-interface all --jsonrpc-hosts all --no-dapps --no-signer

