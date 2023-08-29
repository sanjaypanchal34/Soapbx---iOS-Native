//
//  CommentItemCell.swift
//  SoapBx
//
//  Created by Mac on 13/07/23.
//

import UIKit
import OTLContaner

protocol CommentItemDelegate {
    func commentItem(_ cell: CommentItemCell, didSelectReport object: CommentModel)
}

class CommentItemCell: AppTableViewCell {

    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var lblComment:UILabel!
    @IBOutlet private weak var btnReport:OTLTextButton!
    
    private var object:CommentModel?
    private var delegate:CommentItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        imgProfile.image = UIImage(named: "profileOne")
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.contentMode = .scaleAspectFill
        lblProfileName.setTheme("Robert Watson",size: 14, lines: 1)
        lblComment.setTheme(LocalStrings.COMMENT.rawValue.addLocalizableString(),size: 12)
        btnReport.setTheme(LocalStrings.REPORT_TITLE.rawValue.addLocalizableString(),color: .titleRed,size: 11)
    }
    
    func setData(_ object: CommentModel, indexPath: IndexPath, delegate:CommentItemDelegate) {
        self.object = object
        self.indexPath = indexPath
        self.delegate = delegate
        imgProfile.setImage(object.user?.profilePhotoURL)
        lblProfileName.text = object.user?.name
        lblComment.text = object.comment
        if object.user?.id == authUser?.user?.id {
            btnReport.isHidden = true
        } else {
            btnReport.isHidden = false
        }
    }
    
    @IBAction private func click_btnReport() {
        if let obj = object {
            delegate?.commentItem(self, didSelectReport: obj)
        }
    }
}
