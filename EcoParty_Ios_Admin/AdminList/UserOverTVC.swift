//
//  UserOverTVC.swift
//  EcoParty_Ios_Admin
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class UserOverTVC: UITableViewController, UISearchBarDelegate {

  
    
    @IBOutlet weak var userOverSearchBar: UISearchBar!
    
    let url_server = URL(string: common_url + "UserServlet")
       //原始
       var users = [User]()
       //搜尋後
       var searchUsers = [User]()
       //搜尋後是否顯示
       var search = false
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
           let text = userOverSearchBar.text ?? ""
           //不搜尋 顯示原始資料
           if text == "" {
               search = false
           } else {
               searchUsers = users.filter({ (user) -> Bool in
                   return user.account!.uppercased().contains(text.uppercased())  || user.name!.uppercased().contains(text.uppercased())
               })
               search = true
           }
           tableView.reloadData()
       }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           userOverSearchBar.resignFirstResponder()
           
       }
       
    
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
           let requestParam = ["action" : "getUserOver"]
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
        if search {
            return searchUsers.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var userOverList: User
        if search {
            userOverList = searchUsers[indexPath.row]
        } else {
            userOverList = users[indexPath.row]
        }
        
        let cellID = "userCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UserCell
//        let user = users[indexPath.row]

        
        // 未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = userOverList.id
        
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
            
        cell.userAccount.text = userOverList.account
        cell.userName.text = userOverList.name
            return cell
    }
  
    //左滑復權，資料進一般名單
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let back = UIContextualAction(style: .normal, title: "復權"){(action, view , bool) in
            var requestParam = [String: Any]()
            requestParam["action"] = "userBack"
            requestParam["id"] = self.users[indexPath.row].id
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
        back.backgroundColor = .systemGreen
        let swipeActions = UISwipeActionsConfiguration(actions: [back])
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
