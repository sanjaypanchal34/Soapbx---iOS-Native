//
//  SearchItemCell.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner

protocol SearchItemDelegate {
    func searchItem(_ cell: SearchItemCell, didSelectAction object: PostUser)
}

class SearchItemCell: AppTableViewCell {
    
    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var btnCancel:OTLImageButton!

    private var delegate:SearchItemDelegate?
    private var object: PostUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.backgroundColor = .clear
        imgProfile.image = UIImage(named: "Logo")
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        lblProfileName.setTheme("Todd Young", font: .semibold, lines: 1)
        btnCancel.tintColor = .titleGray
    }

    func setDataForSearchTab() {
        btnCancel.isHidden = true
    }
    
    func setDataForPublicSearch(_ object: PostUser, isFromSearch: Bool = false, delegate:SearchItemDelegate) {
        self.delegate = delegate
        self.object = object
        imgProfile.setImage(object.profilePhotoURL)
        lblProfileName.text = object.name
        btnCancel.isUserInteractionEnabled = !isFromSearch
        btnCancel.isHidden = isFromSearch
        btnCancel.image = UIImage(named:"ic_lightCross")?.withRenderingMode(.alwaysTemplate)
        btnCancel.tintColor = .titleGray
        btnCancel.height = 18
    }
    
    func setDataPolition(_ object: PostUser, isSelected: Bool = false) {
        imgProfile.setImage(object.profilePhotoURL)
        lblProfileName.text = object.name
        btnCancel.isUserInteractionEnabled = false
        btnCancel.isHidden = false
        btnCancel.image = UIImage(named: isSelected ? "ic_radioSelected" : "ic_radio")?.withRenderingMode(.alwaysTemplate)
        btnCancel.tintColor = .primaryBlue
        btnCancel.height = 20
    }
    
    @IBAction private func click_actionButton() {
        if let object = object {
            delegate?.searchItem(self, didSelectAction: object)
        }
    }
}
