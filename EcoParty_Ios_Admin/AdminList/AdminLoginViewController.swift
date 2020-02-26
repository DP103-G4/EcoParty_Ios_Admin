//
//  AdminLoginViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by mac on 2020/2/26.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//
import Foundation
import UIKit

class AdminLoginViewController: UIViewController {
    
    @IBOutlet weak var msgTF: UILabel!
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    let url_server = URL(string: common_url + "AdminServlet")
    
    
    
    @IBAction func LoginButton(_ sender: UIButton) {
        let account = accountTF.text == nil ? "" : accountTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTF.text == nil ? "" : passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if account!.isEmpty || password!.isEmpty{
            msgTF.text = "帳號或密碼不可空白"
            return
        }
        var requestParam = [String:Any]()
//        requestParam["action"] = ""
//        requestParam[""] =
//        let admin = Admin(account!, password!)
//         //編碼
//            executeTask(url_server!, requestParam){ (data, response, error) in
//                if error == nil {
//                    if data != nil {
//                        //解碼
//                        if let result = try? JSONDecoder().decode([String: Bool].self, from: data!){
//                            if result["login"]! {
//                                saveAdmin(admin)
//                                DispatchQueue.main.async {
//                                    self.performSegue(withIdentifier: "adminLogin", sender: self)
//                                }
//                            } else {
//                                DispatchQueue.main.async {
//                                    self.msgTextField = "帳號或密碼有誤"
//                                }
//                            }
//                            print(result)
//                        }
//                    }
//                } else {
//                    print(error!.localizedDescription)
//                }
//            }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}
