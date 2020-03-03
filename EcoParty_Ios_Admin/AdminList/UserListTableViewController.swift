//
//  UserListTableViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by mac on 2020/2/29.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    var users = [User]()
    let url_server = URL(string: common_url + "UserServlet")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAddRefreshControl()
    }
    
    //下拉更新
    func tableViewAddRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllUsers), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllUsers()
    }
    
    
    @objc func showAllUsers(){
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil{
                    print("input: \(String(data: data! , encoding: .utf8)!)")

                    if let result = try? JSONDecoder().decode([User].self, from: data!){
                        self.users = result
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl{
                                if control.isRefreshing{
                                    //停止下拉更新
                                    control.endRefreshing()
                                }
                            }
                            //抓到資料後重刷tableView
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    

        let cellID = "userCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UserCell
        let user = users[indexPath.row]

        
        // 未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = user.id
      
    // 寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width / 4
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil{
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "no_Image")
                }
                DispatchQueue.main.async {
                    cell.userImg.image = image
                }
                } else {
                    print(error!.localizedDescription)
                }
            }
            
        cell.userAccount.text = user.account
        cell.userName.text = user.name
            return cell
        }
    


//左滑刪除資料＝停權
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "停權"){(action, view , bool) in
            // 尚未刪除server資料
            var requestParam = [String: Any]()
            requestParam["action"] = "userDelete"
            requestParam["userId"] = self.users[indexPath.row].id
            executeTask(self.url_server!, requestParam, completionHandler: {
                (data, response, error) in
                if error == nil {
                    if data != nil{
                        if let result = String(data: data!, encoding: .utf8){
                            if let count = Int(result){
                                if count != 0 {
                                    self.users.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
        delete.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        //false:滑到底不會觸發動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
