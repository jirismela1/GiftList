//
//  Task.swift
//  GiftList
//
//  Created by Jirka  on 22/05/2020.
//  Copyright © 2020 JirkaSmela. All rights reserved.
//

import Foundation


struct Person: Codable{
    var name: String = ""
    var age: Int = 0
    var role: String = ""
    
//    var dictionary: [String: Any] {
//        return ["name": name,
//                "age": age,
//                "role": role
//        ]
//    }
}
//extension Person{
//    init?(dictionary: [String: Any]) {
//        guard let name = dictionary["name"] as? String,
//        let age = dictionary["age"] as? Int,
//        let role = dictionary["role"] as? String
//            else {return nil}
//
//        self.init(name: name, age: age,role: role)
//    }
//}
