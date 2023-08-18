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

    func setCreatePostPolitician(_ object: PostUser) {
        viewMain.backgroundColor = .primaryBlue
        lblTitle.font = AppFont.medium.font(size: 14)
        lblTitle.text = " "+(object.name ?? "")+" "
        DispatchQueue.main.async {
            self.viewMain.setShadowWithCorner(corner:-1)
        }
    }
    
    func setCreatePostPoll(_ object: TrendsModel) {
        viewMain.backgroundColor = .primaryBlue
        lblTitle.font = AppFont.regular.font(size: 12)
        lblTitle.text = " "+(object.name ?? "")+" "
        DispatchQueue.main.async {
            self.viewMain.setShadowWithCorner(corner:-1)
        }
    }
    
    func setCreatePostTreds(_ object: TrendsModel) {
        viewMain.backgroundColor = .primaryBlue
        lblTitle.font = AppFont.medium.font(size: 14)
        lblTitle.text = " "+(object.name ?? "")+" "
        DispatchQueue.main.async {
            self.viewMain.setShadowWithCorner(corner:-1)
        }
    }
    
    func setPollsTrends(_ object: TrendsModel, isSelected: Bool) {
        if isSelected {
            viewMain.backgroundColor = .primaryBlue
            viewMain.layer.borderColor = UIColor.clear.cgColor
            lblTitle.textColor = .white
        } else {
            viewMain.backgroundColor = .white
            viewMain.layer.borderWidth = 0.5
            viewMain.layer.borderColor = UIColor.black.cgColor
            lblTitle.textColor = .titleGray
        }
        lblTitle.font = AppFont.medium.font(size: 14)
        lblTitle.text = " "+(object.name ?? "")+" "
        DispatchQueue.main.async {
            self.viewMain.setShadowWithCorner(corner:-1)
        }
    }
}
