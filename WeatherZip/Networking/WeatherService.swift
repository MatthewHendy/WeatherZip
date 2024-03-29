//
//  WeatherService.swift
//  WeatherZip
//
//  Created by macbook on 6/18/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation
import UIKit

class WeatherService: NSObject {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = (CurrentWeatherConditions?, String) -> ()
    
    let APIKey = "f87c9f637869c52fd74cec6bcb43ac45"
    
    let sharedSession = URLSession.shared
    var dataTask: URLSessionDataTask?
    
    var errorMessage: String = ""
    
    public func performCurrentWeatherRequestWithZip(_ zip: String, completionBlock: @escaping QueryResult) {
        errorMessage = "" //reset error message
        dataTask?.cancel()//cancel task first to make sure it isnt doing something else
        let urlString = "https://api.openweathermap.org/data/2.5/weather?zip=\(zip),us&units=imperial&APPID=\(APIKey)"
        let url = URL(string: urlString)!
        
        dataTask = sharedSession.dataTask(with: url) { [weak self] (data, response, error) in
            defer {self?.dataTask = nil}
            guard let weakSelf = self else {
                print("Self is nil, cannot continue")
                return
            }
            var currentWeatherConditions:CurrentWeatherConditions? = nil

            if let error = error {
                weakSelf.errorMessage += error.localizedDescription
            } else if let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                var json: JSONDictionary?
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                    currentWeatherConditions = weakSelf.packageCurrentWeatherConditions(json, zip: zip)
                } catch let parseError as NSError {
                    weakSelf.errorMessage += "JSONSerialization error: \(parseError.localizedDescription)"
                }
            } else if let response = response as? HTTPURLResponse {
                weakSelf.errorMessage += "Server Response error: \(response.statusCode)"
            }
            
            DispatchQueue.main.async {
                completionBlock(currentWeatherConditions, weakSelf.errorMessage)
            }
        }
        
        dataTask?.resume()//perform request
    }
    
    
    private func packageCurrentWeatherConditions(_ json: JSONDictionary?, zip: String) -> CurrentWeatherConditions {
        //unpackage necessary pieces from json
        var temp: String
        var description: String
        var humidity : String
        
        //description
        if let weatherArray = json?["weather"] as? [JSONDictionary],
            let weather:JSONDictionary = weatherArray[0],
            let des = weather["description"] {
                description = des as! String
        } else {
            description = "No Description Provided"
        }
        
        //temp
        if let mainDictionary1 = json?["main"] as? JSONDictionary,
            let tempHolder = mainDictionary1["temp"] {
                temp = String(tempHolder as! Double)
        } else {
            temp = "No Temperature Provided"
        }
        
        //humidity
        if let mainDictionary2 = json?["main"] as? JSONDictionary,
            let hum = mainDictionary2["humidity"] {
                humidity = String(hum as! Double)
        } else {
            humidity = "No Humidity Provided"
        }
        
        let currentWeatherConditions = CurrentWeatherConditions.init(zip: zip, temp: temp, description: description, humidity: humidity)
        
        return currentWeatherConditions
    }
    
}
