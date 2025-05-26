//
//  ParseData.swift
//  finalassig
//
//  Created by Jerry Chu on 12/8/24.
//

import Foundation
import SwiftyJSON

class ParseData: ObservableObject
{
    @Published var startTime: String="N/A"
    @Published var temperature: String="N/A"
    @Published var code: String="N/A"
    @Published var hum: String="N/A"
    @Published var wSpeed: String="N/A"
    @Published var vis: String="N/A"
    @Published var pres: String="N/A"
    @Published var precProb: String="N/A"
    @Published var cloudCover: String="N/A"
    @Published var uv: String="N/A"
    
    func parseDay(data: [String: Any])
    {
        let json = JSON(data)
        if let weatherDayData = json["data"]["timelines"].array
        {
            if let weatherDayData1 = weatherDayData.first(where: { $0["timestep"].stringValue == "current" })
            {
                self.startTime = weatherDayData1["startTime"].stringValue
                
                if let intervals = weatherDayData1["intervals"].array
                {
                    if let intervals2 = intervals.first
                    {
                        let values = intervals2["values"]
                        self.temperature = values["temperature"].stringValue
                        self.code = findIcon(status: values["weatherCode"].stringValue)
                        self.hum = values["humidity"].stringValue
                        self.wSpeed = values["windSpeed"].stringValue
                        self.vis = values["visibility"].stringValue
                        self.pres = values["pressureSeaLevel"].stringValue
                        self.precProb = values["precipitationProbability"].stringValue
                        self.cloudCover = values["cloudCover"].stringValue
                        self.uv = values["uvIndex"].stringValue
                        
                        
                        print("temp: \(self.pres)")
                    }
                }
                
            }
        }
    }
    
    func parseWeek(data: [String: Any]) -> [[String: String]]
    {
        let json = JSON(data)
        var weekData: [[String: String]] = []
        let inputFormatter = DateFormatter()
        let outputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        outputFormatter.dateFormat = "MM/dd/yyyy"
        
        if let weatherDayData = json["data"]["timelines"].array
        {
            if let weatherDayData1 = weatherDayData.first(where: { $0["timestep"].stringValue == "1d" })
            {
                if let intervals = weatherDayData1["intervals"].array
                {
                    for interval in intervals.prefix(6)
                    {
                        var startTime = "N/A"
                        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
                        outputFormatter.dateFormat = "MM/dd/yyyy"
                        if let date = inputFormatter.date(from: interval["startTime"].stringValue)
                        {
                            startTime = outputFormatter.string(from: date)
                        }
                        //let startTime = interval["startTime"].stringValue
                        let values = interval["values"]
                        let temperature = values["temperature"].stringValue
                        let code = findIcon(status: values["weatherCode"].stringValue)
                        let hum = values["humidity"].stringValue
                        let wSpeed = values["windSpeed"].stringValue
                        let vis = values["visibility"].stringValue
                        let pres = values["pressureSeaLevel"].stringValue
                        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
                        var sunriseTime = "N/A"
                        if let time = inputFormatter.date(from: values["sunriseTime"].stringValue )
                        {
                            outputFormatter.dateFormat = "h:mma"
                            outputFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
                            sunriseTime = outputFormatter.string(from: time)
                        }
                        //let sunriseTime = values["sunriseTime"].stringValue
                        var sunsetTime = "N/A"
                        if let time = inputFormatter.date(from: values["sunsetTime"].stringValue )
                        {
                            outputFormatter.dateFormat = "h:mma"
                            outputFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
                            sunsetTime = outputFormatter.string(from: time)
                        }
                        //let sunsetTime = values["sunsetTime"].stringValue
                        
                        weekData.append([
                            "startTime": startTime,
                            "temperature": temperature,
                            "code": code,
                            "sunriseTime": sunriseTime,
                            "sunsetTime": sunsetTime])
                    }
                }
                
            }
        }
        return weekData
        
    }
    
    func findIcon(status:String) -> String
    {
        if (status == "1000")
        {
            return "Clear";
        }
        else if (status == "1100")
        {
            return "Mostly Clear";
        }
        else if(status == "1101")
        {
            return "Partly Clear";
        }
        else if(status == "1102")
        {
            return "Mostly Cloudy";
        }
        else if(status == "1001")
        {
            return "Cloudy";
        }
        else if(status == "1103")
        {
            return "Partly Cloudy"
        }
        else if(status == "2100")
        {
            return "Light Fog"
        }
        else if(status == "2000")
        {
            return "Fog"
        }
        else if(status == "2101")
        {
            return "Mostly Clear"
        }
        else if(status == "4000")
        {
            return "Drizzle"
        }
        else if(status == "4200")
        {
            return "Light Rain"
        }
        else if(status == "4001")
        {
            return "Rain"
        }
        else if(status == "4201")
        {
            return "Heavy Rain"
        }
        else if(status == "5001")
        {
            return "Flurries"
        }
        else if(status == "5100")
        {
            return "Light Snow"
        }
        else if(status == "5000")
        {
            return "Snow"
        }
        else if(status == "5101")
        {
            return "Heavy Snow"
        }
        else if(status == "6000")
        {
            return "Freezing Drizzle"
        }
        else if(status == "6200")
        {
            return "Light Freezing Rain"
        }
        else if(status == "6001")
        {
            return "Freezing Rain"
        }
        else if(status == "6201")
        {
            return "Heavy Freezing Rain"
        }
        else if(status == "7102")
        {
            return "Light Ice Pellets"
        }
        else if(status == "7000")
        {
            return "Ice Pellets"
        }
        else if(status == "7101")
        {
            return "Heavy Ice Pellets"
        }
        else if(status == "8000")
        {
            return "Thunderstorm"
        }

        return "";
  }
}
