//
//  News.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/22.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation
//test
struct News : Codable {
    var id : Int?
    var title : String
    var content : String
    var time : Date?
    
    struct imageList:Codable {
        var image:Data?
        var id:Int
    }
}
