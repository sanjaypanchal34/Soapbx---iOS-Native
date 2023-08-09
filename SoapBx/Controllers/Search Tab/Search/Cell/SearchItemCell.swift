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
        btnCancel.emptyTitle()
        btnCancel.tintColor = .titleGrey
    }

    func setDataForSearchTab() {
        btnCancel.isHidden = true
    }
    
    func setDataForPublicSearch() {
        btnCancel.isHidden = false
    }
    
    func setDataPolition(_ object: PostUser, isSelected: Bool = false) {
        imgProfile.setImage(object.profilePhotoURL)
        lblProfileName.text = object.name
        btnCancel.isUserInteractionEnabled = false
        btnCancel.isHidden = false
        btnCancel.setImage(UIImage(named: isSelected ? "ic_radioSelected" : "ic_radio")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCancel.tintColor = .primaryBlue
    }
}
