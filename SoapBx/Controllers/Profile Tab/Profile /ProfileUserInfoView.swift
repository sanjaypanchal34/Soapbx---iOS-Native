//
//  ProfileUserInfoView.swift
//  SoapBx
//
//  Created by Mac on 11/07/23.
//

import UIKit
import OTLContaner
protocol ProfileUserInfoDelegate{
    func profileUser(follow user:PostUser)
    func profileUser(block user:PostUser)
    func profileUserMessage(message user: PostUser)
}

class ProfileUserInfoView: UIView {
    
    @IBOutlet private weak var imgCover:UIImageView!
    @IBOutlet private weak var imgProfile:UIImageView!
    
    @IBOutlet private weak var btnEditProfile:UIButton!
    @IBOutlet private weak var btnDeleteAccunt:UIButton!
    
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var imgLocationIcon:UIImageView!
    @IBOutlet private weak var lblLocation:UILabel!
    
    @IBOutlet private weak var viewMessageFollowBackButtons:UIView!
    @IBOutlet private weak var btnMessage:OTLTextButton!
    @IBOutlet private weak var btnFollow:OTLTextButton!
    @IBOutlet private weak var btnBlock:OTLTextButton!
    
    @IBOutlet private weak var btnFollowers:OTLActionTitle!
    @IBOutlet private weak var btnFollowing:OTLActionTitle!
    @IBOutlet private weak var btnPoliticians:OTLActionTitle!
    
    @IBOutlet private weak var btnVoiceToday:OTLPTButton!
    
    var screenType = ProfileScreenType.profileTab
    var userObj: PostUser?
    var delegate:ProfileUserInfoDelegate?
    
    public func setupUIWithData(screenType: ProfileScreenType = .profileTab, delegate: ProfileUserInfoDelegate) {
        self.screenType = screenType
        self.delegate = delegate
        imgCover.image = UIImage(named: "")
        imgCover.backgroundColor = .lightGrey
        imgCover.contentMode = .scaleAspectFill
        imgProfile.image = UIImage(named: "")
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        
        btnEditProfile.setTitle(LocalStrings.PROFILE_EDIT.rawValue.addLocalizableString(), for: .normal)
        btnEditProfile.setTitleColor(.primaryBlue, for: .normal)
        btnDeleteAccunt.setTitle(LocalStrings.PROFILE_DELETE.rawValue.addLocalizableString(), for: .normal)
        btnDeleteAccunt.setTitleColor(.titleRed, for: .normal)
        
        lblProfileName.setTheme("", font: .bold,size: 20, lines: 1)
        lblLocation.setTheme("", size: 14, lines: 3)
        lblLocation.textAlignment = .center
        
        viewMessageFollowBackButtons.backgroundColor = .clear
        btnMessage.setTheme(LocalStrings.PROFILE_MESSAGE.rawValue.addLocalizableString(), color: .white, font: .bold, size: 14,background: .primaryBlue)
        btnMessage.layer.cornerRadius = 5
        btnFollow.setTheme(LocalStrings.C_FOLLOW.rawValue.addLocalizableString(), color: .white, font: .bold, size: 14,background: .titleRed)
        btnFollow.layer.cornerRadius = 5
        btnBlock.setTheme(LocalStrings.C_BLOCK.rawValue.addLocalizableString(), color: .white, font: .bold, size: 14,background: .primaryBlue)
        btnBlock.layer.cornerRadius = 5
        
        
        btnFollowers.lblTitle.setTheme("0", color: .primaryBlue, font: .bold, size: 18)
        btnFollowers.lblDescription.setTheme(LocalStrings.F_FOLLOW.rawValue.addLocalizableString(), size: 14)
        btnFollowing.lblTitle.setTheme("0", color: .primaryBlue, font: .bold, size: 18)
        btnFollowing.lblDescription.setTheme(LocalStrings.F_FOLLOWING.rawValue.addLocalizableString(), size: 14)
        btnPoliticians.lblTitle.setTheme("0", color: .primaryBlue, font: .bold, size: 18)
        btnPoliticians.lblDescription.setTheme(LocalStrings.F_POLITICIAN.rawValue.addLocalizableString(), size: 14)
        
        
        btnVoiceToday.imageView?.image = UIImage(named: "")
        btnVoiceToday.imageView?.contentMode = .scaleAspectFill
        btnVoiceToday.imageView?.layer.cornerRadius = (btnVoiceToday.imageView?.frame.height ?? 0)/2
        btnVoiceToday.title?.setTheme(LocalStrings.PROFILE_VOCIE.rawValue.addLocalizableString(), color: .lightGrey)
        btnVoiceToday.layer.cornerRadius = btnVoiceToday.frame.height/2
        btnVoiceToday.layer.borderWidth = 1
        btnVoiceToday.layer.borderColor = UIColor.lightGrey.cgColor
        
        if screenType == .profileTab {
            viewMessageFollowBackButtons.isHidden = true
            btnVoiceToday.isHidden = false
            btnEditProfile.isHidden = false
            btnDeleteAccunt.isHidden = false
        } else {
            viewMessageFollowBackButtons.isHidden = false
            btnVoiceToday.isHidden = true
            btnEditProfile.isHidden = true
            btnDeleteAccunt.isHidden = true
            
        }
    }
    
    func updateProfileData(_ user: PostUser) {
        self.userObj = user
        
        imgCover.setImage(user.coverPhotoURL)
        imgProfile.setImage(user.profilePhotoURL)
        lblProfileName.text = user.name
        lblLocation.text = getValueOrDefult(user.location, defaultValue: "N/A")
        
        btnFollowers.lblTitle.text = "\(user.followers ?? 0)"
        btnFollowing.lblTitle.text = "\(user.following ?? 0)"
        btnPoliticians.lblTitle.text = "\(user.politician ?? 0)"
        if user.statusUser == 1 {
            btnFollow.text = LocalStrings.C_REQUESTED.rawValue.addLocalizableString()
            btnFollow.backgroundColor = .primaryBlue
        } else if user.statusUser == 2 {
            btnFollow.text = LocalStrings.C_UNFOLLOW.rawValue.addLocalizableString()
            btnFollow.backgroundColor = .primaryBlue
        } else {
            btnFollow.text = LocalStrings.C_FOLLOW.rawValue.addLocalizableString()
            btnFollow.backgroundColor = .titleRed
        }
        btnVoiceToday.imageView?.setImage(user.profilePhotoURL)
    }
    
    func updateOtherUserProfileData(_ userObj: PostUser) {
        updateProfileData(userObj)
    }
    
    func updateSelfProfileData(_ userObj: UserAuthModel) {
        imgCover.setImage(userObj.cover_photo_url)
        imgProfile.setImage(userObj.profile_photo_url)
        lblProfileName.text = userObj.name
        lblLocation.text = getValueOrDefult(userObj.location, defaultValue: "N/A")
        
        btnFollowers.lblTitle.text = "\(userObj.followers)"
        btnFollowing.lblTitle.text = "\(userObj.following)"
        btnPoliticians.lblTitle.text = "\(userObj.politician)"
        btnVoiceToday.imageView?.setImage(userObj.cover_photo_url)
    }
    
    @IBAction private func click_editProfile() {
//        rootViewController.pushViewController(ProfileCoverVC(), animated: true)
        rootViewController.pushViewController(EditProfileVC(), animated: true)
    }
    
    @IBAction private func click_deleteAccount() {
        showAlert(message: LocalStrings.A_DELETE_ACCOUNT.rawValue.addLocalizableString(),
                  buttons: [
                    OTLAlertModel(title: LocalStrings.C_CANCEL.rawValue.addLocalizableString(), id: 0),
                    OTLAlertModel(title: LocalStrings.C_DELETE.rawValue.addLocalizableString(), id: 1, style: .destructive),
                  ]) { alert in
                      if alert.id == 1 {
                          mackRootView(LoginVC())
                      }
                  }
    }
    
    @IBAction private func click_btnFollowers(){
        if let user = userObj {
            let vc = FollowFollowingVC()
            vc.navigate(user, tab: .followers, screenType: screenType)
            rootViewController.pushViewController(vc, animated: true)
        }
    }
    @IBAction private func click_btnFollowing(){
        if let user = userObj {
            let vc = FollowFollowingVC()
            vc.navigate(user, tab: .following, screenType: screenType)
            rootViewController.pushViewController(vc, animated: true)
        }
    }
    @IBAction private func click_btnPoliticians(){
        if let user = userObj {
            let vc = FollowFollowingVC()
            vc.navigate(user, tab: .politicians, screenType: screenType)
            rootViewController.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction private func click_btnMessage() {
        if authUser?.loginType == .userLogin {
            delegate?.profileUserMessage(message: userObj!)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnFollow() {
        if authUser?.loginType == .userLogin {
            delegate?.profileUser(follow: userObj!)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnBlock() {
        if authUser?.loginType == .userLogin {
            delegate?.profileUser(block: userObj!)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_createPost() {
        let vc = CreatePostVC()
        rootViewController.pushViewController(vc, animated: true)
    }
}
