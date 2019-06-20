//
//  DetailViewController.swift
//  WeatherZip
//
//  Created by macbook on 6/19/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var currentWeatherConditions: CurrentWeatherConditions?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureLabelsAndTitle()
    }
    
    private func configureLabelsAndTitle() {
        if let currentWeatherConditions = currentWeatherConditions {
            navigationItem.title = "Weather Details for \(currentWeatherConditions.zip)"
            descriptionLabel.text = "Description: \(currentWeatherConditions.description)"
            tempLabel.text = "Temperature: \(currentWeatherConditions.temp)"
            humidityLabel.text = "Humidity: \(currentWeatherConditions.humidity)"
        } else {
            showAlertControllerWithMessage("Current Weather Conditions Not Provided")
        }
    }
    
}
