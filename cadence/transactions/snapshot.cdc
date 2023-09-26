import "Snapshot"
import "SnapshotLogic"

// This transaction can be executed by anyone
// and stores a snapshot of the NFT information owned by the executor at that point in time.
//
transaction {
    prepare(signer: AuthAccount) {
        if signer.borrow<&Snapshot.Album>(from: Snapshot.AlbumStoragePath) == nil {
            signer.save(<- Snapshot.createEmptyAlbum(), to: Snapshot.AlbumStoragePath)
            signer.link<&{Snapshot.AlbumPublic}>(Snapshot.AlbumPublicPath, target: Snapshot.AlbumStoragePath)
        }
        let album = signer.borrow<&Snapshot.Album>(from: Snapshot.AlbumStoragePath)!
        let logic = SnapshotLogic.BasicLogic()
        album.snapshot(address: signer.address, logic: logic)
    }
}
