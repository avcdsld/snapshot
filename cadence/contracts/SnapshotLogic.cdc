import NonFungibleToken from 0xf8d6e0586b0a20c7
import MetadataViews from 0xf8d6e0586b0a20c7
import "Snapshot"
// import "TopShot"

// The `SnapshotLogic` contract is a basic implementation of the `ILogic` struct interface.
//
access(all) contract SnapshotLogic {

    access(all) struct BasicLogic: Snapshot.ILogic {

        // This logic retrieves NFT information for
        // the Public Capability of `NonFungibleToken.CollectionPublic` and
        // the Public Capability of `TopShot.MomentCollectionPublic`.
        //
        access(all) fun getOwnedNFTs(address: Address): {String: {UInt64: Snapshot.NFTInfo}} {
            var nfts: {String: {UInt64: Snapshot.NFTInfo}} = {}
            let account = getAccount(address)
            account.storage.forEachPublic(fun (path: PublicPath, type: Type): Bool {

                let collection = account.capabilities.get<&{NonFungibleToken.CollectionPublic}>(path).borrow()
                if (collection != nil) {
                    for index, id in collection!.getIDs() {
                        if index == 0 {
                            nfts[path.toString()] = {}
                        }
                        let nft = collection!.borrowNFT(id)!
                        nfts[path.toString()]!.insert(key: nft.id, self.makeNFTInfo(nft: nft, path: path))
                    }
                    return true
                }

                // let topshotCollection = account.capabilities.get<&TopShot.Collection>(path).borrow()
                // if (topshotCollection != nil) {
                //     for index, id in topshotCollection!.getIDs() {
                //         if index == 0 {
                //             nfts[path.toString()] = {}
                //         }
                //         let nft = topshotCollection!.borrowNFT(id)!
                //         nfts[path.toString()]!.insert(key: nft.id, self.makeNFTInfo(nft: nft, path: path))
                //     }
                //     return true
                // }

                return true
            })
            return nfts
        }

        access(self) fun makeNFTInfo(nft: &{NonFungibleToken.NFT}, path: PublicPath): Snapshot.NFTInfo {
            var metadata: MetadataViews.Display? = nil
            if nft.getViews().contains(Type<MetadataViews.Display>()) {
                metadata = nft.resolveView(Type<MetadataViews.Display>())! as? MetadataViews.Display
            }
            return Snapshot.NFTInfo(
                collectionPublicPath: path.toString(),
                nftType: nft.getType(),
                nftID: nft.id,
                metadata: metadata,
                extraMetadata: nil
            )
        }
    }
}
