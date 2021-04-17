//
//  Veerender_weatherTests.swift
//  Veerender_weatherTests
//
//  Created by apple on 16/04/21.
//

import XCTest
@testable import Veerender_weather

class Veerender_weatherTests: XCTestCase {
    
    
    func dateTest(){
        
       // XCTAssertTrue(Constants.dateStyleChance("1987-09-29 09:00:00"))
        
        XCTAssertNotNil(Constants.dateStyleChance("1987-09-29 09:00:00"))
        
    }
    
    
    func urlApiTest(){
        
        let api = mapViewController()
        
        api.getWeather(city:"Hyderabad")
        
        XCTAssertNotNil(Response.self)
        XCTAssertNil(Error.self)
        
        
        
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
