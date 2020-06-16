//
//  AddNewDetailsToPersonViewController.swift
//  GiftList
//
//  Created by Jirka  on 12/06/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol ReloadTableView{
    func reload()
}

class AddNewDetailsToPersonViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        if let title = titleTextField.text, let text = infoTextView.text{
            let newDetail = PersonExtraDetails(title: title, infoText: text)
            do{
               try refToPersonDetails.document(title).setData(from: newDetail)
                delegate?.reload()
                dismiss(animated: true, completion: nil)
            }catch{
                print("Add Details to personDetails: ",error)
            }
        }
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private var db = Firestore.firestore()
    
    var refToPersonDetails: CollectionReference!
    var delegate: ReloadTableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
