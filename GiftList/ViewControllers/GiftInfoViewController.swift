//
//  GiftInfoViewController.swift
//  GiftList
//
//  Created by Jirka  on 22/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class GiftInfoViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - IBAction
    @IBAction func editProfile(_ sender: UIBarButtonItem) {
      
    }
    @IBAction func extraInformationButtonAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "ExtraInformationView") as! ExtraInformationViewController
        
        vc.profileGiftsPerson = profileGiftsPerson
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var personProfileImage: UIImage?
    
    private var numberOfItems: Int = 6
    
    var profileGiftsPerson = UserProfile()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.image = personProfileImage
        
        profileName?.text = profileGiftsPerson.fullName
        birthdayLabel?.text = profileGiftsPerson.birthDay
        if let age = profileGiftsPerson.age{
            ageLabel?.text = String(age)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: "GiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.giftCollectionCell)
        collectionView.register(UINib(nibName: "EmptyGiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: K.emptyGiftCollectionCell)
    }
    
}

extension GiftInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != numberOfItems - 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.giftCollectionCell, for: indexPath) as! GiftCollectionViewCell
            cell.cellTitleLabel.text = "Birthday"
            cell.dateLabel.text = "25/12/2020"
            cell.photoImage.image = UIImage(named: "farmer")
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.emptyGiftCollectionCell, for: indexPath) as! EmptyGiftCollectionViewCell
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 124, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "GiftViewController") as! GiftViewController
        vc.type = "Birthday"
        vc.date = "25/12/2020"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
