import "Snapshot"
import "TopShot"

// This script obtains proof of ownership of a specific NFT for a specified time range
// from snapshots stored at a specified address.
//
pub fun main(address: Address): &Snapshot.Snap? {
    let album = getAccount(address).getCapability(Snapshot.AlbumPublicPath).borrow<&{Snapshot.AlbumPublic}>() ?? panic("Not Found")
    return album.proofOfOwnership(
        startTime: 1695648.0, // 2023-09-25 22:20:00
        endTime: getCurrentBlock().timestamp,
        collectionPublicPath: "/public/MomentCollection",
        nftType: Type<@TopShot.NFT>(),
        nftID: 1,
        ownerAddress: address
    )
}
