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
    @IBOutlet private weak var lblTerms: UILabel!
    
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
    
    @objc
    private func handleTapped(_ recognizer: UITapGestureRecognizer) {
        let vc = CMSPageVC()
        vc.screenType = .termsCondition
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    private func setupUI() {
        btnBack.emptyTitle()
        lblTerms.text = LocalStrings.S_TERMS.rawValue.addLocalizableString()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapped(_:)))
        lblTerms.addGestureRecognizer(recognizer)
        lblTitle.setTheme(LocalStrings.SIGNUP_TITLE.rawValue.addLocalizableString(),
                          font: .bold,
                          size: 38)
        lblSubtitle.setTheme(LocalStrings.SIGNUP_STITLE.rawValue.addLocalizableString(),
                             color: .titleGray)
        
        txtFirstName.setTheme(placeholder: LocalStrings.SIGNUP_P_FNAME.rawValue.addLocalizableString(),
                          leftIcon: UIImage(named: "ic_user"))
        txtLastName.setTheme(placeholder: LocalStrings.SIGNUP_P_LNAME.rawValue.addLocalizableString(),
                             leftIcon: UIImage(named: "ic_user"))
        txtPhoneNo.setTheme(placeholder: LocalStrings.SIGNUP_P_PNUMBER.rawValue.addLocalizableString(),
                          leftIcon: UIImage(named: "ic_phone"))
        txtPhoneNo.keyboardType = .phonePad
        
        txtEmail.setTheme(placeholder: LocalStrings.SIGNUP_P_EMAIL.rawValue.addLocalizableString(),
                          leftIcon: UIImage(named: "ic_email"))
        txtEmail.keyboardType = .emailAddress
        
        txtPassword.setTheme(placeholder: LocalStrings.SIGNUP_P_PASSWORD.rawValue.addLocalizableString())
        txtConfPassword.setTheme(placeholder: LocalStrings.SIGNUP_P_CPASSWORD.rawValue.addLocalizableString())
        txtLocation.setTheme(placeholder:LocalStrings.SIGNUP_P_LOCATION.rawValue.addLocalizableString(),
                             leftIcon: UIImage(named: "ic_location_grey"))
        txtLocation.delegate = self
        
        lblVerifyEmail.setTheme(LocalStrings.SIGNUP_VERIFY_EMAIL.rawValue.addLocalizableString(), size: 14)
        lblVerifyPhone.setTheme(LocalStrings.SIGNUP_VERIFY_NUMBER.rawValue.addLocalizableString(), size: 14)
        for view in [viewVerifyEmail, viewVerifyPhone] {
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        lblIAccept.setTheme(LocalStrings.SIGNUP_ACCEPT.rawValue.addLocalizableString())
        btnSignUp.appButton(LocalStrings.SIGNUP_SIGNUP.rawValue.addLocalizableString())
        
        lblAlreadyAMamber.setTheme(LocalStrings.SIGNUP_ALREADY_MEMEBER.rawValue.addLocalizableString())
        btnSignIn.setTheme(LocalStrings.SIGNUP_SIGN_IN.rawValue.addLocalizableString(),color: .primaryBlue, font: .medium, size: 16)
        
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
        else if imgIAccept.image != UIImage(named: "ic_favChecked")?.withRenderingMode(.alwaysTemplate) {
            showToast(message:LocalStrings.SIGNUP_ALERT.rawValue.addLocalizableString())
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
            showToast(message: result.message)
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
