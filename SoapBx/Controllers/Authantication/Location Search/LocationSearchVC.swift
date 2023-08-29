//
//  LocationSearchVC.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit

protocol LocationSearchDelegate {
    func locationSearch(_ controller:LocationSearchVC, didSelect: GMapResult )
}

class LocationSearchVC: UIViewController {

    @IBOutlet private weak var viewBody: UIView!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var btnDone: UIButton!
    
    @IBOutlet private weak var txtSearch: UITextField!
    @IBOutlet private weak var tblSearch: UITableView!
    
    var delegate: LocationSearchDelegate?
    private var arrSearch: [GMapResult] = []
    private var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
        
        txtSearch.placeholder = LocalStrings.P_LOCATION.rawValue.addLocalizableString()
        txtSearch.font = AppFont.regular.font(size: 16)
        txtSearch.delegate = self
        txtSearch.clearButtonMode = .whileEditing
        
        btnCancel.setTheme(LocalStrings.C_CANCEL.rawValue.addLocalizableString(), color: .titleBlack, size: 16)
        btnDone.setTheme(LocalStrings.C_DONE.rawValue.addLocalizableString(), color: .primaryBlue, font: .bold, size: 16)
        
        tblSearch.register(["LocationItemCell"], delegate: self, dataSource: self)
    }
    
    private func searchLocation(_ text: String) {
        index = -1
        googleMapSearch(text) { result in
            if result.results.count > 0 {
                self.arrSearch = result.results
                self.tblSearch.reloadData()
            }else {
                self.arrSearch = []
                self.tblSearch.reloadData()
            }
        }
    }

    
    
    // private
    @IBAction private func click_btnCancel() {
        dismiss(animated: true)
    }
    
    @IBAction private func click_btnDone() {
        if index > -1 {
            delegate?.locationSearch(self, didSelect: arrSearch[index])
        }
        dismiss(animated: true)
    }
}
extension LocationSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationItemCell") as? LocationItemCell {
            cell.setData(arrSearch[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        click_btnDone()
    }
}
extension LocationSearchVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        index = -1
        if txtAfterUpdate.count > 2 {
            searchLocation(txtAfterUpdate)
        } else {
            arrSearch = []
            self.tblSearch.reloadData()
        }
        
        return true
    }
}
