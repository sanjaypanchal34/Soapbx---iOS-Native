//
//  SettingItemCell.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit

class SettingItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgLeftArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.setTheme("")
        imgLeftArrow.image = UIImage(named: "ic_rightArrow")
    }
    
    func setData(_ object: SettingModel) {
        lblTitle.text = object.title
    }
    
}
