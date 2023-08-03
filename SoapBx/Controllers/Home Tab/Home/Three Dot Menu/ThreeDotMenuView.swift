//
//  ThreeDotMenuView.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import UIKit

class ThreeDotMenuView: UIControl {
    
    @IBOutlet private weak var tblList: UITableView!
    @IBOutlet private weak var constTblListHeigh: NSLayoutConstraint!
    
    private var arrList: [ThreeDotItemModel] = []
    private var complition: ((ThreeDotItemModel)->())?
    
    static func loadFromNib() -> Self {
       let nib = UINib(nibName: "ThreeDotMenuView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblList.register(["ThreeDotItemCell"], delegate: self, dataSource: self)
        tblList.backgroundColor = .white
        tblList.layer.cornerRadius = 10
        self.layer.cornerRadius = 10
        self.backgroundColor = .black.withAlphaComponent(0.15)
        self.addTarget(self, action: #selector(click_screen), for: .touchUpInside)
    }
    
    func setData(array: [ThreeDotItemModel], complition: @escaping ((ThreeDotItemModel)->())) {
        arrList = array
        self.complition = complition
        tblList.reloadData()
        
        constTblListHeigh.constant =  CGFloat(arrList.count * 50)
    }
    
    @objc private func click_screen() {
        removeFromSuperview()
    }
    
    public func hideSelf() {
        removeFromSuperview()
    }
}
extension ThreeDotMenuView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeDotItemCell") as? ThreeDotItemCell {
            cell.setData(arrList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        complition?(arrList[indexPath.row])
        removeFromSuperview()
    }
}

extension UIView {
    func showThreeDotMenu(array: [ThreeDotItemModel], complition: @escaping ((ThreeDotItemModel)->())) -> ThreeDotMenuView{
        let view = ThreeDotMenuView.loadFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.bounds
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        view.setData(array: array, complition: complition)
        
        return view
    }
}
