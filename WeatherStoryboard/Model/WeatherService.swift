//
//  WeatherService.swift
//  WeatherStoryboard
//
//  Created by Mehdi Abdi on 3/12/20.
//  Copyright © 2020 Mehdi Abdi. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherServiceDelegate {
    func didUpdateWeatherKey(_ data: WGeoPositionData)
    func didUpdateWeatherCondition(_ data: WCurrentConditionData)
    func didFaildWithError(_ error: Error)
}

struct WeatherService {
    private let baseURLGeoPosition = "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?"
    private let baseURLCondition   = "https://dataservice.accuweather.com/currentconditions/v1/"
    private let apiKey             = "wzD83y5GjePPdjCINEcxTyVbhEP49ldb"
    private let decoder            = JSONDecoder()
    
    var delegate: WeatherServiceDelegate?
    
    func fetchBaseURLKey(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let baseUrl = "\(baseURLGeoPosition)apikey=\(apiKey)&q=\(lat),\(lon)"
        performRequestKL(for: baseUrl)
        
    }
    
    func fetchBaseURLCondition(key: String) {
        let baseUrl = "\(baseURLCondition)\(key)?apikey=\(apiKey)"
        performRequestCC(for: baseUrl)
        
    }
    
    func performRequestKL(for url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task    = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFaildWithError(error!)
                }
                else if let safeData = data {
                    let dataKL = self.parsJsonKL(weatherData: safeData)
                    self.delegate?.didUpdateWeatherKey(dataKL!)
                }
            }
            task.resume()
        }
    }
    
    func performRequestCC(for url: String) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task    = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFaildWithError(error!)
                }
                else if let safeData = data {
                    let weatherData = self.parsJsonCC(weatherData: safeData)
                    self.delegate?.didUpdateWeatherCondition(weatherData!)
                }
            }
            task.resume()
        }
    }
    
    func parsJsonKL(weatherData: Data) -> WGeoPositionData? {
        do {
            let decodedData   = try decoder.decode(WGeoPosition.self, from: weatherData)
            let key           = decodedData.Key
            let localizedName = decodedData.LocalizedName
            let wGeoPositionKL = WGeoPositionData(key: key, localizedName: localizedName)
            
            return wGeoPositionKL
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func parsJsonCC(weatherData: Data) -> WCurrentConditionData? {
        do {
            let decodedData      = try decoder.decode([WCurrentCondition].self, from: weatherData)
            let temperature      = decodedData[0].Temperature.Metric.Value
            let weatherText      = decodedData[0].WeatherText
            let weatherCondition = WCurrentConditionData(temperature: temperature, weatherText: weatherText)
            
            return weatherCondition
        }
        catch {
            print(error)
            return nil
        }
    }
}
