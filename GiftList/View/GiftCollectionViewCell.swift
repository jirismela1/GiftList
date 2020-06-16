//
//  GiftCollectionViewCell.swift
//  GiftList
//
//  Created by Jirka  on 09/06/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class GiftCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
