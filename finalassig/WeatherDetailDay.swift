//
//  WeatherDetailDay.swift
//  finalassig
//
//  Created by Jerry Chu on 12/9/24.
//

import SwiftUI

struct WeatherDetailDay: View
{
    @ObservedObject var viewModel: ParseData
    var cityName: String
    
    var body: some View
    {
        TabView
        {
            TodayView(viewModel: viewModel)
                .tabItem
            {
                Image("Today_Tab")
                Text("TODAY")
            }
            
            WeekView()
                .tabItem
            {
                Image("Weekly_Tab")
                Text("WEEKLY")
            }
            
            WeatherView()
                .tabItem
            {
                Image("Weather_Data_Tab")
                Text("WEATHER DATA")
            }
        }
        .onAppear()
        {
            UITabBar.appearance().backgroundColor = .white
            UINavigationBar.appearance().backgroundColor = .white
        }
        .tint(.blue)
        .navigationTitle(cityName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar
        {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Button(action:{})
                {
                    Image("twitter")
                }
            }
        }
    }

}

struct WeatherCont: View
{
    let iconName: String
    let value: String
    let label: String
    
    var body: some View
    {
        ZStack
        {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.3))
                .frame(width:100, height:150)
                .shadow(radius: 5)
            
            VStack(spacing: 10)
            {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                Text(value)
                
                Text(label)
            }
        }
    }
}

struct TodayView: View {
    @ObservedObject var viewModel: ParseData
    var body: some View
    {
        ZStack
        {
            Image("App_background")
                .resizable()
                .scaledToFill()
            
            VStack
            {
                HStack
                {
                    WeatherCont(
                        iconName: "WindSpeed",
                        value: viewModel.wSpeed,
                        label: "Wind Speed"
                    )
                    WeatherCont(
                        iconName: "Pressure",
                        value: viewModel.pres,
                        label: "Pressure"
                    )
                    WeatherCont(
                        iconName: "Precipitation",
                        value: viewModel.precProb,
                        label: "Precipitation"
                    )
                }
                .padding(.bottom, 50)
                .padding(.top, 50)
                HStack
                {
                    WeatherCont(
                        iconName: "Temperature",
                        value: viewModel.temperature,
                        label: "Temperature"
                    )
                    WeatherCont(
                        iconName: viewModel.code,
                        value: viewModel.code,
                        label: ""
                    )
                    WeatherCont(
                        iconName: "Humidity",
                        value: viewModel.hum,
                        label: "Humidity"
                    )
                }
                .padding(.bottom, 50)
                HStack
                {
                    WeatherCont(
                        iconName: "Visibility",
                        value: viewModel.vis,
                        label: "VIsibility"
                    )
                    WeatherCont(
                        iconName: "CloudCover",
                        value: viewModel.cloudCover,
                        label: "Cloud Cover"
                    )
                    WeatherCont(
                        iconName: "UVIndex",
                        value: viewModel.temperature,
                        label: "UVIndex"
                    )
                }
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct WeekView: View {
    var body: some View
    {
        ZStack
        {
            Image("App_background")
                .resizable()
                .scaledToFill()
        }
    }
}

struct WeatherView: View {
    var body: some View
    {
        ZStack
        {
            Image("App_background")
                .resizable()
                .scaledToFill()

        }
    }
}

/*#Preview {
    WeatherDetailDay()
}*/
