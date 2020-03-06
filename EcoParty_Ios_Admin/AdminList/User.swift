//
//  User.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/27.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation

struct User: Codable {
    //要跟sever一樣變數名稱
    var id: Int?
    var account: String?
    var password: String?
    var email: String?
    var name: String?
    var isOver: Bool?
    
    
    
//    public init(_ id: Int, _ account: String, _ password: String, _ email: String, _ name: String, _ isOver: Bool){
//        self.id = userId
//        self.account = account
//        self.password = password
//        self.email = email
//        self.name = name
//        self.isOver = isOver
//       
//    }
    
}
