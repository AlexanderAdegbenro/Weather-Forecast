import Foundation
import CoreLocation

// MARK: - WeatherManager
class WeatherManager: ObservableObject {
    
    enum WeatherError: Error {
        case invalidURL
        case badServerResponse
        case failedDecoding(DecodingError)
        case other(Error)
    }
    
    private let session: NetworkSession
    private let config: WeatherAPIConfiguration
    
    init(session: NetworkSession = URLSession.shared as NetworkSession,
         config: WeatherAPIConfiguration = .default) {
        self.session = session
        self.config = config
    }
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        let url = config.urlForCurrentWeather(latitude: latitude, longitude: longitude)
        return try await fetchDataAndDecode(from: url, decodingType: ResponseBody.self)
    }
    
    func getFiveDayForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> Welcome {
        let url = config.urlForFiveDayForecast(latitude: latitude, longitude: longitude)
        return try await fetchDataAndDecode(from: url, decodingType: Welcome.self)
    }
    
    private func fetchDataAndDecode<T: Decodable>(from url: URL, decodingType: T.Type) async throws -> T {
        let (data, response) = try await self.session.fetchData(for: URLRequest(url: url))
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.badServerResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            throw WeatherError.failedDecoding(error)
        } catch {
            throw WeatherError.other(error)
        }
    }
}

// MARK: - Network Session
protocol NetworkSession {
    func fetchData(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {
    func fetchData(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request)
    }
}

// MARK: - WeatherAPIConfiguration
struct WeatherAPIConfiguration {
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let apiKey = "8d82e17bc8b285661a57dcc0dbb79fec"
    private let units = "imperial"
    
    static let `default` = WeatherAPIConfiguration()
    
    func urlForCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL {
        return URL(string: "\(baseURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units)")!
    }
    
    func urlForFiveDayForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL {
        return URL(string: "\(baseURL)/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units)")!
    }
}
