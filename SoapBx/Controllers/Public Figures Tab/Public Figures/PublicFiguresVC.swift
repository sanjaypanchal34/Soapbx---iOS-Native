//
//  PublicFiguresVC.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner

class PublicFiguresVC: UIViewController {

    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var searchView: OTLPTButton!
    @IBOutlet private weak var tblList: UITableView!
    
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomTab.selectedTab = .publicFigures
    }

    private func setupUI() {
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        
        viewHeader.lblTitle.setHeader("Public Figures")
        
        searchView.backgroundColor = .lightGrey
        searchView.layer.cornerRadius = searchView.frame.height/2
        searchView.imageView?.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        searchView.imageView?.tintColor = .titleGrey
        
        tblList.register(["PublicFiguresItemCell"], delegate: self, dataSource: self)
        
    }

    //
    @IBAction private func click_search() {
        let vc = SearchVC()
        vc.screenType = .fromPublicFigures
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension PublicFiguresVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PublicFiguresItemCell") as? PublicFiguresItemCell {
            cell.setDataFollowing()
            return cell
        }
        return UITableViewCell()
    }
    
}
extension PublicFiguresVC: OTLBottomTabBarDelegate {
    
    func didChangeTab(old: OTLContaner.OTLBottomTabBarItem, new: OTLContaner.OTLBottomTabBarItem) {
        
        switch new {
            
        case .home:
            mackRootView(HomeVC())
            break
        case .publicFigures:
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
