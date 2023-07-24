//
//  ProfileUserInfoView.swift
//  SoapBx
//
//  Created by Mac on 11/07/23.
//

import UIKit
import OTLContaner

class ProfileUserInfoView: UIView {
    
    @IBOutlet private weak var imgCover:UIImageView!
    @IBOutlet private weak var imgProfile:UIImageView!
    
    @IBOutlet private weak var btnEditProfile:UIButton!
    @IBOutlet private weak var btnDeleteAccunt:UIButton!
    
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var lblLocation:UILabel!
    
    @IBOutlet private weak var viewMessageFollowBackButtons:UIView!
    @IBOutlet private weak var btnMessage:UIButton!
    @IBOutlet private weak var btnFollow:UIButton!
    @IBOutlet private weak var btnBlock:UIButton!
    
    @IBOutlet private weak var btnFollowers:OTLActionTitle!
    @IBOutlet private weak var btnFollowing:OTLActionTitle!
    @IBOutlet private weak var btnPoliticians:OTLActionTitle!
    
    @IBOutlet private weak var btnVoiceToday:OTLPTButton!
    
    var screenType = ProfileScreenType.profileTab
    
    public func setupUIWithData(screenType: ProfileScreenType = .profileTab) {
        self.screenType = screenType
        imgCover.image = UIImage(named: "")
        imgCover.backgroundColor = .lightGrey
        imgProfile.image = UIImage(named: "profileOne")
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        
        btnEditProfile.setTitle("Edit Profile", for: .normal)
        btnEditProfile.setTitleColor(.primaryBlue, for: .normal)
        btnDeleteAccunt.setTitle("Delete Account", for: .normal)
        btnDeleteAccunt.setTitleColor(.titleRed, for: .normal)
        
        lblProfileName.setTheme("Robert Watson", font: .bold,size: 20)
        lblLocation.setTheme("185 Dirksen Sente Office Building", size: 14)
        
        viewMessageFollowBackButtons.backgroundColor = .clear
        btnMessage.setTheme("Message", color: .white, font: .bold, size: 14,backgound: .primaryBlue)
        btnMessage.layer.cornerRadius = 5
        btnFollow.setTheme("Follow", color: .white, font: .bold, size: 14,backgound: .titleRed)
        btnFollow.layer.cornerRadius = 5
        btnBlock.setTheme("Block", color: .white, font: .bold, size: 14,backgound: .primaryBlue)
        btnBlock.layer.cornerRadius = 5
        
        
        btnFollowers.lblTitle.setTheme("0", color: .primaryBlue, font: .bold, size: 18)
        btnFollowers.lblDescription.setTheme("Followers", size: 14)
        btnFollowing.lblTitle.setTheme("0", color: .primaryBlue, font: .bold, size: 18)
        btnFollowing.lblDescription.setTheme("Following", size: 14)
        btnPoliticians.lblTitle.setTheme("0", color: .primaryBlue, font: .bold, size: 18)
        btnPoliticians.lblDescription.setTheme("Politicians", size: 14)
        
        
        btnVoiceToday.imageView?.image = UIImage(named: "profileOne")
        btnVoiceToday.imageView?.contentMode = .scaleAspectFill
        btnVoiceToday.imageView?.layer.cornerRadius = (btnVoiceToday.imageView?.frame.height ?? 0)/2
        btnVoiceToday.title?.setTheme("What do you want to voice today?", color: .lightGrey)
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
    
    @IBAction private func click_editProfile() {
        rootViewController.pushViewController(EditProfileVC(), animated: true)
    }
    
    @IBAction private func click_deleteAccount() {
        showAlert(message: "Are you sure you want to delete this account?",
                  buttons: [
                    OTLAlertModel(title: "Cancel", id: 0),
                    OTLAlertModel(title: "Delete", id: 1, style: .destructive),
                  ]) { alert in
                      if alert.id == 1 {
                          mackRootView(LoginVC())
                      }
                  }
    }
    
    @IBAction private func click_btnFollowers(){
        let vc = FollowFolloingVC()
        rootViewController.pushViewController(vc, animated: true)
    }
    @IBAction private func click_btnFollowing(){
        let vc = FollowFolloingVC()
        rootViewController.pushViewController(vc, animated: true)
    }
    @IBAction private func click_btnPoliticians(){
        let vc = FollowFolloingVC()
        rootViewController.pushViewController(vc, animated: true)
    }
    
    @IBAction private func click_btnMessage() {
        let vc = ChatVC()
        rootViewController.pushViewController(vc, animated: true)
    }
    
    @IBAction private func click_btnFollow() {
//        let vc = ChatVC()
//        rootViewController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func click_btnBlock() {
//        let vc = ChatVC()
//        rootViewController?.pushViewController(vc, animated: true)
    }
}
