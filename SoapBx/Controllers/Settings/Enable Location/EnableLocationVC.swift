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
                
                showToast(message: "Yor current location is \(placeName)")
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
        lblTitle.setTheme("Enable location",
                          font: .bold,
                          size: 40)
        
        lblDescription.setTheme("We want to access your location only to provide a better experience by helping you finding your exact location.", color: .titleGrey, font: .regular, size: 14)
        
        btnNext.appButton("Enable")
        btnSkip.setTheme("Skip for now", color: .titleGrey)
        
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

                    print("Authorize.")
                    
                    break
                    
                case .notDetermined:
                    
                    print("Not determined.")
                    showAlert(message: "Please Allow Location for get near by post. open settings and allow location", buttons:["Open", "Cancel"]) { alert in
                        if alert.title == "Open" {
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
                    
                    print("Restricted.")
                    showAlert(message: "Please Allow Location for get near by post. open settings and allow location", buttons:["Open", "Cancel"]) { alert in
                        if alert.title == "Open" {
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
                    showAlert(message: "Please Allow Location for get near by post. open settings and allow location", buttons:["Open", "Cancel"]) { alert in
                        if alert.title == "Open" {
                            if let url = URL(string:UIApplication.openSettingsURLString)
                            {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                    print("Denied.")
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
