//
//  News.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/22.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation
struct News : Codable {
    var id : Int
    var title : String
    var content : String
//    var news_img : Data
    var time : Date
   
    
}