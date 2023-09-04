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
        
        viewItem.backgroundColor = .titleGray
        lblTitle.setTheme("", size: 14)
        lblSubtitle.setTheme("", font: .bold, size: 20)
        viewItem.layer.cornerRadius = 5
    }

    func setData(_ data:SubscribeModel, _subscription_Id: Int) {
        lblTitle.text = data.name
        lblSubtitle.text = data.description
        if data.id == _subscription_Id {
            lblTitle.textColor = UIColor.appYellow
            lblSubtitle.textColor = UIColor.white
            viewItem.backgroundColor = UIColor.primaryBlue
        } else {
            lblTitle.textColor = UIColor.titleBlack
            lblSubtitle.textColor = UIColor.titleBlack
            viewItem.backgroundColor = UIColor.titleGray
        }
        
    }
    
}
