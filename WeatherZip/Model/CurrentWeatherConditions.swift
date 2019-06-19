//
//  CurrentWeatherConditions.swift
//  WeatherZip
//
//  Created by macbook on 6/19/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation

struct CurrentWeatherConditions {
    let temp : Double
    let description : String
    let humidity : Double
    
    init(temp: Double, description: String, humidity: Double) {
        self.temp = temp
        self.description = description
        self.humidity = humidity
    }
}
