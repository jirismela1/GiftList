//
//  ViewController.swift
//  GiftList
//
//  Created by Jirka  on 21/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class LoginSignupViewController: UIViewController {

    //MARK: - IBOulet
    @IBOutlet weak var userImageProfile: UIImageView!
    
    @IBOutlet weak var loginSignupSegment: UISegmentedControl!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var loginSignupButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var signUpChoiceStack: UIStackView!
    @IBOutlet weak var addProfileImageStack: UIStackView!
    
    //MARK: - IBAction
    @IBAction func addPhotoAcion(_ sender: UIButton) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(identifier: "ProfileImage") as! SetPhotoViewController
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginSignupButtonAction(_ sender: UIButton) {
        guard let name = nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        if loginSignupSegment.selectedSegmentIndex == 1{
            createOrLoginUser(userName: name)
        }else{
           singUpUser(userName: name)
        }
    }
    
    @IBAction func loginSignupActionSegment(_ sender: UISegmentedControl) {
        if loginSignupSegment.selectedSegmentIndex == 1{
            loginSignupButton.setTitle(loginSignupSegment.titleForSegment(at: 1), for: .normal)
            signUpChoiceStack.isHidden = false
            addProfileImageStack.alpha = 1
        }else{
            loginSignupButton.setTitle(loginSignupSegment.titleForSegment(at: 0), for: .normal)
            signUpChoiceStack.isHidden = true
            addProfileImageStack.alpha = 0
        }
            changeLoginTable(false)
    }
    
    
    private var db: Firestore!
    private let password = "123456"
    private var userProfile = UserProfile()
    private let storage = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        fullnameTextField.delegate = self
        birthdayTextField.delegate = self
        db = Firestore.firestore()
        userImageProfile.layer.cornerRadius = userImageProfile.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeLoginTable()
//        nicknameTextField.text = "jira"
    }
}
//MARK: - Extension UITextFieldDelgate
extension LoginSignupViewController: UITextFieldDelegate{
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if loginSignupSegment.selectedSegmentIndex == 0{
            return true
        }
        
        guard let text = textField.text else {return false}
    
        if string != "\n", text.count != 0{
            // condition for deleting last index character from textField
            let index = text.index(text.startIndex, offsetBy: text.count - 1)
            switch textField.placeholder{
            case "Nickname":
                userProfile.nickname = string == "" ? String(text[..<index]) : text + string
            case "Fullname":
                userProfile.fullName = string == "" ? String(text[..<index]) : text + string
            default:
                break
            }
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
 
        if textField.placeholder == "--/--/----"{
            view.endEditing(true)
            let vc = storyboard?.instantiateViewController(identifier: "DatePicker") as! DatePickerViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
}
//MARK: - Extension Functions
extension LoginSignupViewController{
    private func createOrLoginUser(userName: String){
        let email = userName + "@gift.com"
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error{
                    self.errorLabel.text = error.localizedDescription.contains("connection") ?
                        "Oops, your connection seems off.." : "That name is already being used, try different"
                    self.errorLabel.isHidden = false
                }else{
                    self.db.collection("users").getDocuments { (querySnapshot, error) in
                        if let error = error{
                            print("Error getting documents: \(error)")
                        }else{
                            var documentsInCollection = [String]()
                            for document in querySnapshot!.documents{
                                documentsInCollection.append(document.documentID)
                            }
                            if !documentsInCollection.contains(userName){
                                do{
                                    try self.db.collection("users").document(userName).setData(from: self.userProfile)
                                }catch let err{
                                    print(err)
                                }
                                self.uploadImageToNewProfile(userName: userName)
                            }
                        }
                    }
                    self.showHomeScreen(userName)
                }
            }
    }
    
    private func uploadImageToNewProfile(userName: String){
        if let dataImage = userImageProfile.image?.jpegData(compressionQuality: 0.75){
            let imageRef = storage.child("users/\(userName)/profileImage.jpg")
            imageRef.putData(dataImage, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("error: ",error.localizedDescription.description)
                    return
                }
                imageRef.downloadURL { (url, error) in
                    if let error = error{
                        print("error: ",error.localizedDescription.description)
                        return
                    }
                }
            }
        }
    }
    
    private func singUpUser(userName: String){
        let email = userName + "@gift.com"
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                self.errorLabel.text = error.localizedDescription.contains("connection") ?
                    "Oops, your connection seems off.." : "Wrong login name"
                self.errorLabel.isHidden = false
            }else{
                self.showHomeScreen(userName)
            }
        }
    }
    private func changeLoginTable(_ root: Bool = true){
        errorLabel.isHidden = true
        errorLabel.text = ""
        nicknameTextField.text = ""
        fullnameTextField.text = ""
        birthdayTextField.text = "--/--/----"
        userImageProfile.image = UIImage(systemName: "person.circle")
        
        if root{
            loginSignupButton.setTitle(loginSignupSegment.titleForSegment(at: 0), for: .normal)
            loginSignupSegment.selectedSegmentIndex = 0
            signUpChoiceStack.isHidden = true
            addProfileImageStack.alpha = 0
        }
    }
    
    private func showHomeScreen(_ name: String){
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Destination") as? UINavigationController,
            let yourViewController = controller.viewControllers.first as? HomeSceenViewController {
            yourViewController.userName = name
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
        }
    }
}

//MARK: - Extension AddProfileImage
extension LoginSignupViewController: AddProfileImage{
    func setProfileImage(_ image: UIImage?) {
        dismiss(animated: true) {
            self.userImageProfile.image = image
        }
    }
}

//MARK: - Extension SetBirthday
extension LoginSignupViewController: SetBirthday{
    func birthdayAndAge(age: Int, _ birthday: String, date: Date) {
        birthdayTextField.text = birthday
        userProfile.birthDay = birthday
        userProfile.age = age
        userProfile.birthDayDate = date
    }
}
