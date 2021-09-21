//
//  Reference.swift
//  carowash
//
//  Created by Berenice Medel on 20/09/21.
//

import Foundation
import Firebase

let REF_USER = "users"
let URL_STORAGE_ROOT = "gs://carowash-b25eb.appspot.com"
let STORAGE_PROFILE = "profile"

class Ref{
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference{
        return storageRoot.child(STORAGE_PROFILE)
    }
     
    func storageSpecificProfile(uid: String) -> StorageReference{
        return storageProfile.child(uid)
    }
}
