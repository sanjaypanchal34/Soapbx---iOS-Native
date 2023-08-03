//
//  PostItemPoliticalCell.swift
//  SoapBx
//
//  Created by Mac on 09/07/23.
//

import UIKit
import OTLContaner

class PostItemPoliticalCell: AppCollectionViewCell {

    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setTheme("", color: .white, size: 12)
        
    }
    
    func setDataSoapbx(_ object: PostTag) {
        viewMain.backgroundColor = .primaryBlue
        lblTitle.text = object.trend?.name
        DispatchQueue.main.async {
            self.viewMain.setShadowWithCorner(corner:-1)
        }
    }
    
    func setDataPolitician(_ object: PostTag) {
        viewMain.backgroundColor = .appYellow
        lblTitle.text = object.politician?.name
        DispatchQueue.main.async {
            self.viewMain.setShadowWithCorner(corner:-1)
        }
    }

    func setCreatePost(_ title: String) {
        viewMain.backgroundColor = .primaryBlue
        lblTitle.font = AppFont.medium.font(size: 14)
        lblTitle.text = " "+title+" "
        DispatchQueue.main.async {
            self.viewMain.setShadowWithCorner(corner:-1)
        }
    }
}
