//
//  InterfaceController.swift
//  WeatherStoryboard Watch Extension
//
//  Created by Mehdi Abdi on 3/31/20.
//  Copyright © 2020 Mehdi Abdi. All rights reserved.
//

import WatchKit
import CoreLocation

class InterfaceController: WKInterfaceController {
    @IBOutlet weak var conditionImage: WKInterfaceImage!
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var locationLabel: WKInterfaceLabel!
    
    let locationManager = CLLocationManager()
    var weatherService = WeatherService()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        locationManager.delegate = self
        weatherService.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - CoreLocation Extension
extension InterfaceController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            weatherService.fetchBaseURLKey(lat: latitude, lon: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - WeatherServiceDelegate Extension
extension InterfaceController: WeatherServiceDelegate {
    func didUpdateWeatherKey(_ data: WGeoPositionData) {
        weatherService.fetchBaseURLCondition(key: data.key)
        
        DispatchQueue.main.async {
            self.locationLabel.setText(data.localizedName)
        }
    }
    
    func didUpdateWeatherCondition(_ data: WCurrentConditionData) {
        DispatchQueue.main.async {
            
            self.conditionImage.setImageNamed(data.imageCondition)
            self.temperatureLabel.setText(data.temperatureInString)
        }
    }
    
    func didFaildWithError(_ error: Error) {
        print(error)
    }
    
}
