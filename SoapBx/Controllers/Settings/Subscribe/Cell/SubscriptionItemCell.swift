//
//  SubscriptionItemCell.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit

class SubscriptionItemCell: AppTableViewCell {

    @IBOutlet private weak var viewItem: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewItem.backgroundColor = .titleGrey
        lblTitle.setTheme("", size: 14)
        lblSubtitle.setTheme("", font: .bold, size: 20)
        viewItem.layer.cornerRadius = 5
    }

    func setData(_ data:SubscribeModel) {
        lblTitle.text = data.title
        lblSubtitle.text = data.subtitle
        lblTitle.textColor = data.isSelected ? UIColor.appYellow : UIColor.titleBlack
        lblSubtitle.textColor = data.isSelected ? UIColor.white : UIColor.titleBlack
        viewItem.backgroundColor = data.isSelected ? UIColor.primaryBlue : UIColor.titleGrey
    }
    
}
