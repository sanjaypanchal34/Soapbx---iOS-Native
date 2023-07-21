//
//  CommentItemCell.swift
//  SoapBx
//
//  Created by Mac on 13/07/23.
//

import UIKit
import OTLContaner

class CommentItemCell: AppTableViewCell {

    @IBOutlet private weak var imgProfile:UIImageView!
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var lblComment:UILabel!
    @IBOutlet private weak var btnReport:OTLTextButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        imgProfile.image = UIImage(named: "profileOne")
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.contentMode = .scaleAspectFill
        lblProfileName.setTheme("Robert Watson",size: 14)
        lblComment.setTheme("Comment",size: 12)
        btnReport.setTheme("Report",color: .titleRed,size: 11)
    }
    
    func setData() {
        btnReport.setTheme("Report",color: .titleRed,size: 11)
    }
}
