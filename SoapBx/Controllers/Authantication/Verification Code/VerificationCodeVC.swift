//
//  VerificationCodeVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import OTLContaner

class VerificationCodeVC: UIViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    
    @IBOutlet private weak var otpField: OTLOTPView!
    
    @IBOutlet private weak var btnNext: OTLTextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    //MARK: - Setup view
    private func setupUI() {
        lblTitle.setTheme("Verification code",
                          font: .bold,
                          size: 40)
        
        let attributesMain = NSMutableAttributedString(string: "Please type the verification code sent to your email test@yopmail.com")
        let rang = attributesMain.mutableString.range(of: "test@yopmail.com")
        attributesMain.addAttributes([.foregroundColor: UIColor.primaryBlue, .font: AppFont.medium.font(size: 16)], range: rang)
        
        lblDescription.attributedText = attributesMain
        
        otpField.setOTPTheme()
        
        btnNext.appButton("Resend")
    }
    
    // action
    @IBAction private func click_resend(){
        let vc = YouInterestedVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
