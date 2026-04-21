use aiken/cbor
use aiken/primitive/bytearray
use cardano/transaction.{OutputReference}
use sundae/multisig.{AllOf, AnyOf, AtLeast, MultisigScript, Signature}
use types.{
  TreasuryConfiguration, TreasuryPermissions, VendorConfiguration,
  VendorPermissions,
}

// Seed UTxO
fn seed_utxo() -> OutputReference {
  OutputReference {
    transaction_id: #"xxxxxx",
    output_index: 0,
  }
}


// New Intersect leadership keys for 2026

fn intersect_leadership_3() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn intersect_leadership_4() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn intersect_leadership_5() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn intersect_admin_1() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"1be0008bf2994524c0eaf0efdae4431e4a61ef7d974804fa794110b7",
      },
      Signature {
        key_hash: #"27194940fae07315f4dc7a0394535dea7795dab2f232ee40f4457e8f",
      },
    ],
  }
}

fn intersect_admin_2() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"a664de561ccd2ca9a07c060d4dd7cea4dc68ba89d4bf04b21ff0726f",
      },
      Signature {
        key_hash: #"821dbb013b85872e91f59e5c3c566390c866aea114a13b1b68f064bc",
      },
    ],
  }
}

fn intersect_admin_3() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"c236d8dc9441605238a5fe9cc7e6c1a79903289a4249c33122bf9627",
      },
      Signature {
        key_hash: #"1b5850270f7a77ea9ef570a83fb4b120bf814ec94aa0dba0c9c28844",
      },
    ],
  }
}

fn intersect_admin_4() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn intersect_admin_5() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn cardano_foundation() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn sundae_labs() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn nmkr() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

fn dquadrant() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}

// placeholder

fn xxxxx() -> MultisigScript {
  AnyOf {
    scripts: [
      Signature {
        key_hash: #"",
      },
      Signature {
        key_hash: #"",
      },
    ],
  }
}


// Groups

fn intersect_leadership() -> List<MultisigScript> {
  [intersect_leadership_1(), intersect_leadership_2()]
}

fn intersect_admin() -> List<MultisigScript> {
  [intersect_admin_1(), intersect_admin_2(), intersect_admin_3()]
}

fn trusted_entities() -> List<MultisigScript> {
  [cardano_foundation(), sundae_labs(), xerberus(), nmkr(), dquadrant()]
}

// Permissions

fn reorganize() -> MultisigScript {
  AllOf {
    scripts: [
      AtLeast { required: 2, scripts: intersect_admin() },
      AtLeast { required: 3, scripts: trusted_entities() },
    ],
  }
}

fn sweep_treasury() -> MultisigScript {
  AllOf {
    scripts: [
      AnyOf { scripts: intersect_admin() },
      AnyOf { scripts: intersect_leadership() },
    ],
  }
}

fn fund() -> MultisigScript {
  AllOf {
    scripts: [
      AnyOf { scripts: intersect_leadership() },
      AtLeast { required: 2, scripts: intersect_admin() },
      AtLeast { required: 2, scripts: trusted_entities() },
    ],
  }
}

fn disburse() -> MultisigScript {
  AllOf {
    scripts: [
      AllOf { scripts: intersect_leadership() },
      AtLeast { required: 2, scripts: intersect_admin() },
      AtLeast { required: 3, scripts: trusted_entities() },
    ],
  }
}

fn pause() -> MultisigScript {
  AllOf {
    scripts: [
      AnyOf { scripts: intersect_leadership() },
      AtLeast { required: 2, scripts: intersect_admin() },
    ],
  }
}

fn resume() -> MultisigScript {
  pause()
}

fn modify() -> MultisigScript {
  fund()
}

// Configuration

pub fn registry_token() {
  #"9e65e4ed7d6fd86fc4827d2b45da6d2c601fb920e8bfd794b8ecc619"
}

pub fn treasury_expiration() {
  1848700800000
}

pub fn payout_upperbound() {
  1851206400000
}

pub fn vendor_expiration() {
  1853884800000
}

pub fn treasury_configuration() -> TreasuryConfiguration {
  TreasuryConfiguration {
    registry_token: registry_token(),
    permissions: TreasuryPermissions {
      reorganize: reorganize(),
      sweep: sweep_treasury(),
      fund: fund(),
      disburse: disburse(),
    },
    expiration: treasury_expiration(),
    payout_upperbound: payout_upperbound(),
  }
}

pub fn vendor_configuration() -> VendorConfiguration {
  VendorConfiguration {
    registry_token: registry_token(),
    permissions: VendorPermissions {
      pause: pause(),
      resume: resume(),
      modify: modify(),
    },
    expiration: vendor_expiration(),
  }
}

// Printing

test display_seed_utxo() {
  trace bytearray.to_hex(cbor.serialise(seed_utxo()))
  True
}

test display_treasury_config() {
  trace bytearray.to_hex(cbor.serialise(treasury_configuration()))
  True
}

test display_vendor_config() {
  trace bytearray.to_hex(cbor.serialise(vendor_configuration()))
  True
}
