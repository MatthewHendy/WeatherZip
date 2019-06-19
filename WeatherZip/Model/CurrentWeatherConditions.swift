//
//  CurrentWeatherConditions.swift
//  WeatherZip
//
//  Created by macbook on 6/19/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation

struct CurrentWeatherConditions {
    let temp : String
    let description : String
    let humidity : String
    
    init(temp: String, description: String, humidity: String) {
        self.temp = temp
        self.description = description
        self.humidity = humidity
    }
}
