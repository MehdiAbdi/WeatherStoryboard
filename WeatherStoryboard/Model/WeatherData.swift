//
//  WeatherData.swift
//  WeatherStoryboard
//
//  Created by Mehdi Abdi on 3/14/20.
//  Copyright © 2020 Mehdi Abdi. All rights reserved.
//

import Foundation

struct WGeoPositionData {
    let key:           String
    let localizedName: String
    
}

struct WCurrentConditionData {
    let temperature: Double
    let weatherText: String
    
    var temperatureInString: String {
        return String(temperature)
    }
    
    var imageCondition: String {
        switch weatherText {
        case "Cloudy":
            return "Cloudy"
        case "Partly sunny":
            return "Partly sunny"
        case "Rain":
            return "Rain"
        case "Snow":
            return "Snow"
        case "Sunny":
            return "Sunny"
        case "Thunderbolt":
            return "Thunderbolt"
        case "Windy":
            return "Windy"
        default:
            return "Sunny"
            
        }
    }
}
