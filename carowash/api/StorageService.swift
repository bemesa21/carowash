//
//  StorageService.swift
//  carowash
//
//  Created by Berenice Medel on 20/09/21.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class StorageService {
    static func savePhoto(uid: String,
                          data: Data, metadata: StorageMetadata,
                          onSuccess: @escaping() -> Void,
                          onError: @escaping(_ errorMessage: String) -> Void) {
        let storageRef = Ref().storageSpecificProfile(uid: uid)
        storageRef.putData(data, metadata: metadata) { (_, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL { (url, error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.commitChanges { (error) in
                            if let error = error {
                                onError(error.localizedDescription)
                                return
                            }
                        }
                    }
                    let userInfo: [String: String] = [
                        "profileImageUrl": metaImageUrl
                    ]
                    Ref().databaseSpecificUser(uid: uid).updateChildValues(userInfo) { (error, _) in
                        if error == nil {
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
