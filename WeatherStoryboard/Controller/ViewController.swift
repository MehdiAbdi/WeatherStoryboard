//
//  ViewController.swift
//  WeatherStoryboard
//
//  Created by Mehdi Abdi on 3/12/20.
//  Copyright © 2020 Mehdi Abdi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var imageCondition: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var weatherService  = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService.delegate  = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - CoreLocation Extension
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude  = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherService.fetchBaseURLKey(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - WeatherServiceDelegate Extension
extension ViewController: WeatherServiceDelegate {
    func didUpdateWeatherKey(_ data: WGeoPositionData) {
        weatherService.fetchBaseURLCondition(key: data.key)
        
        DispatchQueue.main.async {
            self.locationLabel.text! = data.localizedName
        }
    }
    
    func didUpdateWeatherCondition(_ data: WCurrentConditionData) {
        DispatchQueue.main.async {
            self.imageCondition.image   = UIImage(named: data.imageCondition)
            self.temperatureLabel.text! = data.temperatureInString
        }
    }
    
    func didFaildWithError(_ error: Error) {
        print(error)
    }
    
    
}
