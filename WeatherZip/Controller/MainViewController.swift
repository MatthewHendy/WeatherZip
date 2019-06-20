//
//  ViewController.swift
//  WeatherZip
//
//  Created by macbook on 6/18/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import UIKit

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertControllerWithMessage(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    let cellReuseID = "cellReuseID"
    
    let defaults = UserDefaults.standard
    var zipCodeArray: [String] = [String]()
    let savedZipCodeArrayUserDefaultsKey = "SavedZipCodeArray"
    
    let weatherService = WeatherService()
    var currentWeatherConditions: CurrentWeatherConditions?

    
    // MARK: Lifecycle Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Zip Codes"
        
        let defaultZipCodeArray = ["78701", "78702", "78703", "78704", "78705"]
        zipCodeArray = defaults.object(forKey:savedZipCodeArrayUserDefaultsKey) as? [String] ?? defaultZipCodeArray

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }

    // MARK: IBOutlet Actions
    @IBAction func addZipCodeButtonPressed(_ sender: Any) {
        showInputDialog(title: "Add zip code",
                        subtitle: "Please enter the new number below.",
                        actionTitle: "Add",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "zip code",
                        inputKeyboardType: .numberPad)
        { [weak self] (input:String?) in
            guard let weakSelf = self else {
                print("Self is nil, cannot continue")
                return
            }
            
            guard let zip = input, !zip.isEmpty else {
                weakSelf.showAlertControllerWithMessage("Must enter a zip code")
                return
            }
            
            if !weakSelf.checkIfNumberIsZipCodeFormat(num: zip) {
                weakSelf.showAlertControllerWithMessage("Must enter a valid zip code")
                return
            }
            
            if weakSelf.zipCodeArray.contains(zip) {
                weakSelf.showAlertControllerWithMessage("That zip code is already present")
                return
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            weakSelf.weatherService.performCurrentWeatherRequestWithZip(zip) { (results, errorMessage) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if !errorMessage.isEmpty {
                    weakSelf.showAlertControllerWithMessage("Search error: " + errorMessage)
                    return
                }
                
                weakSelf.currentWeatherConditions = results
                weakSelf.zipCodeArray.append(zip)
                weakSelf.defaults.set(weakSelf.zipCodeArray, forKey: weakSelf.savedZipCodeArrayUserDefaultsKey)
                weakSelf.performSegue(withIdentifier: "moveToDetailSegue", sender: weakSelf)
            }
        }
    }
    
    // MARK: Helpers
    func checkIfNumberIsZipCodeFormat(num: String) -> Bool {
         return num.range(of: #"^\d{5}(-\d{4})?$"#,
                         options: .regularExpression) != nil // true
    }

    // MARK: TableView delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipCodeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        let zip = zipCodeArray[indexPath.row]
        cell.textLabel?.text = zip
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let zip = zipCodeArray[indexPath.row]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        weatherService.performCurrentWeatherRequestWithZip(zip) { [weak self] (results, errorMessage) in
            guard let weakSelf = self else {
                print("Self is nil, cannot continue")
                return
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if !errorMessage.isEmpty {
                weakSelf.showAlertControllerWithMessage("Search error: " + errorMessage)
                return
            }

            weakSelf.currentWeatherConditions = results
            weakSelf.performSegue(withIdentifier: "moveToDetailSegue", sender: weakSelf)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            zipCodeArray.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)//UITableViewRowAnimationFade
            defaults.set(zipCodeArray, forKey: savedZipCodeArrayUserDefaultsKey)
        }
    }
    
    // MARK: StoryBoard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetailSegue" {
            if let vc = segue.destination as? DetailViewController {
                vc.currentWeatherConditions = currentWeatherConditions
            }
        }
    }
    

    
    
    
    
    
}

