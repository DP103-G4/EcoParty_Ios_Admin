//
//  UserManageVC.swift
//  EcoParty_Ios_Admin
//
//  Created by mac on 2020/3/3.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class UserManageVC: UIViewController {

    @IBOutlet var containerViews: [UIView]!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerViews[0].isHidden = false
        containerViews[1].isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeUser(_ sender: UISegmentedControl) {
        for containerView in containerViews {
            containerView.isHidden = true
        }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
