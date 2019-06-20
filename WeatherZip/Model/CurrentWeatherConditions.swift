//
//  CurrentWeatherConditions.swift
//  WeatherZip
//
//  Created by macbook on 6/19/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation

struct CurrentWeatherConditions {
    let zip: String
    let temp : String
    let description : String
    let humidity : String
    
    init(zip: String, temp: String, description: String, humidity: String) {
        self.zip = zip
        self.temp = temp
        self.description = description
        self.humidity = humidity
    }
}
