//
//  HomeTabVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import OTLContaner

class HomeVC: UIViewController {
    
    @IBOutlet private weak var btnMessage:OTLImageButton!
    @IBOutlet private weak var btnNotification:OTLImageButton!
    @IBOutlet private weak var btnManu:OTLImageButton!
    
    @IBOutlet private weak var viewTradPost: TradPostListView!
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!

    private var arrTernds: [DummyTrends] = [
        DummyTrends(title: "All Trends", colorHax: "#FFD800"),
        DummyTrends(title: "Think Talk", colorHax: "#F1120B"),
        DummyTrends(title: "Crrcular Economy", colorHax: "#CDFFFF"),
        DummyTrends(title: "Global Affairs", colorHax: "#FFD800"),
    ]

    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomTab.selectedTab = .home
    }

    private func setupUI() {
        btnMessage.image = UIImage(named: "ic_sendRed")
        btnNotification.image = UIImage(named: "ic_bellIcon")
        
        btnManu.image = UIImage(named: "ic_drawer")
        btnManu.padding = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        viewTradPost.regiter()
    }
    
    @IBAction private func click_menu() {
        showSideMenu()
    }
}

extension HomeVC: OTLBottomTabBarDelegate {
    
    func didChangeTab(old: OTLContaner.OTLBottomTabBarItem, new: OTLContaner.OTLBottomTabBarItem) {
        switch new {
        case .home:
            break
        case .publicFigures:
            mackRootView(PublicFiguresVC())
            break
        case .addPost:
            navigationController?.pushViewController(CreatePostVC(), animated: true)
            break
        case .search:
            mackRootView(SearchVC())
            break
        case .profile:
            mackRootView(ProfileVC())
            break
        }
    }
}
