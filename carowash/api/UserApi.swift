//
//  UserApi.swift
//  carowash
//
//  Created by Berenice Medel on 03/09/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserApi {
    func signUp(withUsername username: String,
                email: String,
                password: String,
                onSuccess: @escaping() -> Void,
                onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authDataResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            if let authData = authDataResult {
                let dict: [String: String] = [
                    "uid": authData.user.uid,
                    "email": authData.user.email!,
                    "name": username,
                    "profileImageUrl": "",
                    "status": "enabled"
                ]
                Database.database().reference().child("users")
                    .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {(error, _) in
                        if error == nil {
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    })
            }
        }
    }

    func logIn(withEmail email: String,
               password: String,
               onSuccess: @escaping() -> Void,
               onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            let defaults = UserDefaults.standard
            defaults.setValue(authData!.user.uid, forKey: "currentUser")
            onSuccess()
        }
    }

    func downloadProfilePhoto(imageUrl: String, onSuccess: @escaping(_ data: Data) -> Void,
                              onError: @escaping(_ errorMessage: String) -> Void) {
        if imageUrl != "" {
            let httpsReference = Ref().storageFromUrl(url: imageUrl)
            httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if error == nil {
                onSuccess(data!)
              } else {
                onError(error!.localizedDescription)
              }
            }
        } else {
            onError("noImageFound")
        }
    }

    func getUser(userId: String, onSuccess: @escaping(_ user: User) -> Void,
                 onError: @escaping(_ errorMessage: String) -> Void) {
        Database.database().reference().child("users/\(userId)").getData { (error, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            } else if snapshot.exists() {
                let dict = snapshot.value as? [String: Any]
                let name = dict!["name"] as? String
                let uid = dict!["uid"] as? String
                let profileImage = dict!["profileImageUrl"] as? String
                let email = dict!["email"] as? String ?? ""
                let phone = dict!["phone"] as? String ?? ""

                let currentUser = User(name: name!,
                                       profileImageUrl: profileImage!,
                                       uid: uid!,
                                       email: email,
                                       phone: phone)
                onSuccess(currentUser)
            } else {
                onError("User not found")
            }
        }
    }

    func updateUser(userId: String, key: String, value: String, onSuccess: @escaping() -> Void,
                    onError: @escaping(_ errorMessage: String) -> Void) {
        Database.database().reference().child("users/\(userId)").updateChildValues([key: value]) {error, _ in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                onSuccess()
            }
        }
    }
}
