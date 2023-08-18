//
//  PoliticianProfileVC.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

protocol PoliticianProfileDelegate {
    func politicianProfile(didUpadate user: PostUser, at indexPath: IndexPath)
}

class PoliticianProfileVC: UIViewController {

    @IBOutlet private weak var viewHeader:OTLHeader!
    
    @IBOutlet private weak var imgCover:UIImageView!
    @IBOutlet private weak var imgProfile:UIImageView!
    
    @IBOutlet private weak var lblProfileName:UILabel!
    @IBOutlet private weak var imgLocationIcon:UIImageView!
    @IBOutlet private weak var lblLocation:UILabel!
    
    @IBOutlet private weak var btnFollow:OTLTextButton!
    
    @IBOutlet private weak var btnElectedIn:OTLActionTitle!
    @IBOutlet private weak var btnVoters:OTLActionTitle!
    @IBOutlet private weak var btnParty:OTLActionTitle!
    
    @IBOutlet private weak var viewInfo:UIView!
    @IBOutlet private weak var viewBasicDetails:ViewBasicDetails!
    @IBOutlet private weak var viewPoliticianScorecard:ViewPoliticianScorecard!
    @IBOutlet private weak var viewContactFollow:ViewContactFollow!
    
    private let vmProfile = ProfileViewModel()
    private var indexPath: IndexPath?
    private var delegate: PoliticianProfileDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getProfile()
        if self.vmProfile.userObj == nil {
            navigationController?.dismiss(animated: true)
            navigationController?.popViewController(animated: true)
        }
        
    }
    func navigation(_ user: PostUser, indexPath: IndexPath, delegate: PoliticianProfileDelegate) {
        self.vmProfile.userObj = user
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    // setup methdos
    private func setupUI() {
        viewHeader.lblTitle.setHeader("")
        
        imgCover.image = UIImage(named: "")
        imgCover.backgroundColor = .lightGrey
        imgCover.contentMode = .scaleAspectFill
        imgProfile.image = UIImage(named: "")
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        
        lblProfileName.setTheme("", font: .bold,size: 20)
        lblLocation.setTheme("", size: 14)
        
        btnFollow.setTheme("Follow", color: .white, font: .bold, size: 14, background: .titleRed)
        btnFollow.layer.cornerRadius = 5
        
        btnElectedIn.lblTitle.setTheme("--", color: .primaryBlue, font: .bold, size: 18)
        btnElectedIn.lblDescription.setTheme("Elected in", size: 14)
                btnVoters.lblTitle.setTheme("--", color: .primaryBlue, font: .bold, size: 18)
                btnVoters.lblDescription.setTheme("Voters", size: 14)
        btnParty.lblTitle.setTheme("--", color: .primaryBlue, font: .bold, size: 18)
        btnParty.lblDescription.setTheme("Party", size: 14)
        
        viewInfo.backgroundColor = .lightGrey
        
        setData()
    }

    private func setData() {
        viewHeader.lblTitle.text = vmProfile.userObj?.name
        imgCover.setImage(vmProfile.userObj?.coverPhotoURL)
        imgProfile.setImage(vmProfile.userObj?.profilePhotoURL)
        lblProfileName.text = vmProfile.userObj?.name
        lblLocation.text = getValueOrDefult(vmProfile.userObj?.location, defaultValue: "N/A")
        setFollowUnfollow()
        
        btnElectedIn.lblTitle.text = getValueOrDefult(vmProfile.userObj?.electedIn, defaultValue: "--")
        btnVoters.lblTitle.text = getValueOrDefult(vmProfile.userObj?.voters, defaultValue: "--")
        btnParty.lblTitle.text = getValueOrDefult(vmProfile.userObj?.party, defaultValue: "--")
        
        viewBasicDetails.setData(vmProfile.userObj!)
        viewPoliticianScorecard.setData(vmProfile.userObj!)
        viewContactFollow.setData(vmProfile.userObj!)
    }
    
    private func setFollowUnfollow() {
        if (vmProfile.userObj?.statusPoli ?? 0) == 1 {
            btnFollow.text = "Following"
            btnFollow.backgroundColor = .green
        } else {
            btnFollow.text = "Follow"
            btnFollow.backgroundColor = .titleRed
        }
    }
    
    @IBAction private func click_follow() {
        if vmProfile.userObj?.statusPoli == 1 {
            unfollow()
        }
        else {
            follow()
        }
    }
    
    
    //API Call
    private func getProfile() {
        showLoader()
        vmProfile.getOtherProfile { result in
            hideLoader()
            self.setData()
        }
    }
    
    private func follow() {
        showLoader()
        vmProfile.follow(user: vmProfile.userObj?.id ?? 0, user: vmProfile.userObj?.roleID ?? 3) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.vmProfile.userObj?.statusPoli = 1
                self.setFollowUnfollow()
                self.delegate?.politicianProfile(didUpadate: self.vmProfile.userObj!, at: self.indexPath!)
            }
        }
    }
    
    private func unfollow() {
        showLoader()
        vmProfile.unfollow(user: vmProfile.userObj?.id ?? 0) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.vmProfile.userObj?.statusPoli = 0
                self.setFollowUnfollow()
                self.delegate?.politicianProfile(didUpadate: self.vmProfile.userObj!, at: self.indexPath!)
            }
        }
    }
}
