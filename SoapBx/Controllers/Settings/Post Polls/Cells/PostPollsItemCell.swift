//
//  PostPollsItemCell.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit
import OTLContaner

protocol PostPollsItemDelegate {
    func postPollsItem(_ cell: PostPollsItemCell, didUpdateText: String)
    func postPollsItem(_ cell: PostPollsItemCell, didTabDelete: Void)
}

class PostPollsItemCell: AppTableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var btnDelete: OTLImageButton!
    @IBOutlet private weak var txtTitle: UITextField!
    
    var text: String {
        get { txtTitle.text ?? "" }
        set { txtTitle.text = newValue }
    }
    var delegate: PostPollsItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete.image = UIImage(named: "delete")
        btnDelete.backgroundColor = .clear
        btnDelete.type = .independent
        btnDelete.height = 15
        btnDelete.width = 12
        lblTitle.setTheme(LocalStrings.POLL_OPTION.rawValue.addLocalizableString(), color: .primaryBlue, font: .bold)
        viewMain.backgroundColor = .white
        viewMain.layer.cornerRadius = 10
        viewMain.layer.borderWidth = 1
        viewMain.layer.borderColor = UIColor.lightGrey.cgColor
        txtTitle.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        txtTitle.placeholder = LocalStrings.POLL_PLACE_HOLDER.rawValue.addLocalizableString()
        txtTitle.font = AppFont.regular.font(size: 16)
    }

    func setData(text: String, isLastIndex: Bool, delegate: PostPollsItemDelegate) {
        txtTitle.text = text
        lblTitle.text = String(format: "%@ %d", LocalStrings.POLL_OPTION.rawValue.addLocalizableString(), (indexPath.row + 1))
        self.delegate = delegate
        btnDelete.isHidden = !isLastIndex
    }
    
    @objc private func editingDidEnd() {
        self.delegate?.postPollsItem(self, didUpdateText: txtTitle.text ?? "");
    }
    
    @IBAction private func click_btnClick() {
        self.delegate?.postPollsItem(self, didTabDelete: Void());
    }
}
