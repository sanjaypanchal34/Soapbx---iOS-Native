//
//  SuggestFeatureVC.swift
//  SoapBx
//
//  Created by Mac on 19/07/23.
//

import UIKit
import OTLContaner

enum SuggestFeatureScreenType {
    case suggestFeature, feedback
}

class SuggestFeatureVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var txtProfileName: OTLTextField!
    @IBOutlet private weak var txtEmail: OTLTextField!
    @IBOutlet private weak var txtLocation: OTLTextField!
    @IBOutlet private weak var txtPhoneNo: OTLTextField!
    @IBOutlet private weak var viewComment: UIView!
    @IBOutlet private weak var lblCommentPlaceholder: UILabel!
    @IBOutlet private weak var txtComment: UITextView!
    @IBOutlet private weak var btnUpdate: OTLTextButton!
    
    var screenType = SuggestFeatureScreenType.suggestFeature
    private let vmObject = SuggestFeatureViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
 
        viewHeader.lblTitle.setHeader(screenType == .feedback ? LocalStrings.S_TITLE_FEEDBACK.rawValue.addLocalizableString() : LocalStrings.S_TITLE.rawValue.addLocalizableString())
        
        txtProfileName.setTheme(placeholder: LocalStrings.S_PROFILE.rawValue.addLocalizableString())
        txtEmail.setTheme(placeholder: LocalStrings.S_EMAIL.rawValue.addLocalizableString())
        txtLocation.setTheme(placeholder: LocalStrings.S_LOCATION.rawValue.addLocalizableString())
        txtPhoneNo.setTheme(placeholder: LocalStrings.S_PNUMBER.rawValue.addLocalizableString())
        
        viewComment.backgroundColor = .white
        viewComment.layer.cornerRadius = 10
        viewComment.layer.borderWidth = 1
        viewComment.layer.borderColor = UIColor.lightGrey.cgColor
        lblCommentPlaceholder.setTheme(LocalStrings.S_WHAT_IN_MIND.rawValue.addLocalizableString(), color: .titleGray, size: 18)
        txtComment.font = AppFont.regular.font(size: 18)
        txtComment.delegate = self
        
        btnUpdate.appButton(LocalStrings.S_SEND.rawValue.addLocalizableString())
        setData()
    }
    
    private func setData() {
        txtProfileName.text = authUser?.user?.name ?? ""
        txtEmail.text = authUser?.user?.email ?? ""
        txtLocation.text = getValueOrDefult(authUser?.user?.location, defaultValue: "N/A")
        txtPhoneNo.text = authUser?.user?.phone_number ?? ""
        
    }
    
    //actions
    @IBAction private func click_btnUpdate() {
        let validateProfileName = txtProfileName.text.validateProfileName()
        let validateEmail = txtEmail.text.validateEmail()
        let validatePhone = txtPhoneNo.text.validatePhone()
        let validateComment = (txtComment.text ?? "").validateSuggestComment()
        
        if validateProfileName.status == false {
            showToast(message: validateProfileName.message)
        }
        else if validateEmail.status == false {
            showToast(message: validateEmail.message)
        }
        else if validatePhone.status == false{
            showToast(message: validatePhone.message)
        }
        else if validateComment.status == false {
            showToast(message: validateComment.message)
        }
        else {
            feedback()
        }
    }
    
    
    //API Calls
    private func feedback() {
        showLoader()
        vmObject.updateSubscriptionPlans(name: txtProfileName.text, type: screenType, email: txtEmail.text, comment: txtComment.text, location: txtLocation.text, number: txtPhoneNo.text) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension SuggestFeatureVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewComment.layer.borderColor = UIColor.primaryBlue.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewComment.layer.borderColor = UIColor.lightGrey.cgColor
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 0 {
            lblCommentPlaceholder.isHidden = true
        } else {
            lblCommentPlaceholder.isHidden = false
        }
        return true
    }
}
