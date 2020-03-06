//
//  WarnViewController.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/24.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class WarnViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet var containerView: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
            containerView[0].isHidden = false
            containerView[1].isHidden = true
        createGesture()

        }
    
    func createGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(changeSegment))
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(changeSegment))
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @IBAction func changeSegment(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .left  {
            containerView[1].isHidden = false
            containerView[0].isHidden = true
            segment.selectedSegmentIndex = 1
            
        } else if sender.direction == .right {
           containerView[0].isHidden = false
           containerView[1].isHidden = true
            segment.selectedSegmentIndex = 0

        }
        
    }
    @IBAction func changeView(_ sender: UISegmentedControl) {
        containerView.forEach{ (count:UIView) in
            count.isHidden = true
        }
        containerView[sender.selectedSegmentIndex].isHidden = false
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

