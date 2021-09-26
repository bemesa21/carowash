//
//  EditViewController.swift
//  carowash
//
//  Created by Berenice Medel on 25/09/21.
//

import UIKit
import ProgressHUD
class EditViewController: UIViewController {
    var userField: UserField?
    weak var delegate: DisplayViewControllerDelegate?

    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fieldLabel.text =  userField?.optionLabel
        self.valueTextField.text =  userField?.oldValue
        self.saveButton.colorful()
        // Do any additional setup after loading the view.
    }

    @IBAction func updateValue(_ sender: Any) {
        ProgressHUD.show()
        Api.User.updateUser(userId: self.userField!.uid, key: self.userField!.field,
                            value: self.valueTextField!.text!) {
            ProgressHUD.dismiss()
            if let delegate = self.delegate {
                delegate.updateValue(data: self.valueTextField.text!)
            }
            self.navigationController?.popViewController(animated: true)
        } onError: { (_) in
            ProgressHUD.showError("Failed to update data")
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
