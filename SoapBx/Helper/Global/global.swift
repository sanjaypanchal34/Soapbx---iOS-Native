//
//  global.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
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

func showAlert( message: String,
                buttons: [String] = ["Okay"],
                style: UIAlertController.Style = .alert,
                complition: ((OTLAlertModel)->())? = nil) {
    let arrButtons = buttons.enumerated().map({ element in
        OTLAlertModel(title: element.element, id: element.offset)
    })
    showAlert(title: "SoapBx", message: message, buttons: arrButtons, style: style, complition: complition)
}

func showLoader(labelComplition: ((UILabel)->())? = nil) {
    otlStartActivityIndicator(color: .primaryBlue, labelComplition: labelComplition)
}


func hideLoader() {
    otlStopActivityIndicator()
}
