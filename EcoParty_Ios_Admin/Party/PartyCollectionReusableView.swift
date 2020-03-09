//
//  PartyCollectionReusableView.swift
//  EcoParty_Ios_Admin
//
//  Created by 梁嘉峻 on 2020/2/27.
//  Copyright © 2020 梁嘉峻. All rights reserved.
//

import UIKit

class PartyCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var heightStackView: UIStackView!
    @IBOutlet weak var partyNameLabel: UILabel!
    @IBOutlet weak var partyOwnerLabel: UILabel!
    @IBOutlet weak var partyAddressLabel: UILabel!
    @IBOutlet weak var partyTimeLabel: UILabel!
    @IBOutlet weak var partyCountLabel: UILabel!
    @IBOutlet weak var partyContentLabel: UILabel!
    @IBOutlet weak var partyImage: UIImageView!
}
