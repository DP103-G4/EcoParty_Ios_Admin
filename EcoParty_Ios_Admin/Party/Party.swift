//
//  Party.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/21.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation
struct Party : Codable {
    var id:Int
    var ownerId:Int
    var name:String
    var startTime:Date
    var address:String
    var content:String
    var countUpperLimit:Int
    var ownerName:String
    
    struct imageList:Codable {
           var image:Data?
           var id:Int?
    }
    
}

struct Review : Codable {
    var id:Int
}

struct Inform:Codable {
    var userId:Int
    var partyId:Int
    var content:String
}
