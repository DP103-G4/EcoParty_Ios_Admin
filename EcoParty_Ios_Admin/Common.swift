//
//  Common.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/24.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import Foundation
import UIKit

let common_url = "http://127.0.0.1:8080/EcoParty/"

func executeTask(_ url_server: URL, _ requestParam: [String:String], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // 將輸出資料列印出來除錯用
    print("output: \(requestParam)")
    
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    // Object Array to JSON
    let encoder = JSONEncoder()
    // JSON含有日期時間，encode必須指定日期時間格式
    encoder.dateEncodingStrategy = .formatted(format)
    
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
//    let jsonData = try! encoder.encode(requestParam)
    
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
//    // JSON to Object Array
//    let decoder = JSONDecoder()
//    // JSON含有日期時間，decode必須指定日期時間格式
//    decoder.dateDecodingStrategy = .formatted(format)
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}
