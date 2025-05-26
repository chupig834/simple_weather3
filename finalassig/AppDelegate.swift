//
//  AppDelegate.swift
//  finalassig
//
//  Created by Jerry Chu on 12/8/24.
//

import Foundation
import UIKit
import GooglePlaces

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("****")
        return true
    }
}

