//
//  SearchItemCell.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit

class SearchItemCell: AppTableViewCell {
    
    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var btnCancel:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.backgroundColor = .clear
        imgProfile.image = UIImage(named: "Logo")
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        lblProfileName.setTheme("Todd Young", font: .semibold)
    }

    func setDataForSearchTab() {
        btnCancel.isHidden = true
    }
    
    func setDataForPublicSearch() {
        btnCancel.isHidden = false
    }
}
