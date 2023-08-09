//
//  SearchVC.swift
//  SoapBx
//
//  Created by Mac on 10/07/23.
//

import UIKit
import OTLContaner
enum SearchScreenType {
    case searchTab, fromPublicFigures, fromCreatePost
}

protocol SearchDelegate {
    func search(selectedUserForCreatePost users: [PostUser])
}
class SearchVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var searchView: OTLPTButton!
    @IBOutlet private weak var txtSearch: UITextField!
    @IBOutlet private weak var tblList: UITableView!
    
    @IBOutlet private weak var viewBottomButton: UIView!
    @IBOutlet private weak var btnDone: OTLTextButton!
    
    @IBOutlet private weak var bottomTab: OTLBottomTabBar!
    
    private var screenType = SearchScreenType.searchTab
    private let vmObject = SearchViewModel()
    private var delegate:SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getPoliticians()
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
    // navigation Data
    func navigateFromCreatePost(selected user: [PostUser], delegate:SearchDelegate) {
        screenType = .fromCreatePost
        self.delegate = delegate
        vmObject.arrSelectedId = user.compactMap({ user in
            return user.id
        })
    }
    
    func navigateFromPublicFigures() {
        screenType = .fromPublicFigures
    }
    
    //setup UI/UX
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
        viewBottomButton.isHidden = true
        
        btnDone.appButton("Done")
        
        if screenType == .fromCreatePost {
            viewHeader.lblTitle.text = "Public Figures"
            viewBottomButton.isHidden = false
        }
    }
    
    @IBAction private func click_btnDone() {
        if screenType == .fromCreatePost {
            var selectedUser: [PostUser] = vmObject.arrList.compactMap { user in
                if vmObject.arrSelectedId.contains(user.id ?? 0) {
                    return user
                }
                return nil
            }
            delegate?.search(selectedUserForCreatePost: selectedUser)
            navigationController?.popViewController(animated: true)
        }
    }

    //API calls
    private func getPoliticians() {
        showLoader()
        vmObject.getPolitician { result in
            hideLoader()
            if result.status {
                self.tblList.reloadData()
            }
        }
    }
    
}
extension SearchVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenType == .fromCreatePost {
            return vmObject.arrList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell") as? SearchItemCell {
            if screenType == .fromCreatePost {
                cell.setDataPolition(vmObject.arrList[indexPath.row],
                                     isSelected: vmObject.arrSelectedId.contains(vmObject.arrList[indexPath.row].id ?? 0))
            }
            else if screenType == .searchTab {
                cell.setDataForSearchTab()
            } else {
                cell.setDataForPublicSearch()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vmObject.arrSelectedId.contains(vmObject.arrList[indexPath.row].id ?? 0) {
            vmObject.arrSelectedId = vmObject.arrSelectedId.filter { id in
                if id != (vmObject.arrList[indexPath.row].id ?? 0) {
                    return true
                }
                return false
            }
        } else {
            vmObject.arrSelectedId.append(vmObject.arrList[indexPath.row].id ?? 0)
        }
        if let cell = tableView.cellForRow(at: indexPath) as? SearchItemCell,
           screenType == .fromCreatePost{
            cell.setDataPolition(vmObject.arrList[indexPath.row],
                                 isSelected: vmObject.arrSelectedId.contains(vmObject.arrList[indexPath.row].id ?? 0))
        }
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
            mackRootView(ProfileVC())
            break
        }
    }
    
    
}
