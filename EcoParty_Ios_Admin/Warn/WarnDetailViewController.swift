//
//  WarnDetailViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/3/4.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class WarnDetailViewController: UIViewController {
    var warn : Warn?
    var image : Data?
    var msg = Msg()
    var url_server : URL?
    var deleteId : Int?
    
    @IBOutlet weak var warnUserLabel: UILabel!
    @IBOutlet weak var warnContentLabel: UILabel!
    @IBOutlet weak var warnUserImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
        var requestParam = [String:Any]()
        requestParam["action"] = "getOneById"
        let servlet:String
        if (warn?.messageId) != nil{
            servlet = "PartyMessageServlet"
            deleteId = warn?.messageId
            requestParam["id"] = deleteId
        }else{
            servlet = "PartyPieceServlet"
            deleteId = warn?.pieceId
            requestParam["id"] = deleteId
        }
        url_server = URL(string: common_url + servlet)
        showDetial(requestParam)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warnUserLabel.text = warn?.account
        warnContentLabel.text = warn?.content
        warnUserImageView.image = UIImage(data: image!)
        
    }
    
    func showDetial(_ requestParam:[String:Any]){
        
        executeTask(url_server!, requestParam) { (data, response, error) in
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(format)
            
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? decoder.decode(Msg.self, from: data!) {
                        self.msg = result
                        DispatchQueue.main.async {
                            /* 抓到資料後重刷table view */
                            self.userLabel.text = self.msg.account
                            self.contentLabel.text = self.msg.content
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //    }
    
    func deleteWarn() {
        let servlet:String
        if (warn?.messageId) != nil{
            servlet = "MsgWarnServlet"
        }else{
            servlet = "PieceWarnServlet"
        }
        url_server = URL(string: common_url + servlet)
        var requestParam = [String: Any]()
        requestParam["action"] = "warnDelete"
        requestParam["id"] = self.warn?.id
        executeTask(url_server!, requestParam
            , completionHandler: { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: true)
                                        
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                    let controller = UIAlertController(title: "error", message: "delete warn fail", preferredStyle: .alert)
                                       controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                       self.present(controller, animated: true, completion: nil)
                }
        })
    }
    func deleteMsg() {
        var requestParam = [String: Any]()
        requestParam["action"] = "deleteById"
        requestParam["id"] = deleteId
        executeTask(url_server!, requestParam
            , completionHandler: { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                    let controller = UIAlertController(title: "error", message: "delete msg fail", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                }
        })
    }
    @IBAction func deleteWarn(_ sender: Any) {
        deleteWarn()
    }
    @IBAction func deleteMsg(_ sender: Any) {
        deleteMsg()
    }
    @IBAction func deleteUser(_ sender: Any) {
        deleteMsg()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}
