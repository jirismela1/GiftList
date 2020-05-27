//
//  ViewController.swift
//  GiftList
//
//  Created by Jirka  on 21/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginSignupViewController: UIViewController {

    //MARK: - IBOulet
    @IBOutlet weak var loginSignupSegment: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginSignupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - IBAction
    @IBAction func loginSignupButtonAction(_ sender: UIButton) {
        
        if let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            let email = name + "@gift.com"
            if let label = sender.titleLabel?.text, label == "Sign up"{
                Auth.auth().createUser(withEmail: email, password: "123456") { (result, error) in
                    if let error = error{
                        self.errorLabel.text = error.localizedDescription.contains("connection") ?
                            "Oops, your connection seems off.." : "That name is already being used, try different"
                        self.errorLabel.isHidden = false
                    }else{
                        self.showHomeScreen(name)
                    }
                }
            }else{
                Auth.auth().signIn(withEmail: email, password: "123456") { (result, error) in
                    if let error = error{
                        self.errorLabel.text = error.localizedDescription.contains("connection") ?
                        "Oops, your connection seems off.." : "Wrong login name"
                        self.errorLabel.isHidden = false
                    }else{
                        self.showHomeScreen(name)
                    }
                }
            }
        }
        view.endEditing(true)
    }
    
    
    @IBAction func loginSignupActionSegment(_ sender: UISegmentedControl) {
        if loginSignupSegment.selectedSegmentIndex == 1{
            loginSignupButton.setTitle(loginSignupSegment.titleForSegment(at: 1), for: .normal)
        }else{
            loginSignupButton.setTitle(loginSignupSegment.titleForSegment(at: 0), for: .normal)
        }
        
        textFieldDidBeginEditing(nameTextField,false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldDidBeginEditing(nameTextField)
    }
    
    private func showHomeScreen(_ name: String){
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Destination") as? UINavigationController,
            let yourViewController = controller.viewControllers.first as? HomeSceenViewController {
            yourViewController.collection = name
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
        }
    }
}
//MARK: - Extension UITextFieldDelgate
extension LoginSignupViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField,_ root: Bool = true) {
        errorLabel.isHidden = true
        errorLabel.text = ""
        nameTextField.text = ""
        if root{
            loginSignupButton.setTitle(loginSignupSegment.titleForSegment(at: 0), for: .normal)
            loginSignupSegment.selectedSegmentIndex = 0
        }
        
    }
}
