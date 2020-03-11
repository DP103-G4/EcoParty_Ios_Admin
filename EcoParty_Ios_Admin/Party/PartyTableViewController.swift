//
//  PartyTableViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/21.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class PartyTableViewController: UITableViewController  {

    var partys = [Party]()
    var imageList = [Party.imageList]()
    let url_server = URL(string: common_url + "PartyServlet")

    override func viewWillAppear(_ animated: Bool) {
        var requestParam = [String: String]()
        requestParam["action"] = "getPartyCheck"
        showParty(requestParam)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "審核活動"
   
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return partys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partyCell", for: indexPath)
        as! PartyTableViewCell
        let party = partys[indexPath.row]
        cell.partyNameLabel.layer.cornerRadius = 10
        cell.partyNameLabel.text = " \(party.name) "
        
        //尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getCoverImg"
        requestParam["id"] = party.id
        //設定圖片寬度
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                    self.imageList.append(Party.imageList(image: data!, id: party.id))
                }
                if image == nil {
                    image = UIImage(named: "pig")
                }
                DispatchQueue.main.async { cell.partyImageView.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        return cell
    }
    
    func showParty(_ requestParam:[String:String]){
        executeTask(url_server!, requestParam) { (data, response, error) in
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(format)
            
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? decoder.decode([Party].self, from: data!) {
                        self.partys = result
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? PartyCollectionViewController
        if let row = tableView.indexPathForSelectedRow?.row{
            controller?.party = partys[row]
            
            for i in 0...imageList.count {
                if imageList[i].id == partys[row].id {
                    controller?.partyImage = imageList[i].image
                    break
                }
            }
            imageList.removeAll()
        }
        
    }
    

    func showPartys(_ requestParam:[String:Any]){
        executeTask(url_server!, requestParam) { (data, response, error) in
            
        }

    }
}
