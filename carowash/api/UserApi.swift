//
//  UserApi.swift
//  carowash
//
//  Created by Berenice Medel on 03/09/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserApi{
    func signUp(withUsername username: String, email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) {
            (authDataResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
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
                    .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
                        (error, _) in
                        if error == nil {
                            onSuccess()
                        }else{
                            onError(error!.localizedDescription)
                        }
                    })
            }
        }
    }
}
