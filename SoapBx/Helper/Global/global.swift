//
//  global.swift
//  SoapBx
//
//  Created by Mac on 05/07/23.
//

import UIKit
import OTLContaner

func mackRootView(_ controller: UIViewController) {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.navigationController = UINavigationController.init(rootViewController: controller)
        appDelegate.navigationController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = appDelegate.navigationController
        appDelegate.window?.makeKeyAndVisible()
    }
}

func showToast(message: String) {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.window?.rootViewController?.view.makeToast(message,
                                                               image: UIImage(named: "logo_toast"))
    }
}
func showAlert( message: String,
                buttons: [OTLAlertModel] = [OTLAlertModel(title: "Okay", id: 0)],
                style: UIAlertController.Style = .alert,
                complition: ((OTLAlertModel)->())? = nil) {
    showAlert(title: "SoapBx", message: message, buttons: buttons, style: style, complition: complition)
}
