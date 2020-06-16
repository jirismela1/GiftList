//
//  UserProfile.swift
//  GiftList
//
//  Created by Jirka  on 05/06/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import Foundation

struct UserProfile: Codable{
    var fullName: String = ""
    var nickname: String = ""
    var status: String = ""
    var birthDay: String = "--/--/----"
    var birthDayDate: Date = Date()
    var age: Int? = nil
    var weight: Double = 0.0
    var height: Double = 0.0
    var sharePersons: [String] = []
}


struct PersonExtraDetails: Codable{
    var title: String
    var infoText: String
}
