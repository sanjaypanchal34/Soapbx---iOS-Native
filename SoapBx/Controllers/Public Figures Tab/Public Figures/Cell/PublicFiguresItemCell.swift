//
//  PublicFiguresItemCell.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit

class PublicFiguresItemCell: AppTableViewCell {

    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var btnAction: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.cornerRadius = 10
        viewMain.layer.borderColor = UIColor.titleGrey.cgColor
        viewMain.layer.borderWidth = 0.5
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.image = UIImage(named: "Logo")
        
        lblProfileName.setTheme("Todd Young",font: .semibold)
        lblLocation.setTheme("185 Dirksen Sente Office Building", size: 14, lines: 3)
        
        btnAction.backgroundColor = .titleRed
        btnAction.layer.cornerRadius = 5
        btnAction.setTitle("Follow", for: .normal)
        btnAction.setTitleColor(.white, for: .normal)
        btnAction.layer.borderWidth = 1
        btnAction.layer.borderColor = UIColor.titleRed.cgColor
    }

    func setDataFollowers() {
        btnAction.setTitle("Follow", for: .normal)
        btnAction.backgroundColor = .primaryBlue
        btnAction.layer.borderColor = UIColor.primaryBlue.cgColor
    }
        func setDataFollowing() {
            btnAction.setTitle("Follow", for: .normal)
            btnAction.backgroundColor = .titleRed
            btnAction.layer.borderColor = UIColor.titleRed.cgColor
        }
            func setDataPoliticians() {
                btnAction.setTitle("Unfollow", for: .normal)
                btnAction.backgroundColor = .clear
                btnAction.setTitleColor(.black, for: .normal)
                btnAction.layer.borderColor = UIColor.primaryBlue.cgColor
            }
    
}
