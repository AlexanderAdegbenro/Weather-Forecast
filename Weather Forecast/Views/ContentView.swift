//
//  ContentView.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//
import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    @State private var isRefreshing: Bool = false

    func fetchWeather() async {
        guard let location = locationManager.location else {
            return
        }
        
        do {
            weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting weather: \(error)")
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    switch locationManager.authorizationStatus {
                    case .notDetermined:
                        LoadingView()
                    case .restricted, .denied:
                        PermissionsDeniedView()
                    case .authorizedWhenInUse, .authorizedAlways:
                        if let location = locationManager.location {
                            if let weather = weather {
                                WeatherView()
                            } else {
                                LoadingView()
                            }
                        } else {
                            LoadingView()
                        }
                    case .none:
                        Text("Unknown Location Status")
                    @unknown default:
                        Text("Unknown Location Status")
                    }
                }
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
            }
            .background(Color(red: 0.28627450980392155, green: 0.33725490196078434, blue: 0.4470588235294118))
            .onAppear {
                locationManager.requestLocation()
                Task {
                    await fetchWeather()
                }
            }
            .refreshable {
                Task {
                    await fetchWeather()
                }
            }
            .preferredColorScheme(.dark)
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
