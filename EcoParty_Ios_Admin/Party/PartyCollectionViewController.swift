//
//  PartyCollectionViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/22.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

private let reuseIdentifier = "partyCell"


class PartyCollectionViewController: UICollectionViewController {
    let fullScreenSize = UIScreen.main.bounds.size
    var reviewImageArray = [Data]()
    var partyImageArray = [Party.imageList]()
    var party:Party?
    var reviewImgId = [Review]()
    var partyImage:Data?
    let url_server = URL(string: common_url + "ReviewImgServlet")
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getAllByParty"
        requestParam["partyId"] = party?.id
        //        requestParam["imageSize"] = view.frame.width
        showPartyDetial(requestParam)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let width = (collectionView.bounds.width - 1 * 2) 
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: width, height: width)
        //        設為.zero如此cell的尺寸才會依據itemSize否則將從autoLayout的條件計算cell的尺寸
        layout?.estimatedItemSize = .zero
        
        //設定header高度
        //        height: UIView.layoutFittingExpandedSize.height
        
        
    }
    
    func showPartyDetial(_ requestParam:[String:Any]){
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Review].self, from: data!) {
                        self.reviewImgId = result
                        DispatchQueue.main.async { self.collectionView.reloadData()}
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewImgId.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PartyCollectionViewCell
        
        // 尚未取得圖片，另外開啟task請求
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["id"] = reviewImgId[indexPath.row].id
        // 圖片寬度為tableViewCell的1/4，ImageView的寬度也建議在storyboard加上比例設定的constraint
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "pig")
                }
                DispatchQueue.main.async { cell.reviewImageView.image = image }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "partyDetailHeader", for: indexPath) as! PartyCollectionReusableView
        headerView.partyImage.image = UIImage(data: self.partyImage!)
        headerView.partyNameLabel.text = party?.name
        headerView.partyOwnerLabel.text = party?.ownerName
        headerView.partyContentLabel.text = party?.content
        headerView.partyAddressLabel.text = party?.address
        let formatter = DateFormatter()
        formatter.locale=Locale(identifier: "zh_Hant_Tw")
        formatter.dateFormat = "MM月dd日 E HH:mm"
        let timeText = formatter.string(from: party!.startTime)
        headerView.partyTimeLabel.text = timeText
        headerView.partyCountLabel.text = "\(party!.countUpperLimit)"
        
        
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let height = headerView.heightStackView.bounds.size.height
        print("stack高度：\(height)")
        layout!.headerReferenceSize = CGSize(width: collectionView.frame.width, height: height)
        
        return headerView
    }
    
    func passParty(){
        var requestParam = [String: Any]()
        requestParam["action"] = "changePartyState"
        requestParam["id"] = party!.id
        requestParam["state"] = 1
        let url_partyServer = URL(string: common_url + "PartyServlet")
        
        executeTask(url_partyServer!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    let inform = Inform(userId: self.party!.ownerId, partyId: self.party!.id, content: "審核通過")
                                    self.insertInform(inform: inform)
                                    
                                } else {
                                    let controller = UIAlertController(title: "error", message: "update fail", preferredStyle: .alert)
                                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(controller, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    func outParty(){
        var requestParam = [String: Any]()
        requestParam["action"] = "changePartyState"
        requestParam["id"] = party!.id
        requestParam["state"] = 5
        let url_partyServer = URL(string: common_url + "PartyServlet")
        executeTask(url_partyServer!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    let inform = Inform(userId: self.party!.ownerId, partyId: -2, content: "審核失敗")
                                    self.insertInform(inform: inform)
                                } else {
                                    let controller = UIAlertController(title: "error", message: "update fail", preferredStyle: .alert)
                                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(controller, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
    func insertInform(inform:Inform){
        var requestParam = [String: Any]()
        requestParam["action"] = "informInsert"
        requestParam["inform"] = try! String(data: JSONEncoder().encode(inform), encoding: .utf8)
        let url_informServer = URL(string: common_url + "InformServlet")
        executeTask(url_informServer!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    let controller = UIAlertController(title: "error", message: "insert inform fail", preferredStyle: .alert)
                                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(controller, animated: true, completion: nil)
                                    
                                }
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    @IBAction func passButton(_ sender: Any) {
        let controller = UIAlertController(title: "注意", message: "你確定要通過『\(party!.name)』的活動審核嗎？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
            self.passParty()
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func outButton(_ sender: Any) {
        let controller = UIAlertController(title: "注意", message: "你確定要退回『\(party!.name)』的活動審核嗎？", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "確定", style: .default) { (_) in
                   self.outParty()
               }
               controller.addAction(okAction)
               let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
               controller.addAction(cancelAction)
               present(controller, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}
