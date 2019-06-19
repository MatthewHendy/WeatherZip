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
        
        configureLabels()
    }
    
    private func configureLabels() {
        if let currentWeatherConditions = currentWeatherConditions {
            descriptionLabel.text = currentWeatherConditions.description
            tempLabel.text = currentWeatherConditions.temp
            humidityLabel.text = currentWeatherConditions.humidity
        } else {
            print("Current Weather Conditions Not Provided")
        }
    }
    
}
