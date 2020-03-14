//
//  WeatherModel.swift
//  WeatherStoryboard
//
//  Created by Mehdi Abdi on 3/14/20.
//  Copyright © 2020 Mehdi Abdi. All rights reserved.
//

import Foundation

// 1- Catch Key and LocalizedName with passed latitute and longitute
struct WGeoPosition: Codable {
    let Key:           String
    let LocalizedName: String
    
}

// 2- Get Temperature with catched Key
struct WCurrentCondition: Codable {
    let Temperature: Metrics
    let WeatherText: String
    
}

struct Metrics: Codable {
    let Metric: Values
    
}

struct Values: Codable {
    let Value: Double
    
}

