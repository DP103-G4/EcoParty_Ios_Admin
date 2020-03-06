//
//  NewsTableViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/21.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    var newsies = [News]()
    var imageList = [News.imageList]()
    
    let url_server = URL(string: common_url + "NewsServlet")
    
    override func viewWillAppear(_ animated: Bool) {
        var requestParam = [String: String]()
        requestParam["action"] = "getAllNews"
        showNews(requestParam)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "最新消息"
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 尚未刪除server資料
        var requestParam = [String: Any]()
        requestParam["action"] = "newsDelete"
        requestParam["id"] = self.newsies[indexPath.row].id
        executeTask(self.url_server!, requestParam
            , completionHandler: { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    self.newsies.remove(at: indexPath.row)
                                    self.imageList.remove(at: indexPath.row)
                                    
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .automatic)
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
    // MARK: - Table view data source
    
    func showNews(_ requestParam:[String:String]){
        executeTask(url_server!, requestParam) { (data, response, error) in
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(format)
            
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? decoder.decode([News].self, from: data!) {
                        self.newsies = result
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        return news.count
        return newsies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        let news = newsies[indexPath.row]
        cell.newsTitleLabel.text = news.title
        let formatter = DateFormatter()
        formatter.locale=Locale(identifier: "zh_Hant_Tw")
        formatter.dateFormat = "MM月dd日 E HH:mm"
        let timeText = formatter.string(from: news.time!)
        cell.newsTimeLabel.text = timeText
        cell.newsContentLabel.text = news.content
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = news.id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                    self.imageList.append(News.imageList(image: data!, id: news.id!))
                }
                if image == nil {
                    image = UIImage(named: "pig")
                }
                DispatchQueue.main.async { cell.newsImageView.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        return cell
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
        let controller = segue.destination as? NewsDetailViewController
        if let row = tableView.indexPathForSelectedRow?.row{
            controller?.news = newsies[row]
            for i in 0...imageList.count {
                if imageList[i].id == newsies[row].id {
                    controller?.newsImage = imageList[i].image
                    break
                }
            }
            imageList.removeAll()
        }
    }
}
