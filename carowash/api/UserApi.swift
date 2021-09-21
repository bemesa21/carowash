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
            
            Database.database().reference().child("users/\(authData!.user.uid)").getData { (error, snapshot) in
                if let error = error {
                    print("Error getting data \(error)")
                }
                else if snapshot.exists() {
                    let defaults = UserDefaults.standard
                    defaults.setValue(snapshot.value!, forKey: "currentUser")
                    print("Got data \(snapshot.value!)")
                }
                else {
                    print("No data available")
                }
            }
            
            onSuccess()
        }
    }
    
    func downloadProfilePhoto(onSuccess: @escaping(_ data: Data) -> Void,
                              onError: @escaping(_ errorMessage: String) -> Void){
        let defaults = UserDefaults.standard
        if let currentUser = defaults.dictionary(forKey: "currentUser"){
            print(currentUser)
            if let imageUrl = currentUser["profileImageUrl"]! as? String{
                print(imageUrl)
                let httpsReference = Ref().storageFromUrl(url: imageUrl)
                
                httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                  if error == nil {
                    onSuccess(data!)
                  }else{
                    onError(error!.localizedDescription)
                  }
                }
            }
        }
    }
}
