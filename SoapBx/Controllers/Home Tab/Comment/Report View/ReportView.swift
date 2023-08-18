//
//  ReportView.swift
//  SoapBx
//
//  Created by admin on 31/07/23.
//

import UIKit
import OTLContaner

class ReportView: UIControl {

    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblPlaceholder: UILabel!
    @IBOutlet private weak var txtReason: UITextView!
    @IBOutlet private weak var btnSubmit: OTLTextButton!

    fileprivate var complition: ((Int, String)->Void)?
    fileprivate var commentId:Int = 0
    
    static func loadFromNib() -> Self {
        let nib = UINib(nibName: "ReportView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        viewBody.backgroundColor = .white
        viewBody.layer.cornerRadius = 10
        
        lblTitle.setHeader("Reason")
        lblPlaceholder.setTheme("Write reason to report a", color: .titleGray, size: 18)
        txtReason.setCornerRadius(border: 1, color: .lightGray, corner: 10)
        txtReason.font = AppFont.regular.font(size: 18)
        txtReason.delegate = self
        txtReason.text = ""
        
        btnSubmit.appButton("Submit")
        
        self.addTarget(self, action: #selector(dissmis), for: .touchUpInside)
    }
    
    @IBAction private func click_btnSubmit() {
        let validate =  txtReason.text.validateReason()
        if validate.status == false{
            SoapBx.showToast(message: validate.message)
        } else {
            complition?(commentId, txtReason.text)
            removeFromSuperview()
        }
    }
    
    @objc private func dissmis() {
        removeFromSuperview()
    }
}
extension ReportView : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 0 {
            lblPlaceholder.isHidden = true
        } else {
            lblPlaceholder.isHidden = false
        }
        return true
    }
}

extension UIView {
    func showReportView(comment id: Int, complition: @escaping ((Int, String)->Void)){
        let view = ReportView.loadFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.bounds
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        view.commentId = id
        view.complition = complition
        
    }
}
