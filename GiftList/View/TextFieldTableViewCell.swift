//
//  TextFieldTableViewCell.swift
//  GiftList
//
//  Created by Jirka  on 28/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit



class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

