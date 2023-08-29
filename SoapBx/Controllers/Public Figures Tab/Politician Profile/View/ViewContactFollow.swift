//
//  ViewContactFollow.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 15/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner

class ViewContactFollow: UIView {
    
    @IBOutlet private weak var lblFollow: UILabel!
    
    @IBOutlet private weak var btnFacebook: OTLImageButton!
    @IBOutlet private weak var btnTwitter: OTLImageButton!
    @IBOutlet private weak var btnYoutube: OTLImageButton!
    
    @IBOutlet private weak var btnWebsite: OTLTextButton!
    @IBOutlet private weak var btnContactForm: OTLTextButton!
    
    @IBOutlet private weak var lblContact: UILabel!
    @IBOutlet private weak var lblLocation: UILabel!
    
    @IBOutlet private weak var btnPhoneCall: OTLPTButton!
    @IBOutlet private weak var btnPrint: OTLPTButton!
    
private var user: PostUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 10
        
        lblFollow.setTheme(LocalStrings.C_FOLLOW.rawValue.addLocalizableString(), font: .medium)
        btnFacebook.image = UIImage(named: "facebook_icon")
        btnFacebook.height = btnFacebook.frame.height
        btnTwitter.image = UIImage(named: "twitter_icon")
        btnTwitter.height = btnTwitter.frame.height
        btnYoutube.image = UIImage(named: "youtube_icon")
        btnYoutube.height = btnYoutube.frame.height
        
        btnWebsite.setTheme(LocalStrings.CONTACT_WEBSITE.rawValue.addLocalizableString(), color: .white,background: .primaryBlue)
        btnWebsite.layer.cornerRadius = 8
        
        btnContactForm.setTheme(LocalStrings.CONTACT_FORM.rawValue.addLocalizableString(), color: .white,background: .primaryBlue)
        btnContactForm.layer.cornerRadius = 8
        
        lblContact.setTheme(LocalStrings.CONTACT.rawValue.addLocalizableString(), font: .medium)
        lblLocation.setTheme("", size: 14)
        
        btnPhoneCall.title?.setTheme("")
        btnPhoneCall.imageView?.image = UIImage(named: "phone_icon")?.withRenderingMode(.alwaysTemplate)
        btnPhoneCall.imageView?.tintColor = .primaryBlue
        
        btnPrint.title?.setTheme("--- ---")
        btnPrint.imageView?.image = UIImage(named: "fax_icon")?.withRenderingMode(.alwaysTemplate)
        btnPrint.imageView?.tintColor = .primaryBlue
    }
    
    func setData(_ user: PostUser){
        self.user = user
        lblLocation.text = getValueOrDefult(user.location, defaultValue: "N/A")
        btnPhoneCall.title?.text = getValueOrDefult(user.phoneNumber, defaultValue: "--- --- ----")
    }
    
    @IBAction private func click_Facebook() {
        if let url = URL(string: "https://m.facebook.com/\(user.facebookAccount ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                SoapBx.showToast(message: LocalStrings.ALERT_FACEBOOK.rawValue.addLocalizableString())
            }
        }
    }
    @IBAction private func click_Twitter() {
        if let url = URL(string: "https://twitter.com/\(user.twitterAccount ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                SoapBx.showToast(message: LocalStrings.ALERT_TWITTER.rawValue.addLocalizableString())
            }
        }
    }
    @IBAction private func click_Youtube() {
        if let url = URL(string: "https://www.youtube.com/user/\(user.youtubeAccount ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                SoapBx.showToast(message: LocalStrings.ALERT_YOUTUBE.rawValue.addLocalizableString())
            }
        }
    }
    
    @IBAction private func click_Website() {
        if let url = URL(string: user.url ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                SoapBx.showToast(message: LocalStrings.ALERT_WEBSITE.rawValue.addLocalizableString())
            }
        }
    }
    
    @IBAction private func click_ContactForm() {
        if let url = URL(string: user.contactForm ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                SoapBx.showToast(message: LocalStrings.ALERT_CONTACT_FORM.rawValue.addLocalizableString())
            }
        }
    }
    
    
    
    @IBAction private func click_PhoneCall() {
        if let url = URL(string: "tel:\(user.phoneNumber ?? "")") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    @IBAction private func click_Print() {
        
    }
}
