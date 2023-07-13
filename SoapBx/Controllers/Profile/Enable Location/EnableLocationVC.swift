//
//  EnableLocationVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit

class EnableLocationVC: UIViewController {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var btnSkip: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    //MARK: - Setup view
    private func setupUI() {
        lblTitle.setTheme("Enable location",
                          font: .bold,
                          size: 40)
        
        lblDescription.setTheme("We want to access your location only to provide a better experience by helping you finding your exact location.", color: .titleGrey, font: .regular, size: 14)
        
        btnNext.appButton("Enable")
        btnSkip.setTheme("Skip for now", color: .titleGrey)
        
    }
    
    //Actions
    @IBAction private func click_btnNext() {
        
    }
    
    @IBAction private func click_skipNow() {
        
    }
}
