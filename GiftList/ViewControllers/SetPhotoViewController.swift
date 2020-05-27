//
//  SetPhotoViewController.swift
//  GiftList
//
//  Created by Jirka  on 26/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import UIKit

class SetPhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    let cellId = "EmojiCell"
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let emojiImages = [["boy", "girl"],
                       ["older-man", "older-woman", "family"],
                       ["man", "bearded-person", "man-facepalming", "prince",
                       "woman", "blonde-woman", "woman-facepalming", "princess",
                       "male-health-worker", "female-health-worker", "male-office-worker", "female-office-worker",
                       "artist", "astronaut", "construction-worker", "cook",
                       "factory-worker", "farmer", "pilot", "police-officer",
                       "mechanic", "student", "technologist", "scientist",
                       "firefighter"],
                       ["dog", "cat", "hamster", "rabbit-face",
                       "fish", "horse", "chicken", "pig"]]
    
   
    @IBAction func cameraButton(_ sender: UIButton) {
        
    }
    @IBAction func libraryButton(_ sender: UIButton) {
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
        imageProfile.layer.masksToBounds = true
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        emojiImages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojiImages[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EmojiCollectionViewCell
        
        cell.image.image = UIImage(named: emojiImages[indexPath.section][indexPath.row])
        

        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 4
        let padding: CGFloat = 33
        let collectionViewWidth: CGFloat = collectionView.frame.width - (padding * (itemsPerRow - 1))

        let widthPerItem: CGFloat = collectionViewWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(21)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 21, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageProfile.image = UIImage(named: emojiImages[indexPath.section][indexPath.row])
    }

}

class EmojiCollectionViewCell: UICollectionViewCell{
    
  
    @IBOutlet weak var image: UIImageView!
    
    
}
