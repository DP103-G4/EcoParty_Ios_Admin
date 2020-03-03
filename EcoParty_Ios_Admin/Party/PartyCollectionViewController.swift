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
    var height:CGFloat = 300.0
    
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        //        layout!.headerReferenceSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height)
        
        
        
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    
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
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "partyDetailHeader", for: indexPath) as! PartyCollectionReusableView
        
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
        return headerView
    }
    
    @IBAction func passButton(_ sender: Any) {
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
                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
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
    @IBAction func outButton(_ sender: Any) {
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
                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
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
}
