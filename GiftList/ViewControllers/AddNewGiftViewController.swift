//
//  AddNewViewController.swift
//  GiftList
//
//  Created by Jirka  on 27/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

// Missing Error condition !!

class AddNewGiftViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    //MARK: - IBAction
    @IBAction func doneButtonAction(_ sender: UIButton) {
        do{
            try refUsersCollection.document(myPerson.fullName).setData(from: myPerson)
        }catch let error{
            print("Error writing city to Firestore: \(error)")
        }
        
        if let uploadData = profileImage.image?.jpegData(compressionQuality: 0.75){
            personProfileImage.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                   return
                }
                self.personProfileImage.downloadURL { (url, error) in
                    if error != nil{
                        print("error")
                        return
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addPhotoButton(_ sender: UIButton) {
        view.endEditing(true)
        let vc = storyboard?.instantiateViewController(identifier: "ProfileImage") as! SetPhotoViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Store Properties
    var userName: String = ""
    
    private var db: Firestore!
    private let storage = Storage.storage().reference()
    
    private lazy var refUsersCollection = db.collection("users").document(userName).collection("Person")
    
    private var myPerson = UserProfile()
    
    
    
    private var addedTextToTextField = false
    
    private lazy var personProfileImage = storage.child("users/\(userName)/\(myPerson.fullName)/profileImage.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        db = Firestore.firestore()
        
        
        let cellNib = UINib(nibName: "TextFieldTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: K.textFieldTalbeviewCell)
        
        tableView.rowHeight = 44
        tableView.keyboardDismissMode = .interactive
        
        doneButton.isEnabled = false
    }

}
//MARK: - Extension Protocol AddProfileImage
extension AddNewGiftViewController: AddProfileImage{
    func setProfileImage(_ image: UIImage?) {
        
        dismiss(animated: true) {
            self.profileImage.image = image
        }
    }
}

//MARK: - Extension Protocol SetBirthday
extension AddNewGiftViewController: SetBirthday{
    func birthdayAndAge(age: Int, _ birthday: String, date: Date) {
        
        myPerson.birthDayDate = date
        myPerson.birthDay = birthday
        myPerson.age = age
    
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: .automatic)
    }
}

//MARK: - Extension TableViewDataSource, Delegate
extension AddNewGiftViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.textFieldTalbeviewCell, for: indexPath) as! TextFieldTableViewCell
        cell.textField.delegate = self
        
        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "Name"
            cell.titleLabel?.text = "Fullname:"
            cell.textField.autocapitalizationType = .words
            cell.textField.autocorrectionType = .no
            cell.textField.addTarget(self, action: #selector(addNameToMyPerson(field:)), for: .editingChanged)
        case 1:
            cell.textField.placeholder = "--/--/----"
            cell.titleLabel?.text = "Birth Date:"
            
            if myPerson.birthDay != cell.textField.placeholder{
                cell.textField.text = myPerson.birthDay
            }
        case 2:
            cell.textField.placeholder = "--"
            cell.titleLabel?.text = "Age:"
            cell.textField.isUserInteractionEnabled = false
            
            if let age = myPerson.age{
                cell.textField.text = "\(age)"
            }
        default:
            break
        }
        return cell
    }
    
    @objc func addNameToMyPerson(field: UITextField){
        if field.text != ""{
            myPerson.fullName = field.text!
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
    }
}
//MARK: - Extension UITextFieldDelegate
extension AddNewGiftViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        return count <= 30
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

