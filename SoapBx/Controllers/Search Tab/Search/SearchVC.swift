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
    var id: Int {
        switch self {
            case .searchTab:            return 1
            case .fromPublicFigures:    return 2
            case .fromCreatePost:       return 3
        }
    }
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
    
    private var screenType = SearchScreenType.searchTab {
        didSet { vmObject.screenType = screenType }
    }
    private let vmPublic = PublicFiguresViewModel()
    private let vmObject = SearchViewModel()
    private var delegate:SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if screenType == .fromCreatePost{
            getPoliticians()
        }
        else if screenType == .fromPublicFigures {
            userSearchHistory()
        }
        else {
            userSearchHistory()
        }
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
        vmObject.isPagenationActive = false
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
        searchView.imageView?.tintColor = .titleGray
        
        txtSearch.font = AppFont.regular.font(size: 16)
        txtSearch.addTarget(self, action: #selector(searchEditingChanged(_:)), for: .editingChanged)
        txtSearch.addTarget(self, action: #selector(searchEditingDidBegin(_:)), for: .editingDidBegin)
        
        tblList.register(["SearchItemCell"], delegate: self, dataSource: self)
        viewBottomButton.isHidden = true
        
        btnDone.appButton("Done")
        
        if screenType == .fromCreatePost {
            viewHeader.lblTitle.text = "Public Figures"
            viewBottomButton.isHidden = false
        }
        updateList()
    }
    
    
    @objc private func searchEditingChanged(_ textField: UITextField) {
        if screenType == .fromPublicFigures {
            vmPublic.searchString = textField.text ?? ""
        } else {
            vmObject.searchString = txtSearch.text ?? ""
        }
    }
    
    @objc private func searchEditingDidBegin(_ textField: UITextField) {
        if screenType == .fromPublicFigures {
            vmPublic.searchString = ""
            getPoliticiansSearch()
        } else {
            vmObject.searchString = ""
            searchString()
        }
    }
    
    @IBAction private func click_btnDone() {
        if screenType == .fromCreatePost {
            let selectedUser: [PostUser] = vmObject.arrList.compactMap { user in
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
    private func updateList() {
        vmPublic.updateViewComplition = {
            hideLoader()
            self.tblList.reloadData()
        }
        
        vmObject.updateViewComplition = {
            hideLoader()
            self.tblList.reloadData()
        }
    }
    
    private func searchString() {
        showLoader()
        vmObject.userSearch { result in
            hideLoader()
            if result.status {
                self.tblList.reloadData()
            }
        }
    }
    
    private func getPoliticians() {
        showLoader()
        vmObject.getPolitician { result in
            hideLoader()
            if result.status {
                self.tblList.reloadData()
            }
        }
    }

    private func getPoliticiansSearch() {
        showLoader()
        vmPublic.politicianList { result in
            hideLoader()
            if result.status {
                self.tblList.reloadData()
            }
        }
    }

    
    private func userSearchHistory() {
        showLoader()
        vmObject.userSearchHistory { result in
            hideLoader()
            if result.status {
                self.tblList.reloadData()
            }
        }
    }
    
    private func clearHistory(indexPath: IndexPath) {
        showLoader()
        vmObject.clearHistory(user: vmObject.arrList[indexPath.row].id ?? 0) {[self] result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                vmObject.arrList.remove(at: indexPath.row)
                tblList.reloadData()
            }
        }
    }
    
    private func saveHistory(indexPath: IndexPath) {
        var user: PostUser?
        if screenType == .fromPublicFigures{
            user = vmPublic.arrList[indexPath.row]
        }
        else if screenType == .searchTab {
            user = vmObject.arrSearchList[indexPath.row]
        }
        guard user?.id != authUser?.user?.id else { return }
        showLoader()
        vmObject.saveHistory(user: user?.id ?? 0) {[self] result in
            hideLoader()
            showToast(message: result.message)
//            if result.status {
                if self.screenType == .fromPublicFigures {
                    if self.vmPublic.arrList.count >= (indexPath.row + 1) {
                        txtSearch.text = ""
                        self.vmPublic.searchString = ""
                        tblList.reloadData()
                        
                        self.vmObject.arrList.append(self.vmPublic.arrList[indexPath.row])
                        let vc = PoliticianProfileVC()
                        vc.navigation(self.vmPublic.arrList[indexPath.row], indexPath: indexPath, delegate: self)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else if self.screenType == .searchTab {
                    if self.vmObject.arrSearchList.count >= (indexPath.row + 1) {
                        txtSearch.text = ""
                        self.vmObject.searchString = ""
                        tblList.reloadData()
                        
                        self.vmObject.arrList.append(self.vmObject.arrSearchList[indexPath.row])
                        let vc = ProfileVC()
                        vc.navigateForOtherUser(self.vmObject.arrSearchList[indexPath.row])
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
//            }
        }
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenType == .fromCreatePost {
            return vmObject.arrList.count
        }
        else if screenType == .fromPublicFigures , vmPublic.isSearch == false{
            return vmObject.arrList.count
        }
        else if screenType == .fromPublicFigures, vmPublic.isSearch {
            return vmPublic.arrList.count
        }
        else if screenType == .searchTab{
            return vmObject.isSearch ? vmObject.arrSearchList.count : vmObject.arrList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell") as? SearchItemCell {
            cell.indexPath = indexPath
            if screenType == .fromCreatePost {
                cell.setDataPolition(vmObject.arrList[indexPath.row],
                                     isSelected: vmObject.arrSelectedId.contains(vmObject.arrList[indexPath.row].id ?? 0))
            }
            else if screenType == .searchTab {
                cell.setDataForPublicSearch(vmObject.isSearch ? vmObject.arrSearchList[indexPath.row] : vmObject.arrList[indexPath.row] ,
                                            isFromSearch: vmObject.isSearch ,
                                            delegate: self)
            } else if screenType == .fromPublicFigures , vmPublic.isSearch == false{
                cell.setDataForPublicSearch(vmObject.arrList[indexPath.row], isFromSearch: false, delegate:  self)
            }
            else if screenType == .fromPublicFigures, vmPublic.isSearch {
                cell.setDataForPublicSearch(vmPublic.arrList[indexPath.row], isFromSearch: true, delegate:  self)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if screenType == .fromCreatePost {
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
        else if screenType == .fromPublicFigures, self.vmPublic.isSearch == false{
            txtSearch.text = ""
            self.vmObject.searchString = ""
            let vc = PoliticianProfileVC()
            vc.navigation(self.vmObject.arrList[indexPath.row], indexPath: indexPath, delegate: self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.screenType == .fromPublicFigures, self.vmPublic.isSearch {
            if self.vmObject.arrList.contains(where: { user in
                user.id == self.vmPublic.arrList[indexPath.row].id
            }) {
                txtSearch.text = ""
                self.vmObject.searchString = ""
                let vc = PoliticianProfileVC()
                vc.navigation(self.vmPublic.arrList[indexPath.row], indexPath: indexPath, delegate: self)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                saveHistory(indexPath: indexPath)
            }
        }
        else if screenType == .searchTab, self.vmObject.isSearch == false{
            txtSearch.text = ""
            self.vmObject.searchString = ""
            guard self.vmObject.arrList[indexPath.row].id != authUser?.user?.id else { return }
            let vc = ProfileVC()
            vc.navigateForOtherUser(self.vmObject.arrList[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.screenType == .searchTab, self.vmObject.isSearch {
            if self.vmObject.arrList.contains(where: { user in
                user.id == self.vmObject.arrSearchList[indexPath.row].id
            }) {
                txtSearch.text = ""
                self.vmObject.searchString = ""
                guard self.vmObject.arrSearchList[indexPath.row].id != authUser?.user?.id else { return }
                let vc = ProfileVC()
                vc.navigateForOtherUser(self.vmObject.arrSearchList[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                saveHistory(indexPath: indexPath)
            }
        }
    }
}
extension SearchVC: SearchItemDelegate {
    
    func searchItem(_ cell: SearchItemCell, didSelectAction object: PostUser) {
        if screenType == .fromPublicFigures, vmPublic.isSearch == false{
            clearHistory(indexPath: cell.indexPath)
        }
        else if screenType == .searchTab, vmObject.isSearch == false {
            clearHistory(indexPath: cell.indexPath)
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
                navigationController?.pushViewController(CreatePostVC(), animated: true)
            break
        case .search:
            break
        case .profile:
            mackRootView(ProfileVC())
            break
        }
    }
    
    
}
extension SearchVC: PoliticianProfileDelegate{
    func politicianProfile(didUpadate user: PostUser, at indexPath: IndexPath) {
        
    }
}
