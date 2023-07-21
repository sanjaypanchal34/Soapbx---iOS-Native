//
//  SubscriptionNotesHeaderCell.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit

class SubscriptionNotesHeaderCell: AppTableViewCell {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblFree: UILabel!
    @IBOutlet private weak var viewFreeBG: UIView!
    @IBOutlet private weak var lblPremium: UILabel!
    @IBOutlet private weak var viewPremiumBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        lblTitle.setTheme("",size: 14)
        lblFree.setTheme("",font: .bold,size: 16)
        lblPremium.setTheme("",font: .bold,size: 16)
        viewFreeBG.backgroundColor = .primaryBlue
        viewPremiumBG.backgroundColor = .primaryBlue
        
        viewFreeBG.clipsToBounds = true
        viewFreeBG.layer.cornerRadius = 5
        viewFreeBG.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        viewPremiumBG.clipsToBounds = true
        viewPremiumBG.layer.cornerRadius = 5
        viewPremiumBG.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setData(_ data:SubscribeNotesModel, isFreemiumSelected: Bool) {
        lblTitle.text = ""
        lblFree.text = data.freemium
        lblPremium.text = data.premium
        lblFree.textColor = isFreemiumSelected ? .appYellow : .titleBlack
        lblPremium.textColor = isFreemiumSelected ? .titleBlack : .appYellow
        
        viewFreeBG.backgroundColor = isFreemiumSelected ? .primaryBlue : .white
        viewPremiumBG.backgroundColor = isFreemiumSelected ? .white : .primaryBlue
    }
}
