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
    
    static let width: CGFloat = 70

    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgCheckBox: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.cornerRadius = 10
        lblTitle.setTheme("", color: .white, lines: 1)
        imgCheckBox.backgroundColor = .clear
        imgCheckBox.layer.cornerRadius = imgCheckBox.frame.height/2
    }

    func setData(_ object: DummyTrends, isSelected: Bool = false) {
        lblTitle.text = object.title
        viewMain.backgroundColor = UIColor.hex(toUIColor: object.colorHax)
        imgCheckBox.image = isSelected ? UIImage(named: "ic_planChecked") : UIImage(named: "ic_planUnchecked")
    }
}
