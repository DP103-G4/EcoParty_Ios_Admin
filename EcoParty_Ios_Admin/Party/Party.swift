//
//  Party.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/21.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation
struct Party : Codable {
    var party_id:Int
    var owner_id:Int
    var party_cover_img:Data
    var party_name:String
    var party_start_time:Date
    var party_address:String
    var party_content:String
    var party_count_upper_limit:Int
    var user_account:String
    
}
