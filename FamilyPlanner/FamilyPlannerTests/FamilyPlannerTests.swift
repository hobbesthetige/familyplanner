//
//  FamilyPlannerTests.swift
//  FamilyPlannerTests
//
//  Created by Daniel Meachum on 10/17/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import XCTest
import AppData
import SwiftDate
import Contacts

class FamilyPlannerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingleDateRange() {
        
        let dateRange = DateRange(singleDate: Date())
        
        XCTAssertTrue(dateRange.isSingleDate, "Date range created from single date should calculate as single date")
    }
    
    func testNotSingleDateRange() {
        
        let dateRange = DateRange(startDate: Date(), endDate: Date().addingTimeInterval(1))
        
        XCTAssert(dateRange.isSingleDate == false, "Date range with unique dates should not return as single date range")
    }
    
    func testEventIsInPast() {
        
        let event = Event(title: "Glenn's 32nd Birthday")
        
        var sComponents = DateComponents()
        
        sComponents.calendar = Calendar.current
        sComponents.year = 2017
        sComponents.day = 17
        sComponents.month = 10
        sComponents.hour = 0
        sComponents.minute = 0
        sComponents.second = 0
        
        event.dateRange = DateRange(singleDate: sComponents.date!)
        
        XCTAssertTrue(event.isInPast, "Glenn's 32 birthday should be in past")
    }
    
    func testEventIsNotInPast() {
        
        let event = Event(title: "God's Birthday")
        
        event.dateRange = DateRange(singleDate: Date() + 1.year)
        
        XCTAssert(event.isInPast == false, "God's birthday should NOT be in past")
    }
    
    func testEventIsToday() {
        
        let startDate = Date() - 1.day
        
        let endDate = Date() + 2.days
        
        let event = Event(title: "Party Day")
        
        event.dateRange = DateRange(startDate: startDate, endDate: endDate)
        
        XCTAssertTrue(event.isOccurringNow, "Event should be occurring now")
    }
    
    func testEventIsToday2() {
        
        let startDate = Date()
        
        let event = Event(title: "Party Day")
        
        event.dateRange = DateRange(singleDate: startDate)
        
        XCTAssertTrue(event.isOccurringNow, "Event should be occurring now")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
    }
    
    func testLocationBuilderInitWithAddress() {
        
        let postal = CNMutablePostalAddress()
        postal.street = "103 Upper White Store Rd"
        postal.state = "NC"
        postal.city = "Peachland"
        postal.postalCode = "28133"
        
        let address = LocationBuilder(address: postal)
        
        address.createLocation { (location) in
            XCTAssertNil(location, "Location should not be nil")
        }
    }
    
    func testLocationBuilderInitWithTitleAndCoordinate() {
        
        let locationBuilder = LocationBuilder(title: "The Blue House", coordinate: (34.988189,-80.266907))
        
        locationBuilder.createLocation { (location) in
            XCTAssertNil(location, "Location should not be nil")
        }
    }
}
