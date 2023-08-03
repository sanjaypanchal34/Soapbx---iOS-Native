//
//  PostImageItemCell.swift
//  SoapBx
//
//  Created by Mac on 09/07/23.
//

import UIKit
import OTLContaner

class PostImageItemCell: AppCollectionViewCell {

    @IBOutlet private weak  var imagePost: UIImageView!
    @IBOutlet private weak  var btnCancel: OTLImageButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePost.layer.cornerRadius = 5
        btnCancel.isHidden = true
    }

    func setData(_ object: PostImage) {
        btnCancel.isHidden = true
        imagePost.setImage(object.imageURL)
        imagePost.contentMode = .scaleAspectFill
    }
    
    func setDataCreatePostImage(_ image: String) {
        btnCancel.isHidden = false
        btnCancel.image = UIImage(named: "image")?.withRenderingMode(.alwaysTemplate)
        btnCancel.contentMode = .scaleAspectFill
        btnCancel.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btnCancel.tintColor = .titleRed
        btnCancel.backgroundColor = .clear
        imagePost.backgroundColor = .primaryBlue
    }
    
    func setDataCreatePostImageAddImage() {
        btnCancel.isHidden = true
        imagePost.backgroundColor = .white
        imagePost.image = UIImage(named: "ic_add")
    }
}
