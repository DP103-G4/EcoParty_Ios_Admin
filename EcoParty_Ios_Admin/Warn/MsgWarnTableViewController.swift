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
        var requestParam = [String:String]()
        requestParam["action"] = "getAll"
        showMsgWarn(requestParam)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    

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
    
     func showMsgWarn(_ requestParam:[String:String]){
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

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
