//
//  AdminSelfViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class AdminSelfViewController: UIViewController {
    
  
         
    @IBOutlet weak var adminIDLabel: UILabel!
    @IBOutlet weak var adminAccountLabel: UILabel!
     var admins = [Admin]()
    let url_server = URL(string: common_url + "AdminServlet")
    
//    override func viewWillAppear(_ animated: Bool) {
//        let requestParam =  [ "action" : "findByAdminID" ]
//        executeTask(url_server!, requestParam) { (data, response, error) in
//            if error == nil{
//                if data != nil {
//                    print("input: \(String(data: data! , encoding: .utf8)!)")
//
//                    if let result = try? JSONDecoder.decode([Admin].self, from: data!){
//
//                    }
//                }
//            }
//        }
//
//    }
//
//    func showSelf(_ jsonData: Data){
//
//
//    }
//
//
//    @IBAction func logoutButton(_ sender: Any) {
//        let adminDefaults = UserDefaults.standard
//        adminDefaults.set(nil, forKey: "admin")
//        dismiss(animated: true)
//    }
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
