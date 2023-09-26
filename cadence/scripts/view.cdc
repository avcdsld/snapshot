import "Snapshot"
import "SnapshotViewer"

// This script displays a snapshot in HTML format at a specific time stored at a specified address.
//
pub fun main(address: Address): String {
    let album = getAccount(address).getCapability(Snapshot.AlbumPublicPath).borrow<&{Snapshot.AlbumPublic}>() ?? panic("Not Found")

    let viewer = SnapshotViewer.BasicHTMLViewer()

    for time in album.snaps.keys {
        let view = album.view(time: time, viewer: viewer)
        return (view as! String)!
    }
    return ""
}
