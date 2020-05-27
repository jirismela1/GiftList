//
//  HomeSceenViewController.swift
//  GiftList
//
//  Created by Jirka  on 21/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class HomeSceenViewController: UIViewController {
//MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoneDoneSegment: UISegmentedControl!
//MARK: - IBAction
    @IBAction func signOutAction(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
        }catch let error{
            print(error)
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func undoneDoneSegmentAction(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func addGift(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func editGiftList(_ sender: UIBarButtonItem) {
//        db.collection(collection).document("Gifts").collection("Undone").
    }
    
    private var db: Firestore!
    private var listener: ListenerRegistration!
    var collection = String()
    private var passDocumentsField = Person()
    
    
    
    private var doneDocuments = [String]()
    private var undoneDocuments = [String]()
//MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()

        db = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadDocumentsFromCollection("Done")
        loadDocumentsFromCollection("Undone")
        undoneDoneSegment.selectedSegmentIndex = 0
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        listener = db.collection("sjan").document("task").addSnapshotListener { (documentSnapshor, error) in
//            guard let document = documentSnapshor else{
//                print("Error fetching document: \(error!)")
//                return
//            }
//            guard let data = document.data() else {
//                print("Document data was empty.")
//                return
//            }
//            let source = document.metadata.hasPendingWrites ? "Local" : "Server"
//            print("\(source), \(document.data() ?? [:])")
//            print("Current data: \(data)")
//        }
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        listener.remove()
//
//    }
    
}
//MARK: - TableView - Delegate, DataSource
extension HomeSceenViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return undoneDoneSegment.selectedSegmentIndex == 0 ? doneDocuments.count : undoneDocuments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = undoneDoneSegment.selectedSegmentIndex == 0 ?  undoneDocuments[indexPath.row] : doneDocuments[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if undoneDoneSegment.selectedSegmentIndex == 0 {
            loadFieldsFromDocuments("Undone",undoneDocuments[indexPath.row])
        }else{
            loadFieldsFromDocuments("Done",doneDocuments[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Extension Functions
extension HomeSceenViewController {
    private func loadDocumentsFromCollection(_ collectionPath: String){
        db.collection(collection).document("Gifts").collection(collectionPath).getDocuments { (querySnapshot, error) in
            if let error = error{
                print("Error getting documents: \(error)")
            }else{
                
                for document in querySnapshot!.documents{
                    self.appendDocumentToDocumentArray(collectionPath, document.documentID)
                }
                self.tableView.reloadData()
            }
        }
    }
    private func loadFieldsFromDocuments(_ collectionPath: String,_ documentPath: String){
        db.collection(collection).document("Gifts").collection(collectionPath).document(documentPath).getDocument { (document, error) in
            let result = Result {
                try document?.data(as: Person.self)
            }
            switch result{
            case .success(let person):
                if let person = person{
                    self.passDocumentsField = Person(name: person.name, age: person.age, role: person.role)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "List") as! GiftInfoViewController
                    vc.documentsFields = self.passDocumentsField
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                // A `Person` value could not be initialized from the DocumentSnapshot.
                print("Error dexoding city: \(error)")
            }
        }
    }
    private func appendDocumentToDocumentArray(_ documentPath: String,_ documet: String){
        switch documentPath{
        case "Done":
            doneDocuments.append(documet)
        case "Undone":
            undoneDocuments.append(documet)
        default:
            break
        }
    }
}
 
