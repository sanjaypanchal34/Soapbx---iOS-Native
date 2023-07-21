//
//  ProfileCoverVC.swift
//  SoapBx
//
//  Created by Mac on 06/07/23.
//

import UIKit
import OTLContaner

class ProfileCoverVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    
    @IBOutlet private weak var viewAddCover: OTLDashedView!
    @IBOutlet private weak var lblAddCover: UILabel!
    
    @IBOutlet private weak var btnProfile: UIButton!
    
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblNotes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme("Set Profile Picture and Cover Photo",
                          font: .bold,
                          size: 40)
        
        lblAddCover.setTheme("Add cover phote\n(Optional)", color: .titleGrey, font: .regular, size: 12)
        
        btnProfile.layer.cornerRadius = btnProfile.frame.height/2
        btnProfile.emptyTitle()
        
        viewAddCover.cornerRadius = 10
        viewAddCover.dashColor = UIColor.titleRed
        viewAddCover.dashWidth = 2
        viewAddCover.dashLength = 4
        viewAddCover.betweenDashesSpace = 4
        
        btnNext.appButton("Next")
        
        lblDescription.setTheme("Add a profile picture so that you and your friend can identifv each other", color: .titleBlack)
        lblNotes.setTheme("*Cover photo is optional and can be added later.", color: .titleGrey)
    }
    
    //Actions
    @IBAction private func click_btnNext() {
        let vc = VerificationCodeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

