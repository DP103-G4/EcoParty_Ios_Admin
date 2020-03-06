//
//  Warn.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/3/4.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation

struct Warn : Codable {
    var id:Int
    var messageId:Int?
    var pieceId:Int?
    var userId:Int
    var time:Date?
    var content:String
    var account:String
    
    struct imgList {
        var image:Data
        var userId:Int
    }
}

struct Msg : Codable {
    var userId : Int?
    var content : String?
    var time : Date?
    var account : String?
}




