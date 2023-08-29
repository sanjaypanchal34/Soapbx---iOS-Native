//
//  EnableLocationVC.swift
//  SoapBx
//
//  Created by Mac on 08/07/23.
//

import UIKit
import CoreLocation

class EnableLocationVC: UIViewController  {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var btnSkip: UIButton!
    
    private var locationManager: CLLocationManager?
    private var placeName: String = ""{
        willSet {
            showLoader()
        }
        didSet {
            if oldValue.isEmptyString {
                
                showToast(message: String(format: "%@%@", LocalStrings.E_MESSAGE.rawValue.addLocalizableString(), placeName))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    mackRootView(HomeVC())
                    hideLoader()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
        // Do any additional setup after loading the view.
    }

    //MARK: - Setup view
    private func setupUI() {
        lblTitle.setTheme(LocalStrings.E_TITLE.rawValue.addLocalizableString(),
                          font: .bold,
                          size: 40)
        
        lblDescription.setTheme(LocalStrings.E_DESC.rawValue.addLocalizableString(), color: .titleGray, font: .regular, size: 14)
        
        btnNext.appButton(LocalStrings.E_ENABLE.rawValue.addLocalizableString())
        btnSkip.setTheme(LocalStrings.E_SKIP.rawValue.addLocalizableString(), color: .titleGray)
        
    }
    
    //Actions
    @IBAction private func click_btnNext() {
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager?.startUpdatingLocation()
                    locationManager?.startMonitoringSignificantLocationChanges()
                    break
                    
                case .notDetermined:
                    showAlert(message: LocalStrings.E_NOT_DETERMINE.rawValue.addLocalizableString(), buttons:[LocalStrings.C_OPEN.rawValue.addLocalizableString(), LocalStrings.C_CANCEL.rawValue.addLocalizableString()]) { alert in
                        if alert.title == LocalStrings.C_OPEN.rawValue.addLocalizableString() {
                            if let url = URL(string:UIApplication.openSettingsURLString)
                            {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                    break
                    
                case .restricted:
                    showAlert(message: LocalStrings.E_NOT_DETERMINE.rawValue.addLocalizableString(), buttons:[LocalStrings.C_OPEN.rawValue.addLocalizableString(), LocalStrings.C_CANCEL.rawValue.addLocalizableString()]) { alert in
                        if alert.title == LocalStrings.C_OPEN.rawValue.addLocalizableString() {
                            if let url = URL(string:UIApplication.openSettingsURLString)
                            {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                    break
                    
                case .denied:
                    locationManager?.requestWhenInUseAuthorization()
                    showAlert(message: LocalStrings.E_NOT_DETERMINE.rawValue.addLocalizableString(), buttons:[LocalStrings.C_OPEN.rawValue.addLocalizableString(), LocalStrings.C_CANCEL.rawValue.addLocalizableString()]) { alert in
                        if alert.title == LocalStrings.C_OPEN.rawValue.addLocalizableString() {
                            if let url = URL(string:UIApplication.openSettingsURLString)
                            {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                default:
                    break
                    
            }
        }

    }
    
    @IBAction private func click_skipNow() {
        mackRootView(HomeVC())
    }
}
extension EnableLocationVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopMonitoringSignificantLocationChanges()
        authUser?.user?.longitude = locations.first?.coordinate.longitude ?? 0
        authUser?.user?.latitude = locations.first?.coordinate.latitude ?? 0
        authUser?.updateProfile()
        
        locations.first?.placemark(completion: { placemark, error in
            self.placeName = (placemark?.locality ?? "") + ", " + (placemark?.country ?? "")
        })
    }
}
extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
