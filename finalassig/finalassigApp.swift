//
//  finalassigApp.swift
//  finalassig
//
//  Created by Jerry Chu on 12/7/24.
//

import SwiftUI

@main
struct finalassigApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var launchView = true
    @StateObject private var locationManager = LocationCoordinate()
    private var locationExtract = TmrRequest()
    private var getCity = LocGeoCoder()
    @StateObject var dataExtract = ParseData()
    @State var cityName: String = "N/A"
    @State private var weekData: [[String: String]] = []
    
    var body: some Scene
    {
        WindowGroup {
            if launchView
            {
                LaunchScreenView()
                    .onAppear
                {
                    locationManager.getSingleLocation
                    {
                        coordinates in if coordinates.isEmpty
                        {
                            print("Failed to fetch location")
                        }
                        else
                        {
                            let coord = "\(coordinates[0]),\(coordinates[1])"
                            locationExtract.getWeather(location:coord)
                            {
                                result in switch result
                                {
                                    case .success (let data):
                                        dataExtract.parseDay(data: data)
                                        weekData = dataExtract.parseWeek(data: data)
                                    case .failure (let error):
                                        print("Error")
                                }
                            }
                            getCity.getCityName(latitude: coordinates[0], longitude: coordinates[1])
                            {
                                city, error in if let error = error{
                                    print("Error")
                                }
                                else if let city = city
                                {
                                    cityName = city
                                    print("city: \(city)")
                                }
                                else
                                {
                                    print("CIty Not Found")
                                }
                            }
                            
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                    {
                        launchView = false
                    }
                        
                }
            }
            else
            {
                ContentView(viewModel: dataExtract, cityName: cityName, weekData: $weekData)
            }
        }
    }
}
