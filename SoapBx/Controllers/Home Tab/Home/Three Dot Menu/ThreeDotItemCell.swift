//
//  ThreeDotItemCell.swift
//  SoapBx
//
//  Created by Mac on 16/07/23.
//

import UIKit

class ThreeDotItemCell: AppTableViewCell {

    @IBOutlet private weak var imgIcon:UIImageView!
    @IBOutlet private weak var lblTitle:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.setTheme("")
    }

    func setData(_ object:ThreeDotItemModel) {
        imgIcon.image = UIImage(named: object.icon)
        lblTitle.text = object.title.title
    }
}
