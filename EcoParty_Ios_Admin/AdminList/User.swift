//
//  User.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/27.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation

struct User: Codable {
    var user_id: Int
    var user_account: String
    var user_password: String
    var user_email: String
    var user_name: String
    var user_img: Data
    var user_over: Bool
    var user_time: Date
}
