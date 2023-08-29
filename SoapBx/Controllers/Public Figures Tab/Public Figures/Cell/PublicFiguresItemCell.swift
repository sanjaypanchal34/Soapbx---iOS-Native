//
//  PublicFiguresItemCell.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner

protocol PublicFiguresItemDelegate {
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectActionButton object: PostUser)
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectAction2Button object: PostUser)
}
extension PublicFiguresItemDelegate {
    func publicFigures(_ cell: PublicFiguresItemCell, didSelectAction2Button object: PostUser) {}
}

class PublicFiguresItemCell: AppTableViewCell {
    
    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var imgLocation: UIImageView!
    @IBOutlet private weak var btnAction: OTLTextButton!
    @IBOutlet private weak var btnRemove: OTLTextButton!
    @IBOutlet private weak var imgHorizantalDot: UIImageView!
    
    private var delegate:PublicFiguresItemDelegate?
    private var user: PostUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.cornerRadius = 10
        viewMain.layer.borderColor = UIColor.titleGray.cgColor
        viewMain.layer.borderWidth = 0.5
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.image = UIImage(named: "Logo")
        
        lblProfileName.setTheme("Todd Young",font: .semibold, lines: 1)
        lblLocation.setTheme("185 Dirksen Sente Office Building", size: 14, lines: 3)
        
        btnAction.backgroundColor = .titleRed
        btnAction.layer.cornerRadius = 5
        btnAction.setTheme(LocalStrings.C_FOLLOW.rawValue.addLocalizableString(), color: .white)
        btnAction.layer.borderWidth = 1
        btnAction.layer.borderColor = UIColor.titleRed.cgColor
        
        btnRemove.isHidden = true
        btnRemove.layer.cornerRadius = 5
        btnRemove.layer.borderWidth = 1
        btnRemove.layer.borderColor = UIColor.primaryBlue.cgColor
        btnRemove.setTheme(LocalStrings.C_REMOVE.rawValue.addLocalizableString())
        
        imgHorizantalDot.isHidden = true
    }
    
    func hideButtonsForOtherUser() {
        btnRemove.isHidden = true
        btnAction.isHidden = true
        imgHorizantalDot.isHidden = true
    }
    
    func setPoliticianData(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        self.user = user
        self.delegate = delegate
        self.indexPath = indexPath
        updateDate(user)
        imgHorizantalDot.isHidden = true
    }
    
    func updateDate(_ user: PostUser) {
        updateUserData(user)
        if user.statusPoli == 1 {
            btnAction.text = LocalStrings.C_FOLLOWING.rawValue.addLocalizableString()
            btnAction.backgroundColor = .green
            btnAction.layer.borderColor = UIColor.green.cgColor
        } else {
            btnAction.text = LocalStrings.C_FOLLOW.rawValue.addLocalizableString()
            btnAction.backgroundColor = .titleRed
            btnAction.layer.borderColor = UIColor.titleRed.cgColor
        }
    }
    
    private func updateUserData(_ user: PostUser){
        imgHorizantalDot.isHidden = true
        self.user = user
        imgProfile.setImage(user.profilePhotoURL)
        lblProfileName.text = user.name
        lblLocation.text = getValueOrDefult(user.location, defaultValue: "N/A")
        imgLocation.isHidden = lblLocation.text?.isEmptyString ?? true
        btnAction.textColor = .white
        
        imgHorizantalDot.isHidden = true
    }
    
    func setDataFollowers(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        updateUserData(user)
        self.indexPath = indexPath
        self.delegate = delegate
        
        
        btnAction.isHidden = false
        btnAction.text = LocalStrings.C_FOLLOW.rawValue.addLocalizableString()
        btnAction.textColor = .white
        btnAction.backgroundColor = .primaryBlue
        btnAction.layer.borderColor = UIColor.primaryBlue.cgColor
        
        if user.statusUser == 1 {
            btnAction.text = LocalStrings.C_REQUESTED.rawValue.addLocalizableString()
            btnAction.backgroundColor = .primaryBlue
        } else if user.statusUser == 2 {
            btnAction.isHidden = true
        } else {
            btnAction.text = LocalStrings.C_FOLLOW.rawValue.addLocalizableString()
            btnAction.backgroundColor = .primaryBlue
            btnAction.layer.borderColor = UIColor.primaryBlue.cgColor
        }
        
        btnRemove.isHidden = false
        btnRemove.text = LocalStrings.C_REMOVE.rawValue.addLocalizableString()
        btnRemove.textColor = .titleBlack
        btnRemove.backgroundColor = .white
        btnRemove.layer.borderColor = UIColor.primaryBlue.cgColor
    }
    func setDataFollowing(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        updateUserData(user)
        self.indexPath = indexPath
        self.delegate = delegate
        
        btnAction.isHidden = false
        btnAction.text = LocalStrings.C_UNFOLLOW.rawValue.addLocalizableString()
        btnAction.textColor = .white
        btnAction.backgroundColor = .titleRed
        btnAction.layer.borderColor = UIColor.titleRed.cgColor
        
        btnRemove.isHidden = true
        imgHorizantalDot.isHidden = true
    }
    
    func setDataPoliticians(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        updateUserData(user)
        self.indexPath = indexPath
        self.delegate = delegate
        
        btnAction.isHidden = false
        btnAction.text = LocalStrings.C_UNFOLLOW.rawValue.addLocalizableString()
        btnAction.textColor = .white
        btnAction.backgroundColor = .titleRed
        btnAction.layer.borderColor = UIColor.titleRed.cgColor
        
        btnRemove.isHidden = true
        imgHorizantalDot.isHidden = true
    }
    
    func setDataUnblock(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        updateUserData(user)
        self.indexPath = indexPath
        self.delegate = delegate
        
        btnAction.isHidden = false
        btnAction.text = LocalStrings.C_UNBLOCK.rawValue.addLocalizableString()
        btnAction.textColor = .white
        btnAction.backgroundColor = .primaryBlue
        btnAction.layer.borderColor = UIColor.primaryBlue.cgColor
        
        btnRemove.isHidden = true
        imgHorizantalDot.isHidden = true
    }
    
    func setDataUnfollow(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        updateUserData(user)
        self.indexPath = indexPath
        self.delegate = delegate
        
        btnAction.isHidden = false
        btnAction.text = LocalStrings.C_FOLLOW.rawValue.addLocalizableString()
        btnAction.textColor = .white
        btnAction.backgroundColor = .titleRed
        btnAction.layer.borderColor = UIColor.titleRed.cgColor
        
        btnRemove.isHidden = true
        imgHorizantalDot.isHidden = true
    }
    
    func setDataFriend(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        updateUserData(user)
        self.indexPath = indexPath
        self.delegate = delegate
        
        btnAction.isHidden = false
        btnAction.text = LocalStrings.C_CONFIRM.rawValue.addLocalizableString()
        btnAction.textColor = .white
        btnAction.backgroundColor = .green
        btnAction.layer.borderColor = UIColor.green.cgColor
        
        btnRemove.isHidden = false
        btnRemove.text = LocalStrings.C_DELETE.rawValue.addLocalizableString()
        btnRemove.textColor = .white
        btnRemove.backgroundColor = .titleRed
        btnRemove.layer.borderColor = UIColor.titleRed.cgColor
        
        imgHorizantalDot.isHidden = true
    }
    
    func setDataMyFriend(_ user: PostUser, indexPath: IndexPath , delegate:PublicFiguresItemDelegate) {
        updateUserData(user)
        self.indexPath = indexPath
        self.delegate = delegate
        
        btnAction.text = ""
        btnAction.textColor = .white
        btnAction.isHidden = true
        btnAction.backgroundColor = .titleRed
        btnAction.layer.borderColor = UIColor.titleRed.cgColor
        
        btnRemove.isHidden = true
        
        imgHorizantalDot.isHidden = false
        
    }
    
    @IBAction private func click_btnAction() {
        if authUser?.loginType == .userLogin {
            if let user = user {
                delegate?.publicFigures(self, didSelectActionButton: user)
            }
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnAction2() {
        if authUser?.loginType == .userLogin {
            if let user = user {
                delegate?.publicFigures(self, didSelectAction2Button: user)
            }
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
}
