//
//  PostImageItemCell.swift
//  SoapBx
//
//  Created by Mac on 09/07/23.
//

import UIKit
import OTLContaner

protocol PostImageItemDelegate {
    func postImageItem(_ cell:PostImageItemCell, didSelectDelete: Void)
}

class PostImageItemCell: AppCollectionViewCell {

    @IBOutlet private weak  var imagePost: UIImageView!
    @IBOutlet private weak  var btnCancel: OTLImageButton!
    
    var delegate: PostImageItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePost.layer.cornerRadius = 5
        btnCancel.isHidden = true
    }

    func setData(_ object: PostImage, indexPath: IndexPath) {
        self.indexPath = indexPath
        btnCancel.isHidden = true
        imagePost.setImage(object.imageURL)
        imagePost.contentMode = .scaleAspectFill
    }
    
    func setDataCreatePostImage(_ object: PostImage, indexPath: IndexPath ,delegate: PostImageItemDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        btnCancel.isHidden = false
        btnCancel.image = UIImage(named: "cross_icon")?.withRenderingMode(.alwaysTemplate)
        btnCancel.contentMode = .scaleAspectFill
        btnCancel.padding = UIEdgeInsets(top: -5, left: 15, bottom: 0, right: 0)
        btnCancel.tintColor = .titleRed
        btnCancel.height = 15
        btnCancel.backgroundColor = .clear
        imagePost.backgroundColor = .primaryBlue
        imagePost.contentMode = .scaleAspectFill
        if let imageURL = object.imageURL {
            imagePost.setImage(imageURL)
        } else {
            imagePost.image = object.localImage
        }
    }
    
    func setDataCreatePostImageAddImage() {
        btnCancel.isHidden = true
        imagePost.backgroundColor = .white
        imagePost.image = UIImage(named: "ic_add")
    }
    
    @IBAction private func click_btnCancel() {
        delegate?.postImageItem(self, didSelectDelete: Void())
    }
}
