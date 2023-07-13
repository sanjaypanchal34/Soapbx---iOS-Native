//
//  PostImageItemCell.swift
//  SoapBx
//
//  Created by Mac on 09/07/23.
//

import UIKit

class PostImageItemCell: AppCollectionViewCell {

    @IBOutlet private weak  var imagePost: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePost.layer.cornerRadius = 5
    }

    func setData(_ index:Int) {
        if index == 0 {
            imagePost.backgroundColor = .titleGrey
        }
        else if index == 1 {
            imagePost.backgroundColor = .primaryBlue
        }
        else if index == 2 {
            imagePost.backgroundColor = .appYellow
        }
        else if index == 3 {
            imagePost.backgroundColor = .titleRed
        }
    }
}
