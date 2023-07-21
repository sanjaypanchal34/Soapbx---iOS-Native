//
//  PostItemPoliticalCell.swift
//  SoapBx
//
//  Created by Mac on 09/07/23.
//

import UIKit

class PostItemPoliticalCell: AppCollectionViewCell {

    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setTheme("", color: .white, size: 12)
    }
    
    func setDataSoapbx(_ title: String) {
        viewMain.backgroundColor = .primaryBlue
        lblTitle.text = title
        DispatchQueue.main.async {
            self.viewMain.layer.cornerRadius =  self.viewMain.frame.height/2
        }
    }
    
    func setDataPolitician(_ title: String) {
        viewMain.backgroundColor = .appYellow
        lblTitle.text = title
        DispatchQueue.main.async {
            self.viewMain.layer.cornerRadius =  self.viewMain.frame.height/2
        }
    }

    func setCreatePost(_ title: String) {
        viewMain.backgroundColor = .primaryBlue
        lblTitle.font = AppFont.medium.font(size: 14)
        lblTitle.text = " "+title+" "
        DispatchQueue.main.async {
            self.viewMain.layer.cornerRadius =  self.viewMain.frame.height/2
        }
    }
}
