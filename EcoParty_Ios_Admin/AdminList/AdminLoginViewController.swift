//
//  AdminLoginViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/27.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class AdminLoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var msgTF: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTF.delegate = self
        passwordTF.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    //return key 跳到下一個輸入框
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        accountTF.resignFirstResponder()
        if(textField == self.accountTF){
            self.passwordTF.becomeFirstResponder()
        }
        if accountTF.text!.isEmpty == false, passwordTF.text!.isEmpty == false {
            //設定Login方法依憑在一個空Button
            LoginButton(UIButton())
        }
        return true
    }
    
   
    
    //一鍵輸入 - 按welcome
    @IBAction func keyInButton(_ sender: Any) {
        accountTF.text = "@admin01"
        passwordTF.text = "a01"
    }
    
    func login(admin: Admin, completion: @escaping (Bool)-> Void) {
        let url = URL(string: "http://localhost:8080/EcoParty/AdminServlet")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        //底線
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let data = try? encoder.encode(admin) {
            URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
                if let data = data, let result = try? JSONDecoder().decode(Bool.self, from: data) {
                    completion(result)
                } else {
                    completion(false)
                }
            }.resume()
        }
        
    }
    
    //登入
    @IBAction func LoginButton(_ sender: UIButton) {
        let account = accountTF.text == nil ? "" : accountTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTF.text == nil ? "" : passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if account!.isEmpty || password!.isEmpty{
            msgTF.text = "帳號或密碼不可空白"
            return
        }
    
        let admin = Admin(account!, password!)
        
        //Login後轉至首頁
        login(admin: admin) { (result) in
            if result {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showHome", sender: nil)
                }
            }
        }
        return
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
