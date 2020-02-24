//
//  News.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/22.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation
struct News : Codable {
    var news_id : Int
    var news_title : String
    var news_content : String
    var news_img : Data
    var news_time : Date
}
