# flow emulator

flow deploy

flow transactions send ./cadence/transactions/add_logic.cdc --signer emulator-account

flow transactions send ./cadence/transactions/snapshot.cdc --signer emulator-account

flow scripts execute ./cadence/scripts/view.cdc f8d6e0586b0a20c7

flow scripts execute ./cadence/scripts/proof_of_ownership.cdc f8d6e0586b0a20c7
