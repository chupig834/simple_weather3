//
//  LocGeoCoder.swift
//  finalassig
//
//  Created by Jerry Chu on 12/8/24.
//

import Foundation
import CoreLocation

class LocGeoCoder
{
    private let geocoder = CLGeocoder()
    
    func getCityName(latitude: Double, longitude: Double, completion: @escaping(String?, Error?) -> Void)
    {
        let cord = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(cord)
        {
            locs, error in if let error = error
            {
                completion(nil, error)
                return
            }
            
            if let loc = locs?.first
            {
                let cityName = loc.locality
                completion(cityName, nil)
            }
            else
            {
                completion(nil, nil)
            }
        }
    }
    
    func getCityCoordinates(for cityName: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void)
    {
        geocoder.geocodeAddressString(cityName)
        {city, error in
            
            if let error = error
            {
                completion(nil, error)
                return
            }
            
            if let city = city?.first, let loc = city.location{
                completion(loc.coordinate, nil)
            }
            else
            {
                print("No coordinates found")
                completion(nil, nil)
            }
        }
    }
}
