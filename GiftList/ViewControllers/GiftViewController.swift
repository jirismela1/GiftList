//
//  GiftViewController.swift
//  GiftList
//
//  Created by Jirka  on 10/06/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class GiftViewController: UIViewController {

    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var type: String = String()
    var date: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeTitle.text = type
        dateLabel.text = date
        
    }
    

    

}
