//
//  OrderApi.swift
//  carowash
//
//  Created by Berenice Medel on 25/09/21.
//

import Foundation
import FirebaseDatabase
class OrderApi {

    func create(dict: [String: String],
                onSuccess: @escaping() -> Void,
                onError: @escaping(_ errorMessage: String) -> Void) {
        Ref().databaseOrders.childByAutoId().updateChildValues(dict) {error, _ in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                onSuccess()
            }
        }
    }

    func getByUserId(userId: String, onSuccess: @escaping(_ orders: [Order]) -> Void,
                     onError: @escaping(_ errorMessage: String) -> Void) {
        Ref().databaseOrders
            .queryLimited(toLast: 10)
            .observe(.value, with: { snapshot in
                var orders: [Order] = []
                // swiftlint:disable force_cast
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let childParams = child.value as! [String: String]
                    let order = Order(orderParams: childParams)
                    orders.append(order)
                }
                // swiftlint:enable force_cast
                onSuccess(orders)
                })
        }

}
