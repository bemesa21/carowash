//
//  Reference.swift
//  carowash
//
//  Created by Berenice Medel on 20/09/21.
//

import Foundation
import Firebase
import FirebaseStorage

let refUser = "users"
let urlStorageRoot = "gs://carowash-b25eb.appspot.com"
let storageProfileR = "profile"

class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()

    var databaseUsers: DatabaseReference {
        return databaseRoot.child(refUser)
    }

    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }

    let storageRoot = Storage.storage().reference(forURL: urlStorageRoot)

    var storageProfile: StorageReference {
        return storageRoot.child(storageProfileR)
    }

    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }

    func storageFromUrl(url: String) -> StorageReference {
        return Storage.storage().reference(forURL: url)
    }
}
