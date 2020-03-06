//
//  MsgWarnTableViewCell.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/3/4.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class WarnTableViewCell: UITableViewCell {

    @IBOutlet weak var msgWarnImageView: UIImageView!
    @IBOutlet weak var msgWarnUserLabel: UILabel!
    @IBOutlet weak var msgWarnContentLabel: UILabel!
    @IBOutlet weak var pieceWarnImageView: UIImageView!
    @IBOutlet weak var pieceWarnUserLabel: UILabel!
    @IBOutlet weak var pieceWarnContentLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
