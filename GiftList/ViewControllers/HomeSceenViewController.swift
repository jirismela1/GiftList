//
//  HomeSceenViewController.swift
//  GiftList
//
//  Created by Jirka  on 21/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HomeSceenViewController: UIViewController {
//MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
//MARK: - IBAction
    @IBAction func signOutAction(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
        }catch let error{
            print(error)
        }
//        ? popViewController and dismiss?
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewGift(_ sender: UIBarButtonItem) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc2 = segue.destination as? AddNewGiftViewController, segue.identifier == "NewPerson"{
            vc2.userName = userName
        }
    }
    
//    private var listener: ListenerRegistration!
    
    var userName = ""
    
    
    private var db: Firestore!
    private var storage = Storage.storage().reference()
    
    private var refUserCollection: CollectionReference!
    private var personImage: StorageReference!
    
    private var personList = [String]()
    
//MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        
        refUserCollection = db.collection("users").document(userName).collection("Person")
        personImage = storage.child("users/\(userName)")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDocumentsFromCollection()
        
    }
}
//MARK: - TableView - Delegate, DataSource
extension HomeSceenViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = personList[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        downloadPersonProfileImage(selectedUserName: personList[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Extension Functions
extension HomeSceenViewController {
    private func loadDocumentsFromCollection(){
        personList.removeAll()
        refUserCollection.getDocuments { (querySnapshot, error) in
            if let error = error{
                print("Error getting documents: \(error)")
            }else{
                for document in querySnapshot!.documents{
                    self.personList.append(document.documentID)
                }
                self.tableView.reloadData()
            }
        }
    }
    private func loadTappedPerson(selectedUserName: String, imageData: Data){
        
        refUserCollection.document(selectedUserName).getDocument { (document, error) in
            let result = Result{
                try document?.data(as: UserProfile.self)
            }
            switch result{
            case .success(let user):
                if let user = user{
                    let vc = self.storyboard?.instantiateViewController(identifier: "InfoGiftPerson") as! GiftInfoViewController
                    vc.personProfileImage = UIImage(data: imageData)
                    vc.profileGiftsPerson = user
                    self.navigationController?.pushViewController(vc, animated: true)
                    print("User: ",user)
                }else{
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    private func downloadPersonProfileImage(selectedUserName: String){
       
        personImage.child("\(selectedUserName)/profileImage.jpg").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("dodnloadPersonProfileImage Error: ",error)
               
            }else{
                guard let data = data else{ return }
                
                self.loadTappedPerson(selectedUserName: selectedUserName,imageData: data)
    
            }
        }
    }
    
//    private func loadFieldsFromDocuments(_ collectionPath: String,_ documentPath: String){
//        db.collection(collection).document("Gift").collection(collectionPath).document(documentPath).getDocument { (document, error) in
//            let result = Result {
//                try document?.data(as: PersonFirebase.self)
//            }
//            switch result{
//            case .success(let person):
//                if let person = person{
//                    self.passDocumentsField = PersonFirebase(name: person.name, age: person.age, role: person.role)
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "List") as! GiftInfoViewController
//                    vc.documentsFields = self.passDocumentsField
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            case .failure(let error):
//                // A `ProfileGiftsPerson` value could not be initialized from the DocumentSnapshot.
//                print("Error dexoding city: \(error)")
//            }
//        }
//    }
    
}
 
