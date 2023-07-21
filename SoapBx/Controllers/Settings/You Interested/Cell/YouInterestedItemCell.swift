//
//  YouInterestedItemCell.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit

class YouInterestedItemCell: UICollectionViewCell {

    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var viewSelectdIcon: UIView!
    @IBOutlet private weak var imgSelectdIcon: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.textColor = .titleBlack
        lblTitle.setTheme("")
        lblTitle.textAlignment = .center
        imgIcon.backgroundColor = .gray
        imgSelectdIcon.backgroundColor = .clear
        imgSelectdIcon.image = UIImage(named: "ic_favChecked")
        viewSelectdIcon.backgroundColor = UIColor.primaryBlue.withAlphaComponent(0.3)
    }
    
    func setData(_ object: String, isSelcted: Bool = false) {
        self.imgIcon.image = UIImage(named: "ic_user")
        lblTitle.text = object
        viewSelectdIcon.isHidden = !isSelcted
        
        DispatchQueue.main.async {
            self.imgIcon.layer.cornerRadius = self.imgIcon.frame.width/2
            self.viewSelectdIcon.layer.cornerRadius = self.viewSelectdIcon.frame.width/2
        }
    }

}
