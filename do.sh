# flow-c1 emulator

flow-c1 deploy --update

flow-c1 transactions send ./cadence/transactions/add_logic.cdc --signer emulator-account

flow-c1 transactions send ./cadence/transactions/snapshot.cdc --signer emulator-account

flow-c1 scripts execute ./cadence/scripts/view.cdc f8d6e0586b0a20c7

flow-c1 scripts execute ./cadence/scripts/proof_of_ownership.cdc f8d6e0586b0a20c7
