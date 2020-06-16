//
//  PersonInfoTableViewCell.swift
//  GiftList
//
//  Created by Jirka  on 09/06/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class PersonInfoTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
