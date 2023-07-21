//
//  CMSPageVC.swift
//  SoapBx
//
//  Created by Mac on 20/07/23.
//

import UIKit
import OTLContaner
import WebKit

enum CMSPageScreenType {
    case faq, about, termsCondition, policy
    
    var title:String {
        switch self {
        case .faq: return "FAQ"
        case .about: return "About Soapbx"
        case .termsCondition: return "Terms of Service"
        case .policy: return "Privacy Policy"
        }
    }
    
    var url:URL {
        switch self {
        case .faq: return URL(string: "https://soapbx.net/webview/webFaq")!
        case .about: return URL(string: "https://soapbx.net/webview/page/1")!
        case .termsCondition:  return URL(string: "https://soapbx.net/webview/page/4")!
        case .policy: return URL(string: "https://soapbx.net/webview/page/3")!
        }
    }
}

class CMSPageVC: UIViewController {

    @IBOutlet private weak var headerView:OTLHeader!
    
    @IBOutlet private weak var viewBody:UIView!
    @IBOutlet private weak var webView:WKWebView!
    
    var screenType = CMSPageScreenType.faq
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        headerView.lblTitle.setHeader(screenType.title)
        
        webView.load(URLRequest(url: screenType.url))
    }
}
