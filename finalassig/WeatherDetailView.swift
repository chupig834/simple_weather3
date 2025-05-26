//
//  WeatherDetailView.swift
//  finalassig
//
//  Created by Jerry Chu on 12/9/24.
//

import Foundation
import SwiftUI

struct  WeatherDetailView : View
{
    let city: String
    let weekData: [[String: String]]
    let dayData: ParseData
    @State var favRequest = FavRequest()
    
    @State var isFavCity: Bool
    
    var body: some View
    {
        ZStack
        {
            Image("App_background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.bottom) // Ensure it spans the entire screen
            VStack
            {
                Button(action:{
                    if !isFavCity
                    {
                        favRequest.saveCity(city:city)
                        {
                            result in switch result
                            {
                            case .success:
                                print("City data saved successfully")
                                isFavCity = true
                            case .failure:
                                print("City data failed to save")
                            }
                        }
                        var favorites = UserDefaults.standard.array(forKey: "FavoriteCities")as? [String] ?? []
                        if !favorites.contains(city)
                        {
                            favorites.append(city)
                            UserDefaults.standard.set(favorites, forKey: "FavoriteCities")
                            
                        }
                    }
                    else
                    {
                        checkFavCity(city: city)
                        {
                            id in if id != "N/A"
                            {
                                favRequest.delCity(ID:id)
                            }
                        }
                        isFavCity = false
                        print("It is already fav")
                    }
                })
                {
                    Image(isFavCity ? "close-circle": "plus-circle")
                }
                .padding(.top, 30)
                .offset(x:150)
                WeatherCard(city: city, dayData: dayData, weekData: weekData)
                
                WeatherDetail(city: city, dayData: dayData, weekData: weekData)
                
                WeatherListDay(city: city, dayData: dayData, weekData: weekData)
                Spacer()
            }
        }
        .navigationTitle(city)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Button(action: tweetText)
                {
                    Image("twitter")
                }
            }
        }
        .tint(.blue)
    }
    
    func tweetText ()
    {
        let temp = dayData.temperature
        let condition = dayData.code
        let text = "The current temperature at " + city + " is " + temp + "°F. The weather conditions are " + condition;
        let hashTag = "CSCI571WeatherForecast";
        
        let url = URL(string: "https://twitter.com/intent/tweet?text=\(text)&hashtags=\(hashTag)")!
        
        UIApplication.shared.open(url)
    }
    
    func checkFavCity(city: String, completion: @escaping (String) -> Void)
    {
        favRequest.getCity
        {
            result in DispatchQueue.main.async
            {
                    switch result
                    {
                        case .success(let maps):
                            if let mapObj = maps.first(where: { $0.city.lowercased() == city.lowercased() })
                            {
                                let id = mapObj._id
                                completion(id)
                            }
                        case .failure:
                        completion("")
                    }
            }
        }
    }
    
    struct WeatherCard: View
    {
        let city: String
        let dayData: ParseData
        let weekData: [[String: String]]
        
        var body: some View
        {
            ZStack
            {
                RoundedRectangle(cornerRadius:20)
                    .fill(Color.white.opacity(0.2))
                    .frame(width:350, height:150)
                    .shadow(radius: 10)
                HStack
                {
                    Image(dayData.code)
                        .resizable()
                        .scaledToFit()
                        .frame(width:150, height:150)
                    
                    VStack(alignment: .leading)
                    {
                        Text(dayData.temperature)
                        Text(dayData.code)
                        Text(city)
                    }
                }
            }
        }
    }
    
    struct WeatherDetail: View {
        let city: String
        let dayData: ParseData
        let weekData: [[String: String]]
        
        var body: some View
        {
            HStack
            {
                VStack
                {
                    Text("Humidity")
                    Image("Humidity")
                        .resizable()
                        .scaledToFit()
                        .frame(width:80, height:80)
                    Text(dayData.hum)
                }
                VStack
                {
                    Text("Wind Speed")
                    Image("WindSpeed")
                        .resizable()
                        .scaledToFit()
                        .frame(width:80, height:80)
                    Text(dayData.wSpeed)
                }
                VStack
                {
                    Text("Visibility")
                    Image("Visibility")
                        .resizable()
                        .scaledToFit()
                        .frame(width:80, height:80)
                    Text(dayData.vis)
                }
                VStack
                {
                    Text("Pressure")
                    Image("Pressure")
                        .resizable()
                        .scaledToFit()
                        .frame(width:80, height:80)
                    Text(dayData.pres)
                }
            }
            .padding(.top,30)
            .padding(.bottom,30)
        }
    }
    
    struct WeatherRow: View
    {
        let date: String
        let weatherIcon: String
        let riseTime: String
        let setTime: String
        
        var body: some View {
            HStack(spacing: 0)
            {
                // Date
                Text(date)
                    .font(.subheadline)
                    .frame(width: 80, alignment: .leading)
                
                // Weather Icon
                Image(weatherIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                
                Spacer(minLength: 3) // Reduce the minimum space between elements
                
                Text(riseTime)
                
                // Sunrise Icon
                Image("sun-rise")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.orange)
                
                Spacer(minLength: 3) // Reduce the minimum space between elements
                
                Text(setTime)
                
                // Sunset Icon
                Image("sun-set")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)

            }
            .padding(.vertical, 10)
            .frame(maxWidth:300, maxHeight:20)
            .scaledToFit()
            
        }
    }
    
    struct WeatherListDay: View
    {
        let city: String
        let dayData: ParseData
        let weekData: [[String: String]]
        
        var body: some View
        {
            ZStack
            {
                List {
                    ForEach(weekData, id: \.["startTime"]) { data in
                        WeatherRow(
                            date: data["startTime"] ?? "Unknown",
                            weatherIcon: data["code"] ?? "Unknown",
                            riseTime: data["sunriseTime"] ?? "Unknown",
                            setTime: data["sunsetTime"] ?? "Unknown")
                    }
                }
                .listStyle(.plain)
                .frame(maxWidth: 350)
            }
        }
    }

}

