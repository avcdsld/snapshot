// Dummy

import NonFungibleToken from 0xf8d6e0586b0a20c7
import MetadataViews from 0xf8d6e0586b0a20c7

pub contract TopShot: NonFungibleToken {

    pub var totalSupply: UInt64
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {
        pub let id: UInt64

        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>()
            ]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
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
    }

    pub resource interface MomentCollectionPublic {
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
    }

    pub resource Collection: MomentCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        init() {
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            pre {
                self.ownedNFTs[id] != nil: "NFT does not exist in the collection!"
            }
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        pub fun borrowNFTSafe(id: UInt64): &NonFungibleToken.NFT? {
            if let nftRef = &self.ownedNFTs[id] as &NonFungibleToken.NFT? {
                return nftRef
            }
            return nil
        }

        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @TopShot.NFT
            let id = token.id
            self.ownedNFTs[id] <-! token
            if self.owner?.address != nil {
                emit Deposit(id: id, to: self.owner?.address)
            }
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let nft = self.borrowNFT(id: withdrawID)
            let token <- self.ownedNFTs.remove(key: withdrawID)
                ?? panic("Cannot withdraw: Moment does not exist in the collection")
            emit Withdraw(id: token.id, from: self.owner?.address)
            return <-token
        }
    }

    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    init() {
        self.totalSupply = 0

        let collection <- create Collection()
        collection.deposit(token: <- create NFT(id: 1))
        collection.deposit(token: <- create NFT(id: 2))
        collection.deposit(token: <- create NFT(id: 3))
        collection.deposit(token: <- create NFT(id: 4))
        collection.deposit(token: <- create NFT(id: 5))

        self.account.save(<- collection, to: /storage/MomentCollection)
        self.account.link<&Collection{MomentCollectionPublic}>(/public/MomentCollection, target: /storage/MomentCollection)
    }
}
