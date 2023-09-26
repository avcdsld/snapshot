import "Snapshot"
import "SnapshotLogic"

// This transaction is executed by the `Admin` account and makes SnapshotLogic.BasicLogic ready for us.
//
transaction {
    prepare(signer: AuthAccount) {
        let admin = signer.borrow<&Snapshot.Admin>(from: Snapshot.AdminStoragePath) ?? panic("Not found")
        let logic = SnapshotLogic.BasicLogic()
        admin.addLogic(logic: logic)
    }
}
