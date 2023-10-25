//  WeatherModel.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import Foundation

struct ResponseBody: Decodable {
    
    var coord: CoordinatesResponse
     var weather: [WeatherResponse]
     var main: MainResponse
     var name: String
     var wind: WindResponse
     var list: [ForecastResponse]?
     var visibility: Int?
     var dt: Int?
     var sys: SysResponse?
     var clouds: CloudsResponse?
     var base: String?

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
    
    struct ForecastResponse: Decodable {
        var dt: Int
             var main: MainResponse
             var weather: [WeatherResponse]
             var dt_txt: String
     }
    
    struct SysResponse: Decodable {
           var type: Int?
           var id: Int?
           var country: String?
           var sunrise: Int?
           var sunset: Int?
       }
    
    struct CloudsResponse: Decodable {
        var all: Int?
    }
}


extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
