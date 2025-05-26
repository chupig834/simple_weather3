//
//  ContentView.swift
//  finalassig
//
//  Created by Jerry Chu on 12/7/24.
//

import SwiftUI
import SwiftSpinner

struct ContentView: View
{
    @State private var searchText = ""
    @State private var items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]
    @ObservedObject var viewModel: ParseData
    var cityName: String
    @Binding var weekData: [[String: String]] // Weekly weather data
    @StateObject private var autoView = CityAutoComplete()
    @State private var isSelectingSuggestion = false
    @State private var apiData: [[String: String]] = []
    @State private var dataExtract = ParseData()
    
    //This is for navigation link
    @State private var selectedCity: String? = nil
    @State var isFavCity: Bool = false
    var favRequest = FavRequest()
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                VStack(spacing: 0)
                {
                    Color.white
                        .frame(height: UIScreen.main.bounds.height * 0.16) // Adjust height as needed
                    
                    Image("App_background")
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.height * 0.84) // Adjust height as needed
                        .clipped()
                    
                }
                .edgesIgnoringSafeArea(.all) // Ensure it spans the entire screen
                
                VStack
                {
                    
                    WeatherCard(viewModel: viewModel, cityName: cityName)
                    
                    WeatherDetail(viewModel: viewModel)
                    
                    WeatherListDay(weekData: $weekData)
                    
                    Spacer()
                }
                VStack
                {
                    if !autoView.suggestions.isEmpty
                    {
                        VStack(spacing: 5)
                        {
                            ForEach(autoView.suggestions.prefix(5), id: \.self) { suggestion in
                                Text(suggestion)
                                    .padding()
                                    .frame(maxWidth: 400, alignment: .leading)
                                    .foregroundColor(.black)
                                    .onTapGesture {
                                        // Handle selection logic
                                        print("Selected city: \(suggestion)")
                                        isSelectingSuggestion = true
                                        autoView.suggestions = [] // Clear suggestions after selection
                                        autoView.searchText = suggestion
                                        jumpPage(cityName: suggestion)
                                        {
                                            selectedCity = suggestion
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                                        {
                                            isSelectingSuggestion = false
                                        }
                                        autoView.suggestions = []
                                    }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.9))
                                .shadow(radius: 2)
                        )
                        .frame(maxWidth:300)
                        .offset(x:-30, y:55)
                    }
                    
                    Spacer()
                }
                .onAppear{
                    selectedCity = nil
                }
            }
            .searchable(text: $autoView.searchText, prompt: "Enter city name")
            .onChange(of: autoView.searchText)
            {
                newValue in if !isSelectingSuggestion{ autoView.fetchSuggestions()}
            }
            
            NavigationLink(
                destination: WeatherDetailView(city: selectedCity ?? "", weekData: apiData ?? [], dayData: dataExtract, isFavCity: isFavCity),
                tag: selectedCity ?? "",
                selection: $selectedCity)
            {
                EmptyView()
            }
        }
    }
    
    func jumpPage(cityName: String, completion: @escaping () -> Void)
    {
        SwiftSpinner.show("Fetching Weather Details for \(cityName)")
        
        let getCoord = LocGeoCoder()
        let locationExtract = TmrRequest()
        
        checkFavCity(city: cityName)
        {
            isFavorCity in isFavCity = isFavorCity
        }
        
        getCoord.getCityCoordinates(for:cityName)
        {
            coordinates, error in
            if let error = error
            {
                print("error fetching location")
                SwiftSpinner.hide()
                completion()
                return
            }
            
            guard let coordinates = coordinates else {
                print("No coordinates found for \(cityName)")
                SwiftSpinner.hide()
                completion()
                return
            }
            
            let coord = "\(coordinates.latitude),\(coordinates.longitude)"
            locationExtract.getWeather(location:coord)
            {
                result in switch result
                {
                case .success (let data):
                    dataExtract.parseDay(data: data)
                    apiData = dataExtract.parseWeek(data: data)
                    print("Extract Data jumpPage")
                case .failure (let error):
                    print("Error")
                }
                SwiftSpinner.hide()
                completion()
            }
                
            }
    }
    
    func checkFavCity(city: String, completion: @escaping (Bool) -> Void)
    {
        var favCity: Bool = false
        favRequest.getCity
        {
            result in DispatchQueue.main.async
            {
                    switch result
                    {
                        case .success(let maps):
                        // Check if the city is in the fetched data
                        maps.forEach({
                            print("Hi: " + $0.city.lowercased())
                        })
                            favCity = maps.contains { $0.city.lowercased() == city.lowercased() }
                            completion(favCity)
                        case .failure:
                            favCity = false // Assume city does not exist on failure
                            completion(favCity)
                    }
            }
        }
    }
    
    struct WeatherCard: View {
        @ObservedObject var viewModel: ParseData
        var cityName: String
        
        var body: some View
        {
            ZStack
            {
                NavigationLink(destination: WeatherDetailDay(viewModel: viewModel, cityName: cityName))
                {
                    RoundedRectangle(cornerRadius:20)
                        .fill(Color.white.opacity(0.2))
                        .frame(width:300, height:150)
                        .shadow(radius: 10)
                }
                .buttonStyle(PlainButtonStyle())
                
                HStack
                {
                    Image(viewModel.code)
                        .resizable()
                        .scaledToFit()
                        .frame(width:100, height:100)
                    
                    VStack(alignment: .leading)
                    {
                        Text(viewModel.temperature)
                        Text(viewModel.code)
                        Text(cityName)
                    }
                }
            }
            .padding(.top,110)
        }
    }
    
    struct WeatherDetail: View {
        @ObservedObject var viewModel: ParseData
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
                    Text(viewModel.hum)
                }
                VStack
                {
                    Text("Wind Speed")
                    Image("WindSpeed")
                        .resizable()
                        .scaledToFit()
                        .frame(width:80, height:80)
                    Text(viewModel.wSpeed)
                }
                VStack
                {
                    Text("Visibility")
                    Image("Visibility")
                        .resizable()
                        .scaledToFit()
                        .frame(width:80, height:80)
                    Text(viewModel.vis)
                }
                VStack
                {
                    Text("Pressure")
                    Image("Pressure")
                        .resizable()
                        .scaledToFit()
                        .frame(width:80, height:80)
                    Text(viewModel.pres)
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
                
                // Sunrise Icon
                Image("sun-rise")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.orange)
                
                Text(riseTime)
                
                Spacer(minLength: 3) // Reduce the minimum space between elements
                
                // Sunset Icon
                Image("sun-set")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                
                Text(setTime)
            }
            .padding(.vertical, 10)
            .frame(maxWidth:300, maxHeight:20)
            .scaledToFit()
            
        }
    }
    
    struct WeatherListDay: View
    {
        @Binding var weekData: [[String: String]] // Weekly weather data
        /*let weatherData =
         [
         ("11/15/2024", "Mostly Clear", "1:00pm", "2:00pm"),
         ("11/16/2024", "Mostly Clear", "1:00pm", "2:00pm"),
         ("11/17/2024", "Mostly Clear", "1:00pm", "2:00pm"),
         ("11/18/2024", "Mostly Clear", "1:00pm", "2:00pm"),
         ("11/19/2024", "Mostly Clear", "1:00pm", "2:00pm"),
         ("11/20/2024", "Mostly Clear", "1:00pm", "2:00pm"),
         ]*/
        
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
    
    /*#Preview {
     ContentView(viewModel: ParseData)
     }*/
}
