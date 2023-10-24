import Foundation
import CoreLocation

class WeatherManager {
    
    enum WeatherError: Error {
        case invalidURL
        case badServerResponse
        case failedDecoding
        case other(Error)
    }
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=metric") else {
            throw WeatherError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.badServerResponse
        }
        
        do {
            let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
            return decodedData
        } catch {
            throw WeatherError.failedDecoding
        }
    }
    
    func getFiveDayForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=metric") else {
            throw WeatherError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        print(String(data: data, encoding: .utf8) ?? "Invalid data")
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.badServerResponse
        }
        
        do {
            let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
            return decodedData
        } catch {
            throw WeatherError.failedDecoding
        }
    }
}
