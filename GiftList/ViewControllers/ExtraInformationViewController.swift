//
//  ExtraInformationViewController.swift
//  GiftList
//
//  Created by Jirka  on 10/06/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ExtraInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editItem(_ sender: UIBarButtonItem) {
       
    }
    @IBAction func addNewDetail(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "NewDetails") as! AddNewDetailsToPersonViewController
        vc.refToPersonDetails = refToPersonDetails
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    
    var profileGiftsPerson = UserProfile()
    
    private var popUpRow: Bool = false
    private var numberOfRowFirstSection = 0
    
    private var db = Firestore.firestore()
    private var refToPersonDetails: CollectionReference!
    private var detailsList: [String] = []
    
    private var personDetails: [PersonExtraDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "PersonInfoTableViewCell", bundle: nil), forCellReuseIdentifier: K.personInfoCell)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailsList.removeAll()
        personDetails.removeAll()
        loadDetailsDocument()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return personDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.personInfoCell, for: indexPath) as! PersonInfoTableViewCell
        cell.infoTitle.text = personDetails[indexPath.row].title
        cell.textView.text = personDetails[indexPath.row].infoText
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 92
    }
    
    func loadDetailsDocument(){
        if let email = Auth.auth().currentUser?.email{
            var name = email
            let range = name.index(name.endIndex, offsetBy: -9)..<name.endIndex
            name.removeSubrange(range)
            
            refToPersonDetails = db.collection("users").document(name).collection("Person").document(profileGiftsPerson.fullName).collection("ExtraDetails")
        }
        
        refToPersonDetails.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }else{
                for document in querySnapshot!.documents{
                    self.detailsList.append(document.documentID)
                }
                for document in self.detailsList{
                    self.refToPersonDetails.document(document).getDocument { (document, error) in
                        let result = Result {
                            try document?.data(as: PersonExtraDetails.self)
                        }
                        switch result{
                        case .success(let details):
                            if let details = details{
                                self.personDetails.append(details)
                                self.tableView.reloadData()
                            }else{
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding city: \(error)")
                        }
                        
                    }
                   
                }// end
            }
        }
    }
}
extension ExtraInformationViewController: ReloadTableView{
    func reload() {
        detailsList.removeAll()
        personDetails.removeAll()
        loadDetailsDocument()
    }
}
