//
//  WeatherZipTests.swift
//  WeatherZipTests
//
//  Created by macbook on 6/18/19.
//  Copyright © 2019 Matt Hendrickson. All rights reserved.
//

import XCTest
@testable import WeatherZip

class WeatherZipTests: XCTestCase {

    let APIKey = "f87c9f637869c52fd74cec6bcb43ac45"

    
    var sutURLSession: URLSession!
    var sutMainViewController: MainViewController!
    var sutDetailViewController: DetailViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        sutURLSession = URLSession.shared
        sutMainViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        sutDetailViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        sutURLSession = nil
        sutMainViewController = nil
        sutDetailViewController = nil
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testThat200IsReceivedByValidCall() {
        //given these
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=78704,us&APPID=\(APIKey)")
        let promise = expectation(description: "Status code: 200")
        //when this happens
        let dataTask = sutURLSession.dataTask(with: url!) { data, response, error in
            // then see these results
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout: 5)
    }
    
    func testThatErrorIsReceivedByInvalidCall() {
        //given these
        let url = URL(string: "https://ai.openwhermap.org/dather?zip=78704,us&APPID=\(APIKey)")
        let promise = expectation(description: "Error found")
        //when this happens
        let dataTask = sutURLSession.dataTask(with: url!) { data, response, error in
            // then see these results
            if let error = error {
                promise.fulfill()
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    XCTFail("Status code: 200 Found)")

                } else {
                    XCTFail("Status code other than 200 Found)")
                }
            }
        }
        dataTask.resume()
        // 3
        wait(for: [promise], timeout:99)
    }
    
    func testThatZipCodeIsValid() {
        //given
        let validZip = "78701"
        let validZipLonger = "78701-1234"
        let invalidZip5Letters = "asbcf"
        let invalidZip4numbers = "7870"
        let invalidZipAlmost = "78701-123"
        let invalidZipEmpty = ""
        
        //when
        let validZipResult = sutMainViewController.checkIfNumberIsZipCodeFormat(num: validZip)
        let validZipLongerResult = sutMainViewController.checkIfNumberIsZipCodeFormat(num: validZipLonger)
        let invalidZip5LettersResult = sutMainViewController.checkIfNumberIsZipCodeFormat(num: invalidZip5Letters)
        let invalidZip4numbersResult = sutMainViewController.checkIfNumberIsZipCodeFormat(num: invalidZip4numbers)
        let invalidZipAlmostResult = sutMainViewController.checkIfNumberIsZipCodeFormat(num: invalidZipAlmost)
        let invalidZipEmptyResult = sutMainViewController.checkIfNumberIsZipCodeFormat(num: invalidZipEmpty)
        
        //then
        XCTAssertTrue(validZipResult)
        XCTAssertTrue(validZipLongerResult)
        XCTAssertFalse(invalidZip5LettersResult)
        XCTAssertFalse(invalidZip4numbersResult)
        XCTAssertFalse(invalidZipAlmostResult)
        XCTAssertFalse(invalidZipEmptyResult)
    }
    
    func testThatDetailViewControllersLabelsAreSetCorrectly() {        
        //I want to create some mock data from server and pass that into my code to see if DetailVC's Labels are set correctly
        
        //given
        
        //when
        
        //then
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
