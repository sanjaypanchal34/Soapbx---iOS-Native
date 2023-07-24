//
//  NotificationListItemCell.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit

class NotificationListItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setTheme("Lorem Ipsum is simply dummy text of the printing and typesetting industry. ", size: 14)
        lblTime.setTheme("Apr 11 2023 @ 10:13 PM", size: 11)
    }

}
