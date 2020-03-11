//
//  NewsDetailViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/22.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit



class NewsDetailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet var errorLabel: [UILabel]!
    @IBOutlet weak var newsTitleTextField: UITextField!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    var changePhoto = false
    
    var imageUpload: UIImage?
    let url_server = URL(string: common_url + "NewsServlet")
    var news:News?
    var newsImage:Data?
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTextView.delegate = self
        newsTitleTextField.delegate = self
        imageButton.imageView?.contentMode = .scaleAspectFill
        
        if let news = news,let newsImage = newsImage{
            newsTitleTextField.text = news.title
            newsTextView.text = news.content
            imageButton.setImage(UIImage(data: newsImage), for: .normal)
            changePhoto = true;
            
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if let originalText = newsTitleTextField.text, let _ = Range(range, in: originalText) {
            errorLabel[1].text = ""
        }
        return true
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool{
        if text.isEmpty == true && range.location == 0 && range.length == 1 {
            textViewLabel.isHidden = false
                }
        if text.isEmpty == false {
            textViewLabel.isHidden = true
                }
        if let originalText = newsTextView.text, let _ = Range(range, in: originalText) {
            errorLabel[2].text = ""
        }
        return true
    }
    
    @IBAction func showImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     
     */
    @IBAction func saveButton(_ sender: Any) {
        let newsTitle = newsTitleTextField.text ?? ""
        let newsConternt = newsTextView.text ?? ""
        guard newsTitle.isEmpty == false, newsConternt.isEmpty == false, changePhoto == true else {
            changePhoto == false ? (errorLabel[0].text = "＊需加入圖片") : (errorLabel[0].text = "")
            newsTitle.isEmpty == true ? (errorLabel[1].text = "＊需加入標題") : (errorLabel[1].text = "")
            newsConternt.isEmpty == true ? (errorLabel[2].text = "＊需加入內容") : (errorLabel[2].text = "")
            return
        }
        errorLabel[1].text = ""
        errorLabel[2].text = ""
        var requestParam = [String: String]()
        newsImage == nil ? (requestParam["action"] = "newsInsert") : (requestParam["action"] = "newsUpdate")
        let newsUpload = News(id:news?.id, title: newsTitle, content: newsConternt)
        
        requestParam["news"] = try! String(data: JSONEncoder().encode(newsUpload), encoding: .utf8)
        if self.imageUpload != nil {
            requestParam["imageBase64"] = self.imageUpload!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(self.url_server!, requestParam) { (data, response, error) in
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
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func newsContent(_ sender: UIButton) {
        textViewLabel.isHidden = true
        newsTitleTextField.text = "宣導：武漢肺炎(2019新型冠狀病毒)相關事項"
        newsTextView.text = "掌握政府各項疫情資訊，隨時關注衛生福利部臉書及網站，就可獲知最新正確疫情資訊。大家若在群組或社群媒體看到未經確認的消息，也請不要再轉傳，避免造成不必要的恐慌。\n\n蔡總統也呼籲民眾正常生活，不須恐慌：目前口罩與病床數皆充足，若身體健康未有異狀，請大家繼續正常生活即可，毋須囤積口罩，也不須過度恐慌。做好健康自主管理，勤洗手，注意體溫。\n\n出入人多的公眾場合，記得要勤洗手，注意自己的體溫狀況，若有不適，一定要記得配戴口罩，並且撥打1922，政府會有專人協助就醫。"
            
    }
}
extension NewsDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        changePhoto = true
        errorLabel[0].text = ""
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageUpload = image
            imageButton.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}


