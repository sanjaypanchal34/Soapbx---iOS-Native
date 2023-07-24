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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
 
        viewHeader.lblTitle.setHeader(screenType == .feedback ? "Feedback" : "Suggest Feature")
        
        txtProfileName.setTheme(placeholder: "Profile Name")
        txtEmail.setTheme(placeholder: "Email")
        txtLocation.setTheme(placeholder: "Location")
        txtPhoneNo.setTheme(placeholder: "Phone Number")
        
        viewComment.backgroundColor = .white
        viewComment.layer.cornerRadius = 10
        viewComment.layer.borderWidth = 1
        viewComment.layer.borderColor = UIColor.lightGrey.cgColor
        lblCommentPlaceholder.setTheme("What is on your mind?", color: .titleGrey, size: 18)
        txtComment.font = AppFont.regular.font(size: 18)
        txtComment.delegate = self
        
        btnUpdate.appButton("Send")
    }
    
    //actions
    @IBAction private func click_btnUpdate() {
        self.navigationController?.popViewController(animated: true)
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