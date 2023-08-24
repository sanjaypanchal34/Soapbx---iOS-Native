//
//  Extantion_UILabel.swift
//  SoapBx
//
//  Created by Mac on 04/07/23.
//

import UIKit
import OTLContaner
import Photos

extension UILabel {
    
    func setHeader(_ text: String) {
        self.text = text
        self.textColor = .titleBlack
        self.font = AppFont.medium.font(size: 20)
        self.numberOfLines = 1
    }
    
    func setTheme(_ text: String,
                  color: UIColor = .titleBlack,
                  font: AppFont = .regular,
                  size: CGFloat = 16, lines: Int = 3) {
        self.text = text
        self.textColor = color
        self.font = font.font(size: size)
        self.numberOfLines = lines
    }
    
    func noDataTitle(_ text: String) {
        setTheme(text,color: .titleGray, font: .bold, size: 22)
        textAlignment = .center
    }
}
extension OTLTextButton {
    func setTheme(_ text: String,
                  color: UIColor = .titleBlack,
                  font: AppFont = .regular,
                  size: CGFloat = 14,
                  background: UIColor = .clear) {
        self.text = text
        self.textColor = color
        self.font = font.font(size: size)
        self.backgroundColor = background
    }

    func appButton(_ text: String) {
        self.text = text
        self.textColor = .white
        self.font = AppFont.semibold.font(size: 20)
        self.backgroundColor = .primaryBlue
        self.layer.cornerRadius = 10
        
        for cons in self.constraints {
            if cons.firstAttribute == .height , cons.relation == .equal {
                cons.constant = 50
            }
        }
    }
}
extension UIButton {
    
    func emptyTitle(){
        self.setTitle("", for: .normal)
    }
    
    func appButton(_ text: String) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = AppFont.medium.font(size: 14)
        self.backgroundColor = .primaryBlue
        self.layer.cornerRadius = 10
        
        for cons in self.constraints {
            if cons.firstAttribute == .height , cons.relation == .equal {
                cons.constant = 50
            }
        }
    }
    
    func setTheme(_ text: String,
                  color: UIColor = .white,
                  font: AppFont = .regular,
                  size: CGFloat = 14,
                  backgound: UIColor = .clear) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font.font(size: size) 
        self.backgroundColor = backgound
    }
}

extension OTLTextField {
    
    func setTheme(_ text: String = "",
                  placeholder: String,
                  color: UIColor = .titleBlack,
                  font: AppFont = .regular,
                  size: CGFloat = 16,
                  leftIcon:UIImage? = nil,
                  leftSelectedIcon:UIImage? = nil,
                  backgound: UIColor = .primaryBlue) {
        self.text = text
        self.placeholder = placeholder
        self.color = color
        self.font = font.font(size: size)
        self.leftIcon = leftIcon
        self.leftSelectedIcon = leftSelectedIcon
        self.borderActiveColor = backgound
    }
}

extension OTLCountryCode {
    
    func setTheme(_ text: String = "",
                  placeholder: String,
                  defultCode:Int = 91,
                  color: UIColor = .titleBlack,
                  font: AppFont = .regular,
                  size: CGFloat = 16,
                  leftIcon:UIImage? = nil,
                  leftSelectedIcon:UIImage? = nil,
                  backgound: UIColor = .primaryBlue) {
        self.text = text
        self.placeholder = placeholder
        self.color = color
        self.font = font.font(size: size)
        self.leftIcon = leftIcon
        self.leftSelectedIcon = leftSelectedIcon
        self.borderActiveColor = backgound
    }
}

extension OTLPasswordField {
    
    func setTheme(_ text: String = "",
                  placeholder: String,
                  color: UIColor = .titleBlack,
                  font: AppFont = .regular,
                  size: CGFloat = 16,
                  backgound: UIColor = .primaryBlue) {
        self.text = text
        self.placeholder = placeholder
        self.color = color
        self.font = font.font(size: size)
        self.leftIcon = UIImage(named: "ic_lock")
        self.rightIcon = UIImage(named: "ic_eye")
        self.rightSelectedIcon = UIImage(named: "ic_closeEye")
        self.borderActiveColor = backgound
    }
}
extension OTLOTPView {
    func setOTPTheme() {
        self.textColor = .titleBlack
        self.font = AppFont.regular.font(size: 16)
        self.borderColor = .primaryBlue
        self.backgroundColor = .primaryBlue.withAlphaComponent(0.05)
        self.prefill = "-"
    }
}

extension UICollectionView {
    func register(_ reuseIdentifiers: [String], delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        for id in reuseIdentifiers {
            self.register(UINib(nibName: id, bundle: nil), forCellWithReuseIdentifier: id)
        }
        self.backgroundColor = .clear
        self.delegate = delegate
        self.dataSource = dataSource
    }
}

extension UITableView {
    func register(_ reuseIdentifiers: [String], delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        for id in reuseIdentifiers {
            self.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
        }
        self.separatorStyle = .none
        self.backgroundColor = .clear
        self.delegate = delegate
        self.dataSource = dataSource
    }
}


class AppCollectionViewCell: UICollectionViewCell {
    var index: OTLIndex = OTLIndex()
    var indexPath: IndexPath = IndexPath()
}

class AppTableViewCell: UITableViewCell {
    
    @IBOutlet public weak var viewMain:UIView!
    
    var index: OTLIndex = OTLIndex()
    var indexPath: IndexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
}

extension OTLBottomTabBar {
    func setTabTheme() {
        imageHome = UIImage(named: "ic_home")!
        imagePublicFigures = UIImage(named: "ic_speech")!
        imageAddPost = UIImage(named: "ic_plus")!
        imageSearch = UIImage(named: "ic_search")!
        imageProfile = UIImage(named: "ic_user")!
        backgroundColor = .white
        tintColor = .titleBlack
        tintSelectedColor = .primaryBlue
    }
}
extension UIView {
    var rootViewController: UINavigationController {
        get{
            if let navigation = self.window?.rootViewController as? UINavigationController {
                return navigation
            } else {
                return (self.window?.rootViewController?.navigationController)!
            }
        }
    }
}

public extension PHPhotoLibrary {
    static func execute(controller: UIViewController,
                        onAccessHasBeenGranted: @escaping () -> Void,
                        onAccessHasBeenDenied: (() -> Void)? = nil) {
        
        let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
            let alert = UIAlertController(
                title: "We were unable to load your album groups. Sorry!",
                message: "You can enable access in Privacy Settings",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
            controller.present(alert, animated: true)
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)
        case .denied, .restricted:
            DispatchQueue.main.async { onDeniedOrRestricted()}
        case .authorized:
            DispatchQueue.main.async {onAccessHasBeenGranted() }
        case .limited:
            DispatchQueue.main.async { onAccessHasBeenGranted()}
        @unknown default:
            fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }
        
        
    }
    
    
    private static func onNotDetermined(_ onDeniedOrRestricted: @escaping (()->Void), _ onAuthorized: @escaping (()->Void)) {
        
        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization({ status in
                switch status {
                case .notDetermined:
                    self.onNotDetermined(onDeniedOrRestricted, onAuthorized)
                case .denied, .restricted:
                    onDeniedOrRestricted()
                case .authorized:
                    onAuthorized()
                case .limited:
                    onAuthorized()
                @unknown default:
                    fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
                }
            })
        }
        
    }
}
extension NSNotification.Name{
    
    static let homePostUpdate = NSNotification.Name("OTL_homePostUpdate")
    static let savePostUpdate = NSNotification.Name("OTL_savePostUpdate")
}

extension String {
    func addLocalizableString() -> String {
//        let lang = UserDefaults.standard.string(forKey: AppConstants.LANGUAGE) ?? "en"
        let lang = "en"
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
