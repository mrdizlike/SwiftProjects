//
//  ViewController.swift
//  Project21
//
//  Created by Виктор on 22.03.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var distanceCircle: UIView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        distanceCircle.layer.cornerRadius = 128
        
        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            let ac = UIAlertController(title: "Whoa!", message: "We see your beacon", preferredStyle: .alert)
            present(ac, animated: true)
        } else {
            update(distance: .unknown)
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.distanceCircle.transform = CGAffineTransformMakeScale(0.25, 0.25)
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.distanceCircle.transform = CGAffineTransformMakeScale(0.5, 0.5)
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.distanceCircle.transform = CGAffineTransformMakeScale(1, 1)
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.distanceCircle.transform = CGAffineTransformMakeScale(0.001, 0.001)
            }
        }
    }

}

