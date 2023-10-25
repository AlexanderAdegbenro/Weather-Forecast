import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    
    enum WeatherError: Error {
        case invalidURL
        case badServerResponse
        case failedDecoding
        case other(Error)
    }
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=imperial") else {
            throw WeatherError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.badServerResponse
        }
        print(String(data: data, encoding: .utf8) ?? "Invalid data")
        do {
            let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            print("Error localized description: \(error.localizedDescription)")
            if let decodingError = error as? DecodingError {
                print(decodingError)
            }
            throw WeatherError.failedDecoding
        }
    }
    
    func getFiveDayForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> Welcome {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=imperial") else {
            throw WeatherError.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.badServerResponse
        }
        do {
            let decodedData = try JSONDecoder().decode(Welcome.self, from: data)
            return decodedData
        } catch {
            throw WeatherError.failedDecoding
        }
    }
}
