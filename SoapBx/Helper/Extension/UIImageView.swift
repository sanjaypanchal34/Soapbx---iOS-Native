//
//  UIImageView.swift
//  SoapBx
//
//  Created by admin on 29/07/23.
//
import UIKit
import SDWebImage

extension UIImageView {
    func setImage(_ urlString:String?, placeHolder:UIImage = UIImage(named: "ic_user")! , sizeAccrodingSelf : Bool = false) {
        guard var strURL = urlString else { return }
//        printLog("set Image from URL : \(strURL)")
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
