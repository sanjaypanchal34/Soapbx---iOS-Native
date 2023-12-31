//
//  PostPollsVC.swift
//  SoapBx
//
//  Created by Mac on 22/07/23.
//

import UIKit
import OTLContaner

enum PostPollsScreenType {
    case post, update
}

class PostPollsVC: UIViewController {
    
    @IBOutlet private weak var viewHeader: OTLHeader!
    
    @IBOutlet private weak var viewBody: UIView!
    
    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var lblProfileName: UILabel!
    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var lblTime: UILabel!
    
    @IBOutlet private weak var viewTitle: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var txtTitle: UITextField!
    
    @IBOutlet private weak var viewStartDate: UIView!
    @IBOutlet private weak var lblStartDate: UILabel!
    @IBOutlet private weak var txtStartDate: OTLDatePicker!
    
    @IBOutlet private weak var viewEndDate: UIView!
    @IBOutlet private weak var lblEndDate: UILabel!
    @IBOutlet private weak var txtEndDate: OTLDatePicker!
    
    @IBOutlet private weak var tblOptions: UITableView!
    @IBOutlet private weak var constOptionsHeight: NSLayoutConstraint!
    @IBOutlet private weak var btnAddOptions: OTLTextButton!
    
    @IBOutlet private weak var viewSoapbxTrends: UIView!
    @IBOutlet private weak var lblSoapbxTrends: UILabel!
    @IBOutlet private weak var collSoapbxTrends: UICollectionView!
    @IBOutlet private weak var constCollSoapbxTrends: NSLayoutConstraint!
    
    @IBOutlet private weak var btnPost: OTLTextButton!
    
    // private
    private let vmTrends = YouInterestedViewModel()
    private let vmObject = PollsViewModel()
    
    // public
    var screenType = PostPollsScreenType.post
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getTrends()
    }
    override func viewWillAppear(_ animated: Bool) {
        tblOptions.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        collSoapbxTrends.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        tblOptions.removeObserver(self, forKeyPath: "contentSize")
        collSoapbxTrends.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let object = object as? UITableView{
                if object == tblOptions {
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constOptionsHeight != nil {
                            constOptionsHeight?.constant = newsize.height
                        }
                    }
                }
            }
            if let object = object as? UICollectionView {
                if  object == collSoapbxTrends{
                    if let newvalue = change?[.newKey], let newsize  = newvalue as? CGSize{
                        if constCollSoapbxTrends != nil {
                            constCollSoapbxTrends?.constant = newsize.height
                        }
                    }
                }
            }
        }
    }
    
    private func setupUI() {
        viewHeader.lblTitle.setHeader("")
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.setImage(authUser?.user?.profile_photo_url)
        imgProfile.contentMode = .scaleAspectFill
        lblProfileName.setTheme(authUser?.user?.name ?? "", lines: 1)
        lblLocation.setTheme(getValueOrDefult(authUser?.user?.location, defaultValue: "N/A"), color: .titleGray, size: 10)
        lblTime.setTheme(OTLDateConvert.instance.convert(date: Date(), toString: .mmmDDyyyyAthhmma), color: .titleGray, size: 12)
        
        lblTitle.setTheme(LocalStrings.POLL_QUESTION.rawValue.addLocalizableString(), color: .primaryBlue, font: .bold)
        txtTitle.placeholder = LocalStrings.POLL_QUESTION_P.rawValue.addLocalizableString()
        txtTitle.font = AppFont.regular.font(size: 16)
        
        lblStartDate.setTheme(LocalStrings.POLL_START_DATE.rawValue.addLocalizableString(), color: .primaryBlue, font: .bold)
        txtStartDate.placeholder = LocalStrings.POLL_START_DATE_P.rawValue.addLocalizableString()
        txtStartDate.font = AppFont.regular.font(size: 16)
        txtStartDate.minDate = Date()
        txtStartDate.datePickerMode = .dateAndTime
        txtStartDate.formate = .yyyyMMdd_hhmma
        txtStartDate.datetimeDelegate = self
        
        lblEndDate.setTheme(LocalStrings.POLL_END_DATE.rawValue.addLocalizableString(), color: .primaryBlue, font: .bold)
        txtEndDate.placeholder = LocalStrings.POLL_END_DATE_P.rawValue.addLocalizableString()
        txtEndDate.font = AppFont.regular.font(size: 16)
        txtEndDate.datePickerMode = .dateAndTime
        txtEndDate.formate = .yyyyMMdd_hhmma
        txtEndDate.isUserInteractionEnabled = false
        
        tblOptions.register(["PostPollsItemCell"], delegate: self, dataSource: self)
        btnAddOptions.setTheme(LocalStrings.POLL_ADD_OPTION.rawValue.addLocalizableString(), font: .semibold)
        btnAddOptions.textAlignment = .right
        
        lblSoapbxTrends.setTheme(LocalStrings.C_POST_ADD_TREND.rawValue.addLocalizableString(), color: .primaryBlue, font: .bold)
        collSoapbxTrends.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        collSoapbxTrends.semanticContentAttribute = .forceLeftToRight
//        collSoapbxTrends.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        let layout1 = OTLTagFlowLayout()
        layout1.spacing = 0
        layout1.padding = 0
//        layout1.snapPosition = .left
        layout1.minimumLineSpacing = 0
        layout1.scrollDirection = .vertical
        layout1.minimumInteritemSpacing = 0
        layout1.estimatedItemSize = CGSize(width: 140, height: 30)
        collSoapbxTrends.collectionViewLayout = layout1
        
        for view in [viewTitle, viewStartDate, viewEndDate] {
            view?.backgroundColor = .white
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGrey.cgColor
        }
        
        btnPost.appButton(screenType == .update ? LocalStrings.C_POST_UPDATE.rawValue.addLocalizableString() : LocalStrings.C_POST.rawValue.addLocalizableString())
        updateButtonOnAddItem()
    }
    
    //
    private func updateButtonOnAddItem() {
        vmObject.complitionOnAddOptions = { [self] in
            if vmTrends.arrList.count < vmObject.intMaxOptions {
                btnAddOptions.isHidden = false
            } else {
                btnAddOptions.isHidden = true
            }
            collSoapbxTrends.reloadData()
        }
    }
    // Buttons Actions
    @IBAction private func click_addOptions() {
        vmObject.arrOptions.append("")
        tblOptions.reloadData()
    }
    
    @IBAction private func click_postPolls() {
        self.view.endEditing(true)
        let validateOptions1 = vmObject.arrOptions[0].validatePollOptions("1")
        let validateOptions2 = vmObject.arrOptions[1].validatePollOptions("2")
        
        
        if let validate = txtTitle.text?.validateQuestion(),
           validate.status == false {
            showToast(message: validate.message)
        }
        else if let validate = txtStartDate.text?.validateStartDate(),
                  validate.status == false {
            showToast(message: validate.message)
        }
        else if let validate = txtEndDate.text?.validateEndDate(),
                  validate.status == false {
            showToast(message: validate.message)
        }
        else if validateOptions1.status == false{
            showToast(message: validateOptions1.message)
        }
        else if validateOptions2.status == false {
            showToast(message: validateOptions2.message)
        }
        else {
            postPolls()
        }
    }
    
    // API calls
    
    private func getTrends() {
        showLoader()
        vmTrends.getTrends { result in
            hideLoader()
            if result.status {
                self.collSoapbxTrends.reloadData()
            }
        }
    }
    
    private func postPolls() {
        showLoader()
        vmObject.postPoll(question: txtTitle.text ?? "", start: txtStartDate.selectedItem!, end: txtEndDate.selectedItem!) { result in
            hideLoader()
            showToast(message: result.message)
            if result.status {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension PostPollsVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = (vmTrends.arrList[indexPath.row].name ?? "").replacingOccurrences(of: " ", with: "20%")
            let width = text.size(OfFont: AppFont.regular.font(size: 10)).width + 15
        if width < 55 {
            return CGSize(width: 55, height: 30)
        }
        else {
            return CGSize(width: width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if vmObject.isTredSelected(id: vmTrends.arrList[indexPath.row].id ?? 0) {
            vmObject.selectedTred = vmObject.selectedTred.filter({ tred in
                (tred.id ?? 0) != (vmTrends.arrList[indexPath.row].id ?? 0)
            })
        } else {
            vmObject.selectedTred.append(vmTrends.arrList[indexPath.row])
        }
    }
}
extension PostPollsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return vmTrends.arrList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell{
           cell.setPollsTrends(vmTrends.arrList[indexPath.row], isSelected: vmObject.isTredSelected(id: vmTrends.arrList[indexPath.row].id ?? 0))
//           cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
extension PostPollsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  vmObject.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostPollsItemCell") as? PostPollsItemCell {
            cell.indexPath = indexPath
            let isLastIndex = vmObject.arrOptions.count == vmObject.intMinOptions ? false : (vmObject.arrOptions.count == (indexPath.row + 1) ? true : false)
            cell.setData(text: vmObject.arrOptions[indexPath.row], isLastIndex: isLastIndex, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}

extension PostPollsVC : OTLDatePickerDelegate {
    func dateTime(_ dateTime: OTLContaner.OTLDatePicker, onSelected date: Date) {
        txtEndDate.isUserInteractionEnabled = true
        txtEndDate.selectedItem = nil
        txtEndDate.minDate = date
    }
}
extension PostPollsVC : PostPollsItemDelegate {
    func postPollsItem(_ cell: PostPollsItemCell, didUpdateText: String) {
        vmObject.arrOptions[cell.indexPath.row] = didUpdateText
    }
    
    func postPollsItem(_ cell: PostPollsItemCell, didTabDelete: Void) {
        cell.text = ""
        vmObject.arrOptions.remove(at: cell.indexPath.row)
        tblOptions.reloadData()
    }
}
