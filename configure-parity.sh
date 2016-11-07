#!/bin/bash

PARITY_DEB_URL=http://d1h4xl4cr1h0mo.cloudfront.net/beta/x86_64-unknown-linux-gnu/parity_1.4.0_amd64.deb
PASSWORD=Password123
export HOME="/root"

echo "home: $HOME"
echo "user: $(whoami)"

echo "Installing parity"

sudo apt-get update -qq
sudo apt-get install -y -qq curl

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
mkdir -p .parity/keys

cat > .parity/keys/key.json <<EOL
{"id":"0c9ad7b3-cc85-f81a-7991-05695a5495ad","version":3,"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"ce9b7b9741796b46c2ed494850781544"},"ciphertext":"86ff7819eeb9a7ccddbe781476b3d0268bdf6754d8253d3a523a208164197273","kdf":"pbkdf2","kdfparams":{"c":10240,"dklen":32,"prf":"hmac-sha256","salt":"9df3dfd806b5b4f95eaea6a4457ba806ae33c9cea5d55037029e83a6830ea278"},"mac":"3ff7df7e97bbbf845e7c5962e1522a1040319eb1fe4c510ff182b39e2cfa4309"},"address":"133e5245e3e5ab3f65e73120b34cc29f0f7ba504","name":"0c9ad7b3-cc85-f81a-7991-05695a5495ad","meta":"{}"}
EOL

echo $PASSWORD >> .parity-pass

address="133e5245e3e5ab3f65e73120b34cc29f0f7ba504"
echo "address: $address"

cat > chain.json <<EOL
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

parity --chain chain.json --author ${address} --unlock ${address} --password .parity-pass --rpccorsdomain "*" --jsonrpc-interface all --jsonrpc-hosts all --no-dapps --no-signer >&1 1>>parity.log 2>&1 &

