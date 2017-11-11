//
//  Location.swift
//  AppData
//
//  Created by Daniel Meachum on 10/19/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import CoreLocation
import Contacts
import MapKit

public struct Location
{
    public let coordinate : CLLocationCoordinate2D
    
    public let title : String
    
    public let instructions : String?
    
    public let address : CNPostalAddress
    
    public let color = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    
    public let placemark : CLPlacemark?
    
    public var formattedAddress : String {
        
        let commaComponents = [address.city,address.state]
        let commaString = commaComponents.joined(separator: ", ")
        let newLineComponents = [address.street, commaString ,address.postalCode]
        
        return newLineComponents.joined(separator: "\n")
    }
    
    public var mapPlacemark : MKPlacemark {
        
        if let placemark = placemark {
            
            return MKPlacemark(placemark: placemark)
        }
        
        return MKPlacemark(coordinate: coordinate, postalAddress: address)
    }
}

public class LocationBuilder
{
    public var coordinate : CLLocationCoordinate2D?
    
    public var title : String?
    
    public var instructions : String?
    
    private var address : CNPostalAddress? {
        
        set {
            street = newValue?.street
            city = newValue?.city
            state = newValue?.state
            zipcode = newValue?.postalCode
        }
        
        get {
            guard let street = street, let city = city, let state = state, let zipcode = zipcode else { return nil }
            
            let address = CNMutablePostalAddress()
            
            address.street = street
            address.city = city
            address.state = state
            address.postalCode = zipcode
            
            return address
        }
    }
    
    
    public var street : String?
    
    public var city : String?
    
    public var state : String?
    
    public var zipcode : String?
    
    
    public var color = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    
    private var placemark : CLPlacemark? {
        
        didSet {
            
            if let placemarkAddress = placemark?.postalAddress, address == nil {
                
                address = placemarkAddress
            }
            if title == nil {
                
                title = placemark?.name
            }
            if coordinate == nil {
                
                coordinate = placemark?.location?.coordinate
            }
        }
    }
    
    public init(address : CNPostalAddress) {
        
        self.address = address
    }
    
    public init(title : String, coordinate : CLLocationCoordinate2D) {
        
        self.title = title
        
        self.coordinate = coordinate
    }
    
    public init(title : String, coordinate : (latitude : Double, longitude : Double)) {
        
        self.title = title
        
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    private func geocodeAddress(completionHandler : @escaping (Bool)->Void) {
        
        let geocodingHandler = { [weak self] (placemarks, error) in
            
            if let firstPlacemark = placemarks?.first {
                
                self?.placemark = firstPlacemark
                
                completionHandler(true)
            }
            else {
                
                completionHandler(false)
            }
        } as CLGeocodeCompletionHandler
        
        if let address = address {
            
            CLGeocoder().geocodePostalAddress(address, completionHandler: geocodingHandler)
        }
        else if let coordinate = coordinate {
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: geocodingHandler)
        }
        else {
            
            completionHandler(false)
        }
    }
    
    public func createLocation(completionHandler : @escaping (Location?)->Void) {
        
        if let title = title, let coordinate = coordinate, let address = address {
            
            let location = Location(coordinate: coordinate, title: title, instructions: instructions, address: address, placemark: placemark)
            
            completionHandler(location)
        }
        else {
            
            geocodeAddress(completionHandler: { (success) in
                
                if success {
                    
                    self.createLocation(completionHandler: completionHandler)
                }
            })
        }
    }
}
