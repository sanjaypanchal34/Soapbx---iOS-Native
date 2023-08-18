//
//  SignupVC.swift
//  SoapBx
//
//  Created by Mac on 05/07/23.
//

import UIKit
import OTLContaner

class SignupVC: UIViewController {
    @IBOutlet private weak var btnBack: UIButton!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSubtitle: UILabel!
    
    @IBOutlet private weak var txtFirstName: OTLTextField!
    @IBOutlet private weak var txtLastName: OTLTextField!
    @IBOutlet private weak var txtPhoneNo: OTLCountryCode!
    @IBOutlet private weak var txtEmail: OTLTextField!
    @IBOutlet private weak var txtPassword: OTLPasswordField!
    @IBOutlet private weak var txtConfPassword: OTLPasswordField!
    @IBOutlet private weak var txtLocation: OTLTextField!
    
    @IBOutlet private weak var viewVerifyEmail: UIControl!
    @IBOutlet private weak var imgVerifyEmail: UIImageView!
    @IBOutlet private weak var lblVerifyEmail: UILabel!
    @IBOutlet private weak var viewVerifyPhone: UIControl!
    @IBOutlet private weak var imgVerifyPhone: UIImageView!
    @IBOutlet private weak var lblVerifyPhone: UILabel!
    
    @IBOutlet private weak var imgIAccept: UIImageView!
    @IBOutlet private weak var lblIAccept: UILabel!
    
    @IBOutlet private weak var btnSignUp: OTLTextButton!
    
    @IBOutlet private weak var lblAlreadyAMamber: UILabel!
    @IBOutlet private weak var btnSignIn: OTLTextButton!
    
    private var intVerifyType = 0
    private var vmObject = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        btnBack.emptyTitle()
        
        lblTitle.setTheme("Sign up for Soapbx",
                          font: .bold,
                          size: 38)
        lblSubtitle.setTheme("Enter our details below",
                             color: .titleGray)
        
        txtFirstName.setTheme(placeholder: "First name",
                          leftIcon: UIImage(named: "ic_user"))
        txtLastName.setTheme(placeholder: "Last name",
                             leftIcon: UIImage(named: "ic_user"))
        txtPhoneNo.setTheme(placeholder: "Phone Number",
                          leftIcon: UIImage(named: "ic_phone"))
        txtPhoneNo.keyboardType = .phonePad
        
        txtEmail.setTheme(placeholder: "Email",
                          leftIcon: UIImage(named: "ic_email"))
        txtEmail.keyboardType = .emailAddress
        
        txtPassword.setTheme(placeholder: "Password")
        txtConfPassword.setTheme(placeholder: "Confirm Password")
        txtLocation.setTheme(placeholder: "Location",
                             leftIcon: UIImage(named: "ic_location_grey"))
        txtLocation.delegate = self
        
        lblVerifyEmail.setTheme("Verify via Email", size: 14)
        lblVerifyPhone.setTheme("Verify via Number", size: 14)
        for view in [viewVerifyEmail, viewVerifyPhone] {
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        lblIAccept.setTheme("I Accept")
        btnSignUp.appButton("Sign up")
        
        lblAlreadyAMamber.setTheme("Already a member?")
        btnSignIn.setTheme("Sign in now",color: .primaryBlue, font: .medium, size: 16)
        
        click_verifyVia(viewVerifyEmail)
    }

    //Action
    @IBAction private func click_back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func click_verifyVia(_ sender: UIControl) {
        if sender == viewVerifyEmail {
            imgVerifyEmail.image = UIImage(named: "ic_radioSelected")
            imgVerifyPhone.image = UIImage(named: "ic_radio")
            intVerifyType = 0
        } else { // selected
            imgVerifyEmail.image = UIImage(named: "ic_radio")
            imgVerifyPhone.image = UIImage(named: "ic_radioSelected")
            intVerifyType = 1
        }
    }
    
    @IBAction private func click_SignUp() {
        let validateFirst = txtFirstName.text.validateFirst()
        let validateLast = txtLastName.text.validateLast()
        let validateEmail = txtEmail.text.validateEmail()
        let validatePhone = txtPhoneNo.text.validatePhone()
        let validatePass = txtPassword.text.validatePassword()
        let validateConfPass = txtConfPassword.text.validateConfirmPassword(with: txtPassword.text)
        
        if validateFirst.status == false {
            showToast(message: validateFirst.message)
        }
        else if validateLast.status == false {
            showToast(message: validateLast.message)
        }
        else if validatePhone.status == false, intVerifyType == 1 {
            showToast(message: validatePhone.message)
        }
        else if validateEmail.status == false {
            showToast(message: validateEmail.message)
        }
        else if validatePass.status == false {
            showToast(message: validatePass.message)
        }
        else if validateConfPass.status == false {
            showToast(message: validateConfPass.message)
        }
        else if imgIAccept.image != nil{
            showToast(message: "please select accept")
        }
        else {
            register()
        }
        
        
    }
    
    @IBAction private func click_IAccept() {
        if imgIAccept.image == UIImage(named: "ic_favChecked")?.withRenderingMode(.alwaysTemplate) {
            imgIAccept.image = UIImage(named: "ic_unCheckbox")?.withRenderingMode(.alwaysOriginal)
            imgIAccept.backgroundColor = .clear
        } else { // selected
            imgIAccept.image = UIImage(named: "ic_favChecked")?.withRenderingMode(.alwaysTemplate)
            imgIAccept.tintColor = .primaryBlue
            imgIAccept.backgroundColor = .clear
        }
    }
    
    @IBAction private func click_SignIn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // API calls
    private func register() {
        showLoader()
        vmObject.register(phone: txtPhoneNo.text,
                          country: txtPhoneNo.countryCode.toString,
                          email: txtEmail.text,
                          verified: intVerifyType,
                          complition: { result in
            hideLoader()
            if result.status {
                let vc = VerificationCodeVC()
                vc.navigate(SignupRequestModel(
                    first_name: self.txtFirstName.text,
                    last_name: self.txtLastName.text,
                    email: self.txtEmail.text,
                    phone_number: self.txtPhoneNo.text,
                    password: self.txtPassword.text,
                    confirm_password: self.txtConfPassword.text,
                    country_code: self.txtPhoneNo.countryCode.toString,
                    location: self.vmObject.selectedSearch?.formattedAddress ?? "",
                    longitude: self.vmObject.selectedSearch?.geometry?.location?.lng ?? 0,
                    latitude: self.vmObject.selectedSearch?.geometry?.location?.lat ?? 0,
                    verified_by: self.intVerifyType
                ))
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                showToast(message: result.message)
            }
        })
    }
}
extension SignupVC: OTLTextFieldDelegate {
    
    func otlTextField(_ textField: OTLTextField, willStartEditing: Bool) {
        self.view.endEditing(true)
        let vc = LocationSearchVC()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }

}
extension SignupVC: LocationSearchDelegate {
    func locationSearch(_ controller: LocationSearchVC, didSelect: GMapResult) {
        vmObject.selectedSearch = didSelect
        txtLocation.text = didSelect.formattedAddress
    }
    
    
}
