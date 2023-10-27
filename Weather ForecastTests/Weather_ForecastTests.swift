//
//  Weather_ForecastTests.swift
//  Weather ForecastTests
//
//  Created by Consultant on 10/26/23.
//

import XCTest
@testable import Weather_Forecast

final class Weather_ForecastTests: XCTestCase {
    
    var weatherManager: WeatherManager?
    var mockSession: MockNetworkSession!


    func loadMockJSON(named filename: String) -> Data? {
        if let url = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json") {
            return try? Data(contentsOf: url)
        }
        return nil
    }

    override func setUpWithError() throws {
        guard let mockData = loadMockJSON(named: "weatherData") else {
            XCTFail("Failed to load mock data")
            return
        }

        let mockResponse = HTTPURLResponse(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=0&lon=0&appid=8d82e17bc8b285661a57dcc0dbb79fec&units=imperial")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockSession = MockNetworkSession(mockData: mockData, mockResponse: mockResponse, mockError: nil)
        weatherManager = WeatherManager(session: mockSession!)
    }

    override func tearDownWithError() throws {
        mockSession = nil
        weatherManager = nil
    }

    func testGetCurrentWeatherSuccess() async throws {
        guard let manager = weatherManager else {
            XCTFail("WeatherManager not initialized")
            return
        }
        let result = try await manager.getCurrentWeather(latitude: 0, longitude: 0)
        XCTAssertEqual(result.name, "New York")
    }
    func testPerformanceExample() throws {
        measure {
        }
    }
}
