//
//  Admin.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/27.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation

struct Admin: Codable {

//    var adminId: Int
    var adminAccount: String
    var adminPassword: String
    var action = "isAdminLogin"

    init(_ adminAccount: String, _ adminPassword: String) {
       
        self.adminAccount = adminAccount
        self.adminPassword = adminPassword

    }
    
    

}
