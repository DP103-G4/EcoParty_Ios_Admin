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
    var admin : Admin!
    let url_server = URL(string: common_url + "AdminServlet")
    
    override func viewDidLoad() {
          super.viewDidLoad()
      }

//    override func viewWillAppear(_ animated: Bool) {
//       showSelf()
//    }


   //顯示自己的編號
//    func showSelf(){
//        adminAccountLabel.text = admin.adminAccount
//        let requestParam = ["action" : "getAdminByAccount"]
//       
//        executeTask(url_server!, requestParam) { (data, response, erroe) in
//            if error == nil {
//                if data != nil {
//                    if let result = String(data: data!, encoding: .utf8){
//
//                    }
//
//                }
//            }
//        }

    

//登出
//    @IBAction func logoutButton(_ sender: Any) {
//
//
//        logout(admin: admin){ (result) in
//            if result {
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "backHome", sender: nil)
//                }
//            }
//
//        }
//        return
//    }
//}
  


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
