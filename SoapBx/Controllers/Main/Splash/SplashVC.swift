//
//  SplashVC.swift
//  SoapBx
//
//  Created by Mac on 03/07/23.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mackRootView(LoginVC())
    }
}
