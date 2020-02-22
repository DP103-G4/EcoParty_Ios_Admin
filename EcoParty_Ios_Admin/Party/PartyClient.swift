//
//  PartyClient.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/21.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//
import UIKit
import Foundation

struct PartyClient {
    static var shared = PartyClient()
    
    func getAllPartys(completionHandler: @escaping ([Party]?) -> ()) {
        if let url = URL(string: "url"){
            URLSession.shared.dataTask(with: url) { (data, respose, error) in
                let decoder = JSONDecoder()
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime]
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    let data = try decoder.singleValueContainer().decode(String.self)
                    return dateFormatter.date(from: data) ?? Date()
                })
                if let data = data{
                    do{
                        _ = try decoder.decode([Party].self, from: data)
                    }catch{
                        print("getAll error")
                    }
                }else{
                    completionHandler(nil)
                }
            }.resume()
        }
    }
    
    
}
