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
    
    private var strReferCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        headerView.lblTitle.setHeader(LocalStrings.I_TITLE.rawValue.addLocalizableString())
        strReferCode = authUser?.user?.referral_code ?? ""
        
        
        viewRefreCode.layer.cornerRadius = 10
        viewRefreCode.layer.borderColor = UIColor.lightGrey.cgColor
        viewRefreCode.layer.borderWidth = 1
        lblReferCode.setTheme(strReferCode)
        btnCopy.image = UIImage(named: "ic_copy")
        btnCopy.height = 20
        btnCopy.addTarget(self, action: #selector(click_btnCopy), for: .touchUpInside)
        
        btnInvite.appButton(LocalStrings.I_BUTTON.rawValue.addLocalizableString())
        btnInvite.addTarget(self, action: #selector(click_btnInvite), for: .touchUpInside)
    }
    
    
    @IBAction private func click_btnCopy() {
        UIPasteboard.general.string = strReferCode
        showToast(message: "\(strReferCode) code is copied.")
    }
    
    @IBAction private func click_btnInvite() {
        // text to share
        let text = "Play Store/App Store \(strReferCode)"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ .airDrop, .postToFacebook, .message, .mail]
        navigationController?.present(activityViewController, animated: true, completion: nil)
    }
}
