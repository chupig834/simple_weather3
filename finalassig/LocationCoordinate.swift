//
//  LocationCoordinate.swift
//  finalassig
//
//  Created by Jerry Chu on 12/7/24.
//

import Foundation
import CoreLocation

class LocationCoordinate: NSObject, CLLocationManagerDelegate, ObservableObject
{
    private let locationAgent = CLLocationManager()
    private var locationHandler: (([Double]) -> Void)?
    
    override init()
    {
        super.init()
        locationAgent.delegate = self
        locationAgent.desiredAccuracy = kCLLocationAccuracyBest
        //locationAgent.requestWhenInUseAuthorization()
        //locationAgent.startUpdatingLocation() // Start location updates
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization()
    {
        switch locationAgent.authorizationStatus
        {
            case .notDetermined:
                locationAgent.requestWhenInUseAuthorization()
            case .restricted:
                print("idk")
            case .denied:
                print("idk")
            case .authorizedAlways:
                print("idk")
            case .authorizedWhenInUse:
                print("Location in Use")
            @unknown default:
                print("idk")// Catch-all case introduced for future-proofing
            }
            
    }

    /*func locationManagerDidChangeAUthorization(_ manager: CLLocationManager)
    {
        checkLocationAuthorization()
    }*/
    


    //Using this to grab the coordinates back from the iphone
    func getSingleLocation(completion: @escaping ([Double]) -> Void)
    {
        self.locationHandler = completion
        self.locationAgent.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last
        {
            let coordinates = [location.coordinate.latitude, location.coordinate.longitude]
            self.locationHandler?(coordinates) // Pass coordinates to the closure
            self.locationAgent.stopUpdatingLocation() // Stop updating location
        }
    }
}
