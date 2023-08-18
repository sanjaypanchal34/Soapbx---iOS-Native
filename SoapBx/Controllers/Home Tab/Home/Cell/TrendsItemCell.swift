//
//  TrendsItemCell.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit

struct DummyTrends {
    var title: String
    var colorHax: String
}

class TrendsItemCell: AppCollectionViewCell {
    
    static let width: CGFloat = 65

    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgCheckBox: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 10
        lblTitle.setTheme("", color: .white, lines: 1)
        imgIcon.backgroundColor = .clear
        imgIcon.layer.cornerRadius = imgIcon.frame.height/2
        imgCheckBox.backgroundColor = .clear
        imgCheckBox.layer.cornerRadius = imgCheckBox.frame.height/2
    }

    func setData(_ object: TrendsModel, color: String, isSelected: Bool = false) {
        lblTitle.text = object.name
        imgIcon.setImage(object.imageURL, placeHolder: UIImage(named: "allTrends")!)
        viewMain.backgroundColor = UIColor.hex(toUIColor: color)
        imgCheckBox.image = isSelected ? UIImage(named: "ic_planChecked") : UIImage(named: "ic_planUnchecked")
    }
}
