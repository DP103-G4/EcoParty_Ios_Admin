//
//  MsgWarnTableViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/3/4.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class MsgWarnTableViewController: UITableViewController {

    var msgWarns = [Warn]()
    var imageList = [Warn.imgList]()
    let url_server = URL(string: common_url + "MsgWarnServlet")

    override func viewWillAppear(_ animated: Bool) {
        
        showMsgWarn()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

//   //下拉更新
//    func tableViewAddRefreshControl(){
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(showMsgWarn), for: .valueChanged)
//        self.tableView.refreshControl = refreshControl
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return msgWarns.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WarnCell", for: indexPath) as! WarnTableViewCell
        let msgWarn = msgWarns[indexPath.row]
        cell.msgWarnContentLabel.text = msgWarn.content
        cell.msgWarnUserLabel.text = msgWarn.account
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = msgWarn.userId
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        let url_userServer = URL(string: common_url + "UserServlet")
        executeTask(url_userServer!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                    self.imageList.append(Warn.imgList(image: data!, userId: msgWarn.userId))
                }
                if image == nil {
                    image = UIImage(named: "pig")
                }
                DispatchQueue.main.async { cell.msgWarnImageView.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
//        cell.deleteButton.tag = indexPath.row
        return cell
    }
    
   @objc func showMsgWarn(){
    var requestParam = [String:String]()
    requestParam["action"] = "getAll"
           executeTask(url_server!, requestParam) { (data, response, error) in
               let format = DateFormatter()
               format.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .formatted(format)
               
               if error == nil {
                   if data != nil {
                       // 將輸入資料列印出來除錯用
                       print("input: \(String(data: data!, encoding: .utf8)!)")
                       
                       if let result = try? decoder.decode([Warn].self, from: data!) {
                           self.msgWarns = result
                           DispatchQueue.main.async {
//                            if let control = self.tableView.refreshControl{
//                                if control.isRefreshing{
//                                    //停止下拉更新
//                                    control.endRefreshing()
//                                }
//                            }
                               /* 抓到資料後重刷table view */
                               self.tableView.reloadData()
                           }
                       }
                   }
               } else {
                   print(error!.localizedDescription)
               }
           }
       }
    
    // MARK: - Navigation
    @IBAction func deleteWarn(_ sender: UIButton) {
        let point : CGPoint = sender.convert(.zero, to: tableView)
        print(tableView.contentSize, point)
        if let indexPath = tableView.indexPathForRow(at: point){

            let pieceWarn = msgWarns[indexPath.row]
            var requestParam = [String: Any]()
            requestParam["action"] = "warnDelete"
            requestParam["id"] = pieceWarn.id
            executeTask(url_server!, requestParam, completionHandler: { (data, response, error) in
                    if error == nil {
                        if data != nil {
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        self.msgWarns.remove(at: indexPath.row)
                                        self.imageList.remove(at: indexPath.row)
                                        
                                        DispatchQueue.main.async {
                                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? WarnDetailViewController
        if let row = tableView.indexPathForSelectedRow?.row{
            controller?.warn = msgWarns[row]
            for i in 0...imageList.count {
                if imageList[i].userId == msgWarns[row].userId {
                    controller?.image = imageList[i].image
                    break
                }
            }
            imageList.removeAll()
        }
    }
    
    

}
