//
//  global.swift
//  SoapBx
//
//  Created by Mac on 05/07/23.
//

import UIKit


func mackRootView(_ controller: UIViewController) {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.navigationController = UINavigationController.init(rootViewController: controller)
        appDelegate.navigationController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = appDelegate.navigationController
        appDelegate.window?.makeKeyAndVisible()
    }
}
