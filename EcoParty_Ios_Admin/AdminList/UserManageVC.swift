//
//  UserManageVC.swift
//  EcoParty_Ios_Admin
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class UserManageVC: UIViewController{
    
//    @IBOutlet weak var searchUser: UISearchBar!
    
    @IBOutlet var containerViews: [UIView]!
    
//    //原始
//    var users = [User]()
//    //搜尋後
//    var searchUsers = [User]()
//    //不顯示搜尋後資料
//    var search = false
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//        let text = searchBar.text ?? ""
//        //不搜尋時 不顯示
//        if text == "" {
//            search = false
//        } else {
//            searchUsers = users.filter({ (user) -> Bool in
//                return user.account!.uppercased().contains(text.uppercased()) || user.name!.uppercased().contains(text.uppercased())
//            })
//            search = true
//        }
////        UserListTableViewController.reload
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViews[0].isHidden = false
        containerViews[1].isHidden = true
    }
    
    @IBAction func changeUser(_ sender: UISegmentedControl) {
        for containerView in containerViews {
            containerView.isHidden = true
        }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    
}

//extension UserManageVC: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if search { //若搜尋，顯示搜尋後資料
//            return searchUsers.count
//        } else {
//            return users.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var user : User
//        if search { //若搜尋，顯示搜尋後資料
//            user = searchUsers[indexPath.row]
//        } else {
//            user = users[indexPath.row]
//        }
//
//        let cellId = "userCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
//        cell.userAccount.text = user.account
//        cell.userName.text = user.name
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let userListTVC = self.storyboard?.instantiateViewController(withIdentifier: "userListTableViewController") as! UserListTableViewController
//        let user = users[indexPath.row]
//        userListTVC.users = [user]
//        self.navigationController?.pushViewController(userListTVC, animated: true)
//
//    }
//
//
//}
