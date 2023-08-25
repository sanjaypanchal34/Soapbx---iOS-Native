//
//
// YouInterestCell.swift
// SoapBx
//
// Created by Arvind Kanjariya on 25/08/23
//
        

import UIKit

class YouInterestCell: UITableViewCell {

    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var viewSelectdIcon: UIView!
    @IBOutlet private weak var imgSelectdIcon: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.textColor = .titleBlack
        lblTitle.textAlignment = .left
        imgIcon.backgroundColor = .gray
        imgSelectdIcon.backgroundColor = .clear
        imgSelectdIcon.image = UIImage(named: "ic_favChecked")
        viewSelectdIcon.backgroundColor = UIColor.primaryBlue.withAlphaComponent(0.3)
    }
    
    func setData(_ object: TrendsModel, isSelcted: Bool = false) {
        self.imgIcon.setImage(object.imageURL)
        lblTitle.text = object.name
        viewSelectdIcon.isHidden = !isSelcted
    }
    
}
