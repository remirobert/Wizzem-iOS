//
//  LocationManager.swift
//  Echo
//
//  Created by Remi Robert on 09/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import CoreLocation

class RRLocationManager: NSObject, CLLocationManagerDelegate {
 
    var blockCompletion: ((CLLocation?, error: NSError?)->())!
    
    class var sharedInstance: RRLocationManager {
        struct Static {
            static var instance: RRLocationManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = RRLocationManager()
        }
        return Static.instance!
    }
    
    lazy var locationManager: CLLocationManager! = {
        let location = CLLocationManager()
        location.delegate = self
        location.distanceFilter = kCLDistanceFilterNone
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.startUpdatingLocation()
        return location
    }()
    
    let geocoder = CLGeocoder()
    
    //MARK: Core Location delegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationManager.stopUpdatingLocation()
        self.blockCompletion(nil, error:error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.locationManager.stopUpdatingLocation()
        self.blockCompletion(newLocation, error: nil)
    }
    
    //MARK: public RRLocationManager API
    
    class func currentLocation(blockCompletion:((currentLocation: CLLocation?, error: NSError?)->())) {
        self.sharedInstance.blockCompletion = blockCompletion
        self.sharedInstance.locationManager.startUpdatingLocation()
    }
    
    class func currentAddressLocation(blockCompletion:((currentAddress: [CLPlacemark]?, error: NSError?)->())) {
        self.currentLocation { (currentLocation, error) -> () in
            if error != nil {
                blockCompletion(currentAddress: nil, error: error)
                return
            }
            
            self.sharedInstance.geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (objects: [CLPlacemark]?, err: NSError?) -> Void in
                if err != nil {
                    blockCompletion(currentAddress: nil, error: err)
                    return
                }
                blockCompletion(currentAddress: objects, error: err)
            })
            
        }
    }
    
    class func reverseGeocodingFromLocation(location: CLLocation!, _ blockCompletion:((address: [CLPlacemark]?, error: NSError?)->())) {
        if let _ = location {
            
            self.sharedInstance.geocoder.reverseGeocodeLocation(location, completionHandler: { (objects: [CLPlacemark]?, err: NSError?) -> Void in
                if err != nil {
                    blockCompletion(address: nil, error: err)
                    return
                }
                blockCompletion(address: objects, error: err)
            })
        }
        else {
            blockCompletion(address: nil, error: nil)
        }
    }
    
    class func reverseGeocodingFromAddress(address: String, _ blockCompletion:((location: [CLLocation]?, error: NSError?)->())) {
        
        
        self.sharedInstance.geocoder.geocodeAddressString(address) { (objects: [CLPlacemark]?, err: NSError?) -> Void in
            if err != nil {
                blockCompletion(location: nil, error: err)
                return
            }
            if let objects = objects {
                var locations: [CLLocation] = Array()
                for currentPlaceMark in objects {
                    locations.append(currentPlaceMark.location!)
                }
                blockCompletion(location: locations, error: err)
                return
            }
            blockCompletion(location: nil, error: err)
        }
    }
    
    class func requestAuthorization() {
        self.sharedInstance.locationManager.requestWhenInUseAuthorization()
        self.sharedInstance.locationManager.requestAlwaysAuthorization()
    }
    
}
