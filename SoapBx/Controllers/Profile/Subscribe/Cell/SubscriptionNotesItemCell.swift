//
//  SubscriptionNotesItemCell.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit

class SubscriptionNotesItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblFree: UILabel!
    @IBOutlet private weak var imgFree: UIImageView!
    @IBOutlet private weak var viewFreeBG: UIView!
    @IBOutlet private weak var lblPremium: UILabel!
    @IBOutlet private weak var imgPremium: UIImageView!
    @IBOutlet private weak var viewPremiumBG: UIView!
    
    @IBOutlet private weak var viewDivider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setTheme("",size: 14)
        lblFree.setTheme("",size: 14)
        viewFreeBG.backgroundColor = .clear
        imgFree.isHidden = true
        lblPremium.setTheme("",size: 14)
        imgPremium.isHidden = true
        viewPremiumBG.backgroundColor = .clear
        viewDivider.backgroundColor = .titleGrey
        viewFreeBG.backgroundColor = .primaryBlue
        viewPremiumBG.backgroundColor = .primaryBlue
    }
    
    func setData(_ data:SubscribeNotesModel, isFreemiumSelected:Bool, isLastIndex: Bool) {
        lblTitle.text = data.title
        if data.canSymbol {
            imgFree.isHidden = false
            imgPremium.isHidden = false
            lblFree.isHidden = true
            lblPremium.isHidden = true
            imgFree.image = UIImage(named: data.freemium == "y" ? "done_icon" : "cross_icon")?.withRenderingMode(.alwaysTemplate)
            imgPremium.image = UIImage(named: data.premium == "y" ? "done_icon" : "cross_icon")?.withRenderingMode(.alwaysTemplate)
            imgFree.tintColor = isFreemiumSelected ? .white : .titleBlack
            imgPremium.tintColor = isFreemiumSelected ? .titleBlack : .white
            
        } else {
            imgFree.isHidden = true
            imgPremium.isHidden = true
            lblFree.isHidden = false
            lblPremium.isHidden = false
            lblFree.text = data.freemium
            lblPremium.text = data.premium
            lblFree.textColor = isFreemiumSelected ? .white : .titleBlack
            lblPremium.textColor = isFreemiumSelected ? .titleBlack : .white
        }
        
        viewFreeBG.isHidden = !isFreemiumSelected
        viewPremiumBG.isHidden = isFreemiumSelected
        
        if isLastIndex {
            viewFreeBG.clipsToBounds = true
            viewFreeBG.layer.cornerRadius = 5
            viewFreeBG.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            viewPremiumBG.clipsToBounds = true
            viewPremiumBG.layer.cornerRadius = 5
            viewPremiumBG.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        else {
            viewFreeBG.layer.cornerRadius = 0
            viewPremiumBG.layer.cornerRadius = 0
        }
    }
}
