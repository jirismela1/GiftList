//
//  GIftModel.swift
//  GiftList
//
//  Created by Jirka  on 09/06/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import Foundation

struct Gift: Codable{
    var typeOfCelebrating: String = String()
    var date: Date = Date()
    var eventDay: Date = Date()
    
    var invitePerson: [String: Bool] = [String: Bool]()
    
    var budget: Int = 0
    var splitBudget: [String: Price] = [String: Price]()
    
    var maps: String = String()
    
//    Images storage
}
struct Price: Codable{
    var percentPerOne: Int = 0
    var pricePerOne: Double = 0.0
}
