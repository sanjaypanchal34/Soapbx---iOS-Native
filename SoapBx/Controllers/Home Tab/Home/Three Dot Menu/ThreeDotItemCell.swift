//
//  ThreeDotItemCell.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
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
