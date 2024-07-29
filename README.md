![Snapshot Architecture](https://github.com/avcdsld/snapshot/assets/10495516/91984cf2-f92a-4653-bb11-34aa89b97dc5)

# Snapshot

## Explanatory Article

https://mirror.xyz/ara721.eth/LD7H64Y1zFthHLrT4-cZLiGZ_5PP8EesxuVp4Sfz_MM

## Contracts

1. [Snapshot.cdc](./cadence/contracts/Snapshot.cdc) (Mainnet: `0x36b1a29d10c00c1a`)
2. [SnapshotLogic.cdc](./cadence/contracts/SnapshotLogic.cdc) (Mainnet: `0x36b1a29d10c00c1a`)
2. [SnapshotViewer.cdc](./cadence/contracts/SnapshotViewer.cdc) (Mainnet: `0x36b1a29d10c00c1a`)

## Transactions

1. [add_logic.cdc](./cadence/transactions/add_logic.cdc)
2. [snapshot.cdc](./cadence/transactions/snapshot.cdc)

## Scripts

1. [proof_of_ownership.cdc](./cadence/scripts/proof_of_ownership.cdc)
2. [view.cdc](./cadence/scripts/view.cdc)

## Archtecture

<img width="1080" alt="Screen Shot 2023-09-26 at 13 39 38" src="https://github.com/avcdsld/snapshot/assets/10495516/158d60c4-927e-417c-9db1-94e99979a854">

## State of Account Storage

<img width="1068" alt="Screen Shot 2023-09-26 at 13 40 00" src="https://github.com/avcdsld/snapshot/assets/10495516/57861d12-0806-40cc-bada-b8a81ebb3469">

## Viewer Demo

[![Snapshot Viewer](https://github-production-user-asset-6210df.s3.amazonaws.com/10495516/270688805-4a82024f-6200-467d-b65e-b95819b40e8a.png)](https://www.youtube.com/watch?v=sErAUWX6bI8)

## Cadence 1.0 Migration 2024/07/27

```sh
sudo sh -ci "$(curl -fsSL https://raw.githubusercontent.com/onflow/flow-cli/master/install.sh)"
flow-c1 version

flow-c1 emulator
flow-c1 deploy

flow-c1 migrate stage Base64Util --network=mainnet
flow-c1 migrate is-staged Base64Util --network=mainnet
flow-c1 migrate is-validated Base64Util --network=mainnet

flow-c1 migrate stage Snapshot --network=mainnet
flow-c1 migrate is-staged Snapshot --network=mainnet
flow-c1 migrate is-validated Snapshot --network=mainnet

flow-c1 migrate stage SnapshotLogic --network=mainnet
flow-c1 migrate is-staged SnapshotLogic --network=mainnet
flow-c1 migrate is-validated SnapshotLogic --network=mainnet

flow-c1 migrate stage SnapshotViewer --network=mainnet
flow-c1 migrate is-staged SnapshotViewer --network=mainnet
flow-c1 migrate is-validated SnapshotViewer --network=mainnet
```
