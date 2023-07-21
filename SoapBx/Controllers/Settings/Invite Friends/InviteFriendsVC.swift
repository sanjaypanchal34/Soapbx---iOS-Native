//
//  InviteFriendsVC.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit
import OTLContaner

class InviteFriendsVC: UIViewController {

    @IBOutlet private weak var headerView:OTLHeader!
    
    @IBOutlet private weak var viewBody:UIView!
    
    @IBOutlet private weak var viewRefreCode:UIView!
    @IBOutlet private weak var lblReferCode:UILabel!
    @IBOutlet private weak var btnCopy:OTLImageButton!
    
    @IBOutlet private weak var btnInvite:OTLTextButton!
    
    private var strReferCode = "X9ml5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        headerView.lblTitle.setHeader("Invite Friends")
        
        viewRefreCode.layer.cornerRadius = 10
        viewRefreCode.layer.borderColor = UIColor.lightGrey.cgColor
        viewRefreCode.layer.borderWidth = 1
        lblReferCode.setTheme(strReferCode)
        
        btnInvite.appButton("Invite")
    }
    
    
    @IBAction private func click_btnCopy() {
        UIPasteboard.general.string = strReferCode
    }
    
    @IBAction private func click_btnInvite() {
        // text to share
        let text = "Play Store/App Store \(strReferCode)"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
