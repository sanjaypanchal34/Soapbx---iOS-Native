//
//  HomeTabVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import OTLContaner

class HomeVC: UIViewController {
    
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
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        viewTradPost.regiter()
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
