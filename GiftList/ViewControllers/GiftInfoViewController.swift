//
//  GiftInfoViewController.swift
//  GiftList
//
//  Created by Jirka  on 22/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class GiftInfoViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBAction func editProfile(_ sender: UIBarButtonItem) {
        
    }
    
    var documentsFields: Person?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileName?.text = documentsFields?.name
        
    }

}
