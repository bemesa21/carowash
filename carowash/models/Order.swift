//
//  Order.swift
//  carowash
//
//  Created by Berenice Medel on 26/09/21.
//

import Foundation

struct Order {

    let type: String
    let date: String
    let cost: String
    let status: String
    let userId: String
    let address: String
    let uid: String

    init(orderParams: [String: String]) {
        type = orderParams["type"] ?? ""
        uid = orderParams["uid"] ?? ""
        date = orderParams["date"] ?? ""
        cost = orderParams["cost"] ?? ""
        status = orderParams["status"] ?? ""
        userId = orderParams["userId"] ?? ""
        address = orderParams["address"] ?? ""
    }
}
