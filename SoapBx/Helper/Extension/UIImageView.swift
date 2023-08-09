//
//  UIImageView.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 06/08/2023.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit
import OTLContaner
import SDWebImage

extension UIImageView {
    func setImage(_ urlString:String?, placeHolder:UIImage = UIImage(named: "ic_user")! , sizeAccrodingSelf : Bool = false) {
        guard var strURL = urlString else { return }
//        printLog("set Image from URL : \(strURL)")
        self.contentMode = .scaleAspectFill
        strURL = urlString!.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: strURL) {
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.sd_setImage(with: url, placeholderImage: placeHolder) { (image, error, cache, url) in
                    if sizeAccrodingSelf {
                        self.imageAdjustAccordingSize(image)
                    }
                }
        } else {
            self.image = placeHolder
        }
    }
    
    func setLocalImage(_ name: String? = nil, placeholder:UIImage? = nil) {
        if let placeholder = placeholder {
            self.image = UIImage(named: name ?? "") ?? placeholder
        } else {
            self.image = UIImage(named: name ?? "") ?? UIImage.init()
        }
    }
    
    func imageAdjustAccordingSize(_ image: UIImage?){
        let scale: CGFloat = max(self.frame.width / (image?.size.width ?? 0.0), self.frame.height / (image?.size.height ?? 0.0))
        let width: CGFloat = (image?.size.width ?? 0.0) * scale
        let height: CGFloat = (image?.size.height ?? 0.0) * scale
        let imageRect = CGRect(x: (self.frame.width - width) / 2.0, y: (self.frame.height - height) / 2.0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        image?.draw(in: imageRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
    }
}

extension OTLImageButton {
    func setImage(_ urlString:String?, placeHolder:UIImage = UIImage(named: "ic_user")! , sizeAccrodingSelf : Bool = false){
        guard var strURL = urlString else { return }
        strURL = urlString!.replacingOccurrences(of: " ", with: "%20")
        image = placeHolder
        self.contentMode = .scaleAspectFill
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let url = URL(string: strURL) {
            SDWebImageManager().loadImage(with: url) { receivedSize, IntexpectedSize, url in
                
            } completed: { image, data, error, catchType, status, url in
                if status {
                    self.image = image
                    self.sd_imageIndicator = nil
                }
            }

        }
    }
}
