//
//  MyServicesTableViewController.swift
//  carowash
//
//  Created by Berenice Medel on 26/09/21.
//

import UIKit

class MyServicesTableViewController: UITableViewController {
    var orders: [Order] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadOrders()
        tableView.rowHeight = 200
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as? ServiceTableViewCell
        cell!.typeLabel.text = self.orders[indexPath.row].type
        cell!.addressLabel.text = self.orders[indexPath.row].address
        cell!.dateAddress.text = self.orders[indexPath.row].date
        cell!.costLabel.text = "$\(self.orders[indexPath.row].cost)"
        cell!.statusLabel.text = self.orders[indexPath.row].status

        return cell!
    }

    func downloadOrders() {
        print("downloading orders")
        let defaults = UserDefaults.standard
        let currentUserId = defaults.string(forKey: "currentUser")
        Api.Order.getByUserId(userId: "1") { orders in
            self.orders = orders
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } onError: { (error) in
            print(error)
        }

    }

}
