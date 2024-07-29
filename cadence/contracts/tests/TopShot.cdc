// Dummy

import NonFungibleToken from 0xf8d6e0586b0a20c7
import MetadataViews from 0xf8d6e0586b0a20c7

access(all) contract TopShot: NonFungibleToken {

    access(all) var totalSupply: UInt64
    access(all) event ContractInitialized()
    access(all) event Withdraw(id: UInt64, from: Address?)
    access(all) event Deposit(id: UInt64, to: Address?)

    access(all) resource NFT: NonFungibleToken.NFT {
        access(all) let id: UInt64

        access(all) view fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>()
            ]
        }

        access(all) fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():
                    return MetadataViews.Display(
                        name: "Test NFT #".concat(self.id.toString()),
                        description: "",
                        thumbnail: MetadataViews.HTTPFile(url: "https://assets.laligagolazos.com/editions/g18627_7317_recVWUiQUB3w7ufQp/play_g18627_7317_recVWUiQUB3w7ufQp__capture_Hero_Black_2880_2880_default.png")
                    )
            }
            return nil
        }

        init(id: UInt64) {
            self.id = id
        }

        access(all) fun createEmptyCollection(): @{NonFungibleToken.Collection} {
            return <- TopShot.createEmptyCollection(nftType: Type<@TopShot.NFT>())
        }
    }

    access(all) resource interface MomentCollectionPublic {
        access(all) view fun getIDs(): [UInt64]
        access(all) view fun borrowNFT(_ id: UInt64): &{NonFungibleToken.NFT}?
    }

    access(all) resource Collection: MomentCollectionPublic, NonFungibleToken.Collection {
        access(all) var ownedNFTs: @{UInt64: {NonFungibleToken.NFT}}

        init() {
            self.ownedNFTs <- {}
        }

        access(all) view fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        access(all) view fun borrowNFT(_ id: UInt64): &{NonFungibleToken.NFT}? {
            pre {
                self.ownedNFTs[id] != nil: "NFT does not exist in the collection!"
            }
            return (&self.ownedNFTs[id] as &{NonFungibleToken.NFT}?)
        }

        access(all) fun borrowNFTSafe(id: UInt64): &{NonFungibleToken.NFT}? {
            if let nftRef = &self.ownedNFTs[id] as &{NonFungibleToken.NFT}? {
                return nftRef
            }
            return nil
        }

        access(all) fun deposit(token: @{NonFungibleToken.NFT}) {
            let token <- token as! @TopShot.NFT
            let id = token.id
            self.ownedNFTs[id] <-! token
            if self.owner?.address != nil {
                emit Deposit(id: id, to: self.owner?.address)
            }
        }

        access(NonFungibleToken.Withdraw) fun withdraw(withdrawID: UInt64): @{NonFungibleToken.NFT} {
            let nft = self.borrowNFT(withdrawID)
            let token <- self.ownedNFTs.remove(key: withdrawID)
                ?? panic("Cannot withdraw: Moment does not exist in the collection")
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <-token
        }

        access(all) view fun getSupportedNFTTypes(): {Type: Bool} {
            let supportedTypes: {Type: Bool} = {}
            supportedTypes[Type<@TopShot.NFT>()] = true
            return supportedTypes
        }

        access(all) view fun isSupportedNFTType(type: Type): Bool {
            return type == Type<@TopShot.NFT>()
        }

        access(all) fun createEmptyCollection(): @{NonFungibleToken.Collection} {
            return <- TopShot.createEmptyCollection(nftType: Type<@TopShot.NFT>())
        }
    }

    access(all) fun createEmptyCollection(nftType: Type): @{NonFungibleToken.Collection} {
        return <- create Collection()
    }

    access(all) view fun getContractViews(resourceType: Type?): [Type] {
        return []
    }

    access(all) view fun resolveContractView(resourceType: Type?, viewType: Type): AnyStruct? {
        return nil
    }

    init() {
        self.totalSupply = 0

        let collection <- create Collection()
        collection.deposit(token: <- create NFT(id: 1))
        collection.deposit(token: <- create NFT(id: 2))
        collection.deposit(token: <- create NFT(id: 3))
        collection.deposit(token: <- create NFT(id: 4))
        collection.deposit(token: <- create NFT(id: 5))

        self.account.storage.save(<- collection, to: /storage/MomentCollection)
        let cap = self.account.capabilities.storage.issue<&Collection>(/storage/MomentCollection)
        self.account.capabilities.publish(cap, at: /public/MomentCollection)
    }
}
