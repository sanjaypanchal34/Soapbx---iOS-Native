//
//  SearchVC.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner
enum SearchScreenType {
    case searchTab, fromPublicFigures
}
class SearchVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var searchView: OTLPTButton!
    @IBOutlet private weak var txtSearch: UITextField!
    @IBOutlet private weak var tblList: UITableView!
    
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!
    
    var screenType = SearchScreenType.searchTab
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if screenType == .searchTab {
        bottomTab.selectedTab = .search
            viewHeader.btnBack.isHidden = true
        } else {
            bottomTab.isHidden = true
            viewHeader.btnBack.isHidden = false
        }
    }

    private func setupUI() {
        bottomTab.setTabTheme()
        bottomTab.delegate = self
        
        viewHeader.lblTitle.setHeader("Search")
        
        searchView.backgroundColor = .lightGrey
        searchView.layer.cornerRadius = searchView.frame.height/2
        searchView.imageView?.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        searchView.imageView?.tintColor = .titleGrey
        
        txtSearch.font = AppFont.regular.font(size: 16)
        
        tblList.register(["SearchItemCell"], delegate: self, dataSource: self)
        
    }

    //
}
extension SearchVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell") as? SearchItemCell {
            if screenType == .searchTab {
                cell.setDataForSearchTab()
            } else {
                cell.setDataForPublicSearch()
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
extension SearchVC: OTLBottomTabBarDelegate {
    
    func didChangeTab(old: OTLContaner.OTLBottomTabBarItem, new: OTLContaner.OTLBottomTabBarItem) {
        
        switch new {
            
        case .home:
            mackRootView(HomeVC())
        case .publicFigures:
            mackRootView(PublicFiguresVC())
        case .addPost:
            break
        case .search:
            break
        case .profile:
            break
        }
    }
    
    
}
