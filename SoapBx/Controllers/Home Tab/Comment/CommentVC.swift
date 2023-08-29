//
//  CommentVC.swift
//  SoapBx
//
//  Created by Mac on 13/07/23.
//

import UIKit
import OTLContaner

protocol CommentDelegate {
    func comment(didUpdate object: PostModel?)
}

enum CommentScreenType {
    case fromHome, fromSaved
}

class CommentVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var btnProfileActio: UIControl!
    @IBOutlet private weak var imgProfile: UIImageView!
    
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblPostLocation: UILabel!
    @IBOutlet private weak var lblPostTime: UILabel!
    
    @IBOutlet private weak var lblPostTitle: UILabel!
    @IBOutlet private weak var txtPostDescription: UITextView!
    @IBOutlet private weak var collectionPostImage: UICollectionView!
    @IBOutlet private weak var collectionSoapbx: UICollectionView!
    @IBOutlet private weak var constCollSoapbxTrends: NSLayoutConstraint!
    @IBOutlet private weak var collectionPolitician: UICollectionView!
    @IBOutlet private weak var constCollPolitician: NSLayoutConstraint!
    
    @IBOutlet private weak var viewActionButtons: UIView!
    @IBOutlet private weak var btnLike: OTLPTButton!
    @IBOutlet private weak var btnDislike: OTLPTButton!
    @IBOutlet private weak var btnComment: OTLPTButton!
    @IBOutlet private weak var pageCounter: UIPageControl!
    
    @IBOutlet private weak var tblCommentsList: UITableView!
    @IBOutlet private weak var constCommentsListHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var viewCommentText: UIView!
    @IBOutlet private weak var txtComment: UITextField!
    @IBOutlet private weak var btnSendComment: OTLImageButton!
    
    private var delegate:CommentDelegate?
    private var screenType = CommentScreenType.fromHome
    private let vmObject = CommentViewModel()
    private let vmLikeDislikeObj = LikeDislikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        if self.vmObject.objPost == nil{
            self.navigationController?.popViewController(animated: true)
        }
        setData()
        updateView()
        getPost()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tblCommentsList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionPolitician.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collectionSoapbx.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        tblCommentsList.removeObserver(self, forKeyPath: "contentSize")
        if collectionPolitician.observationInfo != nil {
            collectionPolitician.removeObserver(self, forKeyPath: "contentSize")
        }
        if collectionSoapbx.observationInfo != nil {
            collectionSoapbx.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateCellsLayout()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UITableView,
               object == tblCommentsList {
                if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                    if constCommentsListHeight != nil {
                        constCommentsListHeight?.constant = newsize.height
                    }
                }
            }
            else if let object = object as? UICollectionView {
                if object == collectionPolitician {
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if collectionPolitician != nil {
                            constCollPolitician?.constant = newsize.height
                        }
                    }
                } else if  object == collectionSoapbx{
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constCollSoapbxTrends != nil {
                            constCollSoapbxTrends?.constant = newsize.height
                        }
                    }
                }
            }
        }
    }
    
    private func setupUI(){
        viewHeader.lblTitle.setHeader("")
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        lblProfileName.setTheme("", size: 18, lines: 1)
        lblPostLocation.setTheme("",size: 12)
        lblPostTime.setTheme("", size: 12)
        
        lblPostTitle.setTheme("", color: .primaryBlue, font: .semibold)
        txtPostDescription.text = ""
        txtPostDescription.font = AppFont.regular.font(size: 14)
        txtPostDescription.sizeToFit()
        txtPostDescription.isScrollEnabled = false
        txtPostDescription.isEditable = false
        txtPostDescription.isSelectable = true
        txtPostDescription.dataDetectorTypes = .all
        txtPostDescription.linkTextAttributes = [.foregroundColor:UIColor.primaryBlue]
        txtPostDescription.delegate = self
        
        let snappingLayout = UICollectionViewFlowLayout()
        snappingLayout.scrollDirection = .horizontal
        collectionPostImage.collectionViewLayout = snappingLayout
        collectionPostImage.register(["PostImageItemCell"], delegate: self, dataSource: self)
        let layout1 = OTLTagFlowLayout()
        layout1.spacing = 0
        layout1.padding = 0
        layout1.minimumLineSpacing = 0
        layout1.scrollDirection = .vertical
        layout1.minimumInteritemSpacing = 0
        layout1.estimatedItemSize = CGSize(width: 140, height: 30)
        collectionSoapbx.collectionViewLayout = layout1
        collectionSoapbx.isScrollEnabled = false
        collectionSoapbx.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        let layout2 = OTLTagFlowLayout()
        layout2.spacing = 0
        layout2.padding = 0
        layout2.scrollDirection = .vertical
        layout2.minimumLineSpacing = 0
        layout2.minimumInteritemSpacing = 0
        layout2.estimatedItemSize = CGSize(width: 140, height: 30)
        collectionPolitician.collectionViewLayout = layout2
        collectionPolitician.isScrollEnabled = false
        collectionPolitician.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        
        viewActionButtons.layer.cornerRadius = viewActionButtons.frame.height/2
        viewActionButtons.layer.borderWidth = 0.5
        viewActionButtons.layer.borderColor = UIColor.titleGray.cgColor
        btnLike.title?.setTheme("0", size: 14)
        btnLike.imageView?.image = UIImage(named: "ic_like_grey")?.withRenderingMode(.alwaysTemplate)
        
        btnDislike.title?.setTheme("0", size: 14)
        btnDislike.imageView?.image = UIImage(named: "ic_dislike_grey")?.withRenderingMode(.alwaysTemplate)
        
        btnComment.title?.setTheme("0", size: 14)
        btnComment.imageView?.image = UIImage(named: "ic_comments_grey")
            
        pageCounter.pageIndicatorTintColor = .titleGray
        pageCounter.currentPageIndicatorTintColor = .primaryBlue
        pageCounter.currentPage = 0
        pageCounter.numberOfPages = 0
        
        tblCommentsList.register(["CommentItemCell"], delegate: self, dataSource: self)
        tblCommentsList.isScrollEnabled = false
        
        txtComment.placeholder = LocalStrings.COMMENT_ENTER.rawValue.addLocalizableString()
        viewCommentText.layer.cornerRadius = 10
        viewCommentText.layer.borderWidth = 1
        viewCommentText.layer.borderColor = UIColor.lightGrey.cgColor
        btnSendComment.image = UIImage(named: "ic_commentSend")
    }

    func navigateData(_ object: PostModel, screenType: CommentScreenType , delegate:CommentDelegate){
        self.vmObject.objPost = object
        self.screenType = screenType
        self.delegate = delegate
    }
    func setData() {
        let object = self.vmObject.objPost
        viewHeader.lblTitle.text = object?.user?.name
        
        imgProfile.setImage(object?.user?.profilePhotoURL)
        lblProfileName.text = object?.user?.name
        lblPostLocation.text = getValueOrDefult(object?.user?.location, defaultValue: "N/A")
        lblPostTime.text = OTLDateConvert.instance.convert(date: object?.createdAt ?? "", set: .yyyyMMdd_T_HHmmssDotssZ, getFormat: .mmmDDyyyyAthhmma)
                
        lblPostTitle.text = object?.title
        txtPostDescription.text = object?.description
        
        pageCounter.isHidden = !((object?.images?.count ?? 0) > 1)
        
        if (object?.images?.count ?? 0) > 0 {
            collectionPostImage.isHidden = false
            self.collectionPostImage.reloadData()
            pageCounter.numberOfPages = object?.images?.count ?? 0
        } else {
            collectionPostImage.isHidden = true
        }
        
        if (object?.trendTags?.count ?? 0) > 0 {
            collectionSoapbx.isHidden = false
            self.collectionSoapbx.reloadData()
        } else {
            collectionSoapbx.isHidden = true
        }
        
        if (object?.politicianTags?.count ?? 0) > 0 {
            collectionPolitician.isHidden = false
            self.collectionPolitician.reloadData()
        } else {
            collectionPolitician.isHidden = true
        }
        
        btnLike.title?.text = "\(object?.likeCount ?? 0)"
        btnLike.imageView?.tintColor = object?.likeStatus == 1 ? .primaryBlue : .titleGray
        btnDislike.title?.text = "\(object?.dislikeCount ?? 0)"
        btnDislike.imageView?.tintColor = object?.dislikeStatus == 1 ? .titleRed : .titleGray
        btnComment.title?.text = "\(object?.commentsCount ?? 0)"
    }
    
    //Actions
    @IBAction private func click_btnProfileActio() {
        
    }
    
    @IBAction private func click_btnLike() {
        if authUser?.loginType == .userLogin {
            likeDislikeonPost(isLike: true)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnDislike() {
        if authUser?.loginType == .userLogin {
            likeDislikeonPost(isLike: false)
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    @IBAction private func click_btnSendComment() {
        if authUser?.loginType == .userLogin {
            let validate = txtComment.text?.validateCommentOnPost()
            if validate?.status == false {
                showToast(message: validate?.message ?? "")
            } else {
                self.view.endEditing(true)
                self.postComment()
            }
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
    }
    
    //API calls
   public func paginationManage() {
        if vmObject.currentPage < vmObject.totalPage {
            vmObject.currentPage = vmObject.currentPage + 1
        }
    }
    
        // API Calls
    private func updateView() {
        vmObject.updateViewComplition = {
            self.tblCommentsList.reloadData()
        }
    }
    
    private func getPost() {
        showLoader()
        vmObject.getPost { result in
            hideLoader()
            self.tblCommentsList.reloadData()
            self.collectionPostImage.reloadData()
            self.collectionSoapbx.reloadData()
            self.collectionPolitician.reloadData()
            self.setData()
        }
    }
    
    private func postComment() {
        showLoader()
        vmObject.postComment(comment: txtComment.text ?? "") {[self] result in
            hideLoader()
            self.txtComment.text = ""
            showToast(message: result.message)
            if result.status{
                self.btnComment.title?.text = "\(self.vmObject.objPost?.commentsCount ?? 0)"
                self.tblCommentsList.reloadData()
                self.delegate?.comment(didUpdate: self.vmObject.objPost)
            }
        }
    }
    
    private func reportComment(commentId: Int, reason: String) {
        showLoader()
        vmObject.report(commentId: commentId, reason: reason) { result in
            hideLoader()
            showToast(message: result.message)
        }
    }
    
    private func likeDislikeonPost(isLike: Bool) {
        vmLikeDislikeObj.likeDislike(post: vmObject.objPost!, isLike: isLike) { result, newObject in
            showToast(message: result.message)
            if result.status {
                if let updatedObj = newObject {
                    self.vmObject.objPost = updatedObj
                    self.setData()
                    self.delegate?.comment(didUpdate: updatedObj)
                }
            }
        }
    }
    
}
extension CommentVC: UIScrollViewDelegate {
    func updateCellsLayout()  {
        
        let centerX = collectionPostImage.contentOffset.x + (collectionPostImage.frame.size.width - 10)/2
        for cell in collectionPostImage.visibleCells {
            
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / (view.bounds.width * 2.9)
            let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionPostImage {
            let x = Int(scrollView.contentOffset.x) + 20 + (10*(self.vmObject.objPost?.images?.count ?? 0))
            let w = Int(scrollView.bounds.size.width)
            pageCounter.currentPage = Int(x/w)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionPostImage {
            updateCellsLayout()
        }
    }
}
extension CommentVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vmObject.arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentItemCell") as? CommentItemCell {
            cell.setData(vmObject.arrComments[indexPath.row], indexPath: indexPath, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}
extension CommentVC: CommentItemDelegate{
    func commentItem(_ cell: CommentItemCell, didSelectReport object: CommentModel) {
        if authUser?.loginType == .userLogin {
            self.view.showReportView(comment: object.id ?? 0) { id, report in
                self.reportComment(commentId: id, reason: report)
            }
        } else {
            showAlert(message: LocalStrings.SEARCH_ALERT.rawValue.addLocalizableString(),buttons: [LocalStrings.C_CANCEL.rawValue.addLocalizableString(), LocalStrings.C_LOGIN.rawValue.addLocalizableString()]) { alert in
                if alert.title == LocalStrings.C_LOGIN.rawValue.addLocalizableString() {
                    mackRootView(LoginVC())
                }
            }
        }
        
    }
}


extension CommentVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionPostImage {
            return self.vmObject.objPost?.images?.count ?? 0
        } else if collectionView == collectionPolitician {
            return self.vmObject.objPost?.politicianTags?.count ?? 0
        } else {
            return self.vmObject.objPost?.trendTags?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionPostImage,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageItemCell", for: indexPath) as? PostImageItemCell {
            if let obj = self.vmObject.objPost?.images?[indexPath.row] {
                cell.setData(obj, indexPath: indexPath)
                return cell
            }
        }
        else if collectionView == collectionSoapbx,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            if let obj = self.vmObject.objPost?.trendTags?[indexPath.row] {
                cell.setDataSoapbx(obj)
                return cell
            }
            
        }
        else if collectionView == collectionPolitician,
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell {
            if let obj = self.vmObject.objPost?.politicianTags?[indexPath.row] {
                cell.setDataPolitician(obj)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
}
extension CommentVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionPostImage {
            return CGSize(width: collectionView.frame.width , height: collectionView.frame.width )
        }
        else if collectionView == collectionSoapbx,
                 (self.vmObject.objPost?.trendTags?.count ?? 0) > 0{
            let text = self.vmObject.objPost?.trendTags?[indexPath.row].trend?.name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 12)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 30)
            }
            else {
                return CGSize(width: width, height: 30)
            }
        }else if collectionView == collectionPolitician,
                 (self.vmObject.objPost?.politicianTags?.count ?? 0) > 0{
            let text = self.vmObject.objPost?.politicianTags?[indexPath.row].politician?.name ?? ""
            let width = text.size(OfFont: AppFont.regular.font(size: 12)).width + 20
            if width < 55 {
                return CGSize(width: 55, height: 30)
            }
            else {
                return CGSize(width: width, height: 30)
            }
        }
        return CGSize()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension CommentVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        printLog("[HomeItemCell] shouldInteractWith")
        return false
    }
}
