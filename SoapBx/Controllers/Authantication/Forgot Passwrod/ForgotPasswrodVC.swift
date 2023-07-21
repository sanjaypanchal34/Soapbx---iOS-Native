//
//  ForgotPasswrodVC.swift
//  SoapBx
//
//  Created by Mac on 06/07/23.
//

import UIKit
import OTLContaner

class ForgotPasswrodVC: UIViewController {
    
    @IBOutlet private weak var headerView: OTLHeader!
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubtitle: UILabel!
    
    @IBOutlet private weak var txtEmail: OTLTextField!
    
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme("Forgot password?",
                          font: .bold,
                          size: 38)
        lblSubtitle.setTheme("Please enter vour email / phone number to reset your account password",
                             color: .titleGrey)
        
        txtEmail.setTheme(placeholder: "Email / Phone Number",
                          leftIcon: UIImage(named: "ic_email"))
        
        btnNext.appButton("Next")

    }
    
    
    //Actions
   
    @IBAction private func click_Next() {
        
    }
    
}
