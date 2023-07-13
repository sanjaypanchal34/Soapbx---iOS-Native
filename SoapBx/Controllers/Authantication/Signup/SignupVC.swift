//
//  SignupVC.swift
//  SoapBx
//
//  Created by Mac on 05/07/23.
//

import UIKit
import OTLContaner

class SignupVC: UIViewController {
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubtitle: UILabel!
    
    @IBOutlet private weak var txtFirstName: OTLTextField!
    @IBOutlet private weak var txtLastName: OTLTextField!
    @IBOutlet private weak var txtPhoneNo: OTLTextField!
    @IBOutlet private weak var txtEmail: OTLTextField!
    @IBOutlet private weak var txtPassword: OTLTextField!
    @IBOutlet private weak var txtConfPassword: OTLTextField!
    @IBOutlet private weak var txtLocation: OTLTextField!
    
    @IBOutlet private weak var viewVerifyEmail: UIControl!
    @IBOutlet private weak var imgVerifyEmail: UIImageView!
    @IBOutlet private weak var lblVerifyEmail: UILabel!
    @IBOutlet private weak var viewVerifyPhone: UIControl!
    @IBOutlet private weak var imgVerifyPhone: UIImageView!
    @IBOutlet private weak var lblVerifyPhone: UILabel!
    
    @IBOutlet private weak var imgIAccept: UIImageView!
    @IBOutlet private weak var lblIAccept: UILabel!
    
    @IBOutlet private weak var btnSignUp: UIButton!
    
    @IBOutlet private weak var lblAlreadyAMamber: UILabel!
    @IBOutlet private weak var btnSignIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        lblTitle.setTheme("Sign up for Soapbx",
                          font: .bold,
                          size: 38)
        lblSubtitle.setTheme("Enter our details below",
                             color: .titleGrey)
        
        txtFirstName.setTheme(placeholder: "First name",
                          leftIcon: UIImage(named: "ic_user"))
        txtLastName.setTheme(placeholder: "Last name",
                             leftIcon: UIImage(named: "ic_user"))
        txtPhoneNo.setTheme(placeholder: "Phone Number",
                          leftIcon: UIImage(named: "ic_phone"))
        txtEmail.setTheme(placeholder: "Email",
                          leftIcon: UIImage(named: "ic_email"))
        txtPassword.setTheme(placeholder: "Password",
                             leftIcon: UIImage(named: "ic_lock"))
        txtConfPassword.setTheme(placeholder: "Confirm Password",
                             leftIcon: UIImage(named: "ic_lock"))
        txtLocation.setTheme(placeholder: "Location",
                             leftIcon: UIImage(named: "ic_location_grey"))
        
        lblVerifyEmail.setTheme("Verify via Email")
        lblVerifyPhone.setTheme("Verify via Number")
        for view in [viewVerifyEmail, viewVerifyPhone] {
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        lblIAccept.setTheme("I Accept")
        btnSignUp.appButton("Sign up")
        
        lblAlreadyAMamber.setTheme("Already a member?")
        btnSignIn.setTheme("Sign in now", color: .primaryBlue)
    }

    //Action
    @IBAction private func click_back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func click_verifyVia(_ sender: UIControl) {
        if sender == viewVerifyEmail {
            imgVerifyEmail.image = UIImage(named: "ic_radioSelected")
            imgVerifyPhone.image = UIImage(named: "ic_radio")
        } else { // selected
            imgVerifyEmail.image = UIImage(named: "ic_radio")
            imgVerifyPhone.image = UIImage(named: "ic_radioSelected")
        }
    }
    
    @IBAction private func click_SignUp() {
        let vc = HomeVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func click_IAccept() {
        if imgIAccept.image == nil {
            imgIAccept.image = UIImage(named: "ic_unCheckbox")
            imgIAccept.backgroundColor = .clear
            imgIAccept.layer.cornerRadius = 0
        } else { // selected
            imgIAccept.image = nil
            imgIAccept.backgroundColor = .primaryBlue
            imgIAccept.layer.cornerRadius = 2
        }
    }
    
    @IBAction private func click_SignIn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
