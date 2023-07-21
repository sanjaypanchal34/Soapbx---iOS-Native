//
//  MenuItemCell.swift
//  SoapBx
//
//  Created by Mac on 17/07/23.
//

import UIKit

class MenuItemCell: AppTableViewCell {

    @IBOutlet private weak var imgIcon:UIImageView!
    @IBOutlet private weak var lblTitle:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.backgroundColor = .primaryBlue.withAlphaComponent(0.2)
        viewMain.layer.cornerRadius = 5
        lblTitle.setTheme("", font: .medium , size: 18)
    }

    func setData(_ object: MenuModel) {
        imgIcon.image = UIImage(named: object.icon)
        lblTitle.text = object.title
        lblTitle.textColor = object.isSelected ? .primaryBlue : .titleBlack
        viewMain.backgroundColor = object.isSelected ? .primaryBlue.withAlphaComponent(0.2) : .white
    }
    
}
