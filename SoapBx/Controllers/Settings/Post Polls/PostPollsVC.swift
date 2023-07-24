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
    private var arrSoapbxTrends = [ "Think Talk", "Circular Economy", "Global Affairs"]
    private var arrOptions:[String] = ["","",""] {
        didSet {
            if arrOptions.count < intMaxOptions {
                btnAddOptions.isHidden = false
            } else {
                btnAddOptions.isHidden = true
            }
        }
    }
    private let intMinOptions = 2
    private let intMaxOptions = 15
    
    // public
    var screenType = PostPollsScreenType.post
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        imgProfile.image = UIImage(named: "profile_Three")
        imgProfile.contentMode = .scaleAspectFill
        lblProfileName.setTheme("Robert Watson")
        lblLocation.setTheme("Ahmedabad, Gujarat, India",size: 8)
        lblTime.setTheme("Jul 16 2023 @ 09:02 PM",size: 12)
        
        lblTitle.setTheme("Question", color: .primaryBlue, font: .bold)
        txtTitle.placeholder = "What do you want the public to vote on?"
        txtTitle.font = AppFont.regular.font(size: 16)
        
        lblStartDate.setTheme("Start Date", color: .primaryBlue, font: .bold)
        txtStartDate.placeholder = "What do you want your poll to be open for voting?"
        txtStartDate.font = AppFont.regular.font(size: 16)
        txtStartDate.minDate = Date()
        txtStartDate.datetimeDelegate = self
        
        lblEndDate.setTheme("End Date", color: .primaryBlue, font: .bold)
        txtEndDate.placeholder = "What do you want your poll to be closed from voting?"
        txtEndDate.font = AppFont.regular.font(size: 16)
        txtEndDate.isUserInteractionEnabled = false
        
        tblOptions.register(["PostPollsItemCell"], delegate: self, dataSource: self)
        btnAddOptions.setTheme("+ Add Option", font: .semibold)
        btnAddOptions.textAlignment = .right
        
        lblSoapbxTrends.setTheme("Soapbx trends", color: .primaryBlue, font: .bold)
        collSoapbxTrends.register(["PostItemPoliticalCell"], delegate: self, dataSource: self)
        collSoapbxTrends.collectionViewLayout = createLeftAlignedLayout()
        
        for view in [viewTitle, viewStartDate, viewEndDate] {
            view?.backgroundColor = .white
            view?.layer.cornerRadius = 10
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.lightGrey.cgColor
        }
        
        btnPost.appButton(screenType == .update ? "Update" : "Post")
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
      let item = NSCollectionLayoutItem(          // this is your cell
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .estimated(70),         // variable width
          heightDimension: .absolute(40)          // fixed height
        )
      )
      
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
          heightDimension: .estimated(50)         // variable height; allows for multiple rows of items
        ),
        subitems: [item]
      )
      group.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
      group.interItemSpacing = .fixed(10)         // horizontal spacing between cells
        group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(2), trailing: .fixed(0), bottom: .fixed(2))
      return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
    
    @IBAction private func click_addOptions() {
        arrOptions.append("")
        tblOptions.reloadData()
    }
}
extension PostPollsVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let text = arrSoapbxTrends[indexPath.row]
            let width = text.size(OfFont: AppFont.regular.font(size: 14)).width
            return CGSize(width: width + 20, height: collectionView.frame.height)
    }
}
extension PostPollsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrSoapbxTrends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemPoliticalCell", for: indexPath) as? PostItemPoliticalCell{
            cell.setCreatePost(arrSoapbxTrends[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}
extension PostPollsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostPollsItemCell") as? PostPollsItemCell {
            cell.indexPath = indexPath
            let isLastIndex = arrOptions.count == intMinOptions ? false : (arrOptions.count == (indexPath.row + 1) ? true : false)
            cell.setData(text: arrOptions[indexPath.row], isLastIndex: isLastIndex, delegate: self)
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
        arrOptions[cell.indexPath.row] = didUpdateText
    }
    
    func postPollsItem(_ cell: PostPollsItemCell, didTabDelete: Void) {
        cell.text = ""
        arrOptions.remove(at: cell.indexPath.row)
        tblOptions.reloadData()
    }
    
    
}
