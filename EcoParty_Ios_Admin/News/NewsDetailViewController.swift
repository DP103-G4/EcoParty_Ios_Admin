//
//  NewsDetailViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/22.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

protocol NewsDetailViewControllerDelegate {
}

class NewsDetailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet var errorLabel: [UILabel]!
    @IBOutlet weak var newsTitleTextField: UITextField!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var imageButton: UIButton!
    var delegate: NewsDetailViewControllerDelegate?
    var changePhoto = false
    
    var imageUpload: UIImage?
    let url_server = URL(string: common_url + "NewsServlet")
    var news:News?
    var newsImage:Data?
    
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
    
}
extension NewsDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        changePhoto = true
        errorLabel[0].text = ""
        let image = info[.originalImage] as? UIImage
        imageUpload = image
        imageButton.setImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}


