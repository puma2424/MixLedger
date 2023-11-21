//
//  AddNewAccountViewController.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/21.
//

import UIKit

class AddNewAccountViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let budgetLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let buggetTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .namePhonePad
        return textField
    }()
    
    func setupTextField(){
        nameTextField.delegate = self
        buggetTextField.delegate = self
    }
    
    func setView(){
        
    }
}
