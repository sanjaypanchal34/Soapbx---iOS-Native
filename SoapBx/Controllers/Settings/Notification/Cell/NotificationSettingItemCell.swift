//
//  NotificationSettingItemCell.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit

class NotificationSettingItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var switchTogale:UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setTheme("")
        switchTogale.onTintColor = .primaryBlue
        switchTogale.tintColor = .titleGrey
    }

    func setData(_ object: NotificationSettingModel) {
        lblTitle.text = object.title
        switchTogale.isOn = object.isSelected
    }
    
}
