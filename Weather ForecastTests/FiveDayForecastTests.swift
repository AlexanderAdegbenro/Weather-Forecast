//
//  FiveDayForecastTests.swift
//  Weather ForecastTests
//
//  Created by Consultant on 10/26/23.
//

import XCTest
@testable import Weather_Forecast

final class FiveDayForecastTests: XCTestCase {
    
    var weatherManager: WeatherManager?
    var mockSession: MockNetworkSession!
    
    // Load mock JSON data from file
    func loadMockJSON(named filename: String) -> Data? {
        if let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json") {
            return try? Data(contentsOf: url)
        }
        return nil
    }

    override func setUpWithError() throws {
        guard let mockData = loadMockJSON(named: "fiveDayForecastData") else {
            XCTFail("Failed to load mock data for five-day forecast")
            return
        }

        let mockResponse = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=0&lon=0&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=imperial")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)
        
        mockSession = MockNetworkSession(mockData: mockData, mockResponse: mockResponse, mockError: nil)
        
        weatherManager = WeatherManager(session: mockSession!)
    }

    override func tearDownWithError() throws {
        weatherManager = nil
        mockSession = nil
    }
    
    // Test for a successful five-day forecast retrieval
    func testGetFiveDayForecastSuccess() async throws {
        guard let manager = weatherManager else {
            XCTFail("WeatherManager not initialized")
            return
        }
        do {
            let result = try await manager.getFiveDayForecast(latitude: 0, longitude: 0)

            XCTAssertEqual(result.list.count, 40, "Unexpected number of forecasts retrieved")
            
            // Test properties of the first forecast
            let firstForecast = result.list[0]
            
            XCTAssertEqual(firstForecast.main.temp, 291.67, accuracy: 0.01, "Unexpected temperature for the first forecast")
            XCTAssertEqual(firstForecast.main.humidity, 47, "Unexpected humidity for the first forecast")
            
            XCTAssertEqual(firstForecast.weather[0].description, "clear sky", "Unexpected weather description for the first forecast")
        } catch {
            XCTFail("Error fetching five-day forecast: \(error)")
        }
    }

    // Test for server returning a 500 error
    func testServerFailure() async throws {
        // Setup mockSession with a 500 status code
        let mockResponse = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=0&lon=0&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=imperial")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)

        mockSession.mockResponse = mockResponse
        mockSession.mockData = nil // No data for a server error
        mockSession.mockError = nil // No specific error, as the error is indicated by the status code

        // Reinitialize WeatherManager with the updated mockSession
        weatherManager = WeatherManager(session: mockSession!)

        do {
            _ = try await weatherManager?.getFiveDayForecast(latitude: 0, longitude: 0)
            XCTFail("Expected a server error but the call succeeded")
        } catch let error as MockNetworkSession.NetworkError {
            // Check for the specific error
            if case .invalidResponse = error {
                // This is the expected error
                // You can add more specific assertions if needed
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Test for malformed JSON data
    func testMalformedJSON() async throws {
        // Setup mockSession with malformed JSON data
        let malformedJSONData = Data("Malformed JSON Data".utf8)
        let mockResponse = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=0&lon=0&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=imperial")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)

        mockSession.mockResponse = mockResponse
        mockSession.mockData = malformedJSONData // Using malformed data
        mockSession.mockError = nil

        // Reinitialize WeatherManager with the updated mockSession
        weatherManager = WeatherManager(session: mockSession!)

        do {
            _ = try await weatherManager?.getFiveDayForecast(latitude: 0, longitude: 0)
            XCTFail("Expected a decoding error but the call succeeded")
        } catch let error as DecodingError {
            // Check for the specific decoding error
            // For example, you can check if it's a dataCorrupted error
            if case .dataCorrupted = error {
                // This is the expected error
                // You can add more specific assertions if needed
            } else {
                XCTFail("Unexpected decoding error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
