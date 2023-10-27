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
    @State private var hasLoadedData = false
    
    func fetchWeather() async {
        guard let location = locationManager.location else { return }
        
        do {
            weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting weather: \(error)")
        }
    }
    
    var weatherContent: some View {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return AnyView(LoadingView())
        case .restricted, .denied:
            return AnyView(PermissionsDeniedView())
        case .authorizedWhenInUse, .authorizedAlways:
            if locationManager.location != nil && weather != nil {
                return AnyView(WeatherView())
            } else {
                return AnyView(LoadingView())
            }
        case .none:
            return AnyView(Text("Unknown Location Status"))
        @unknown default:
            return AnyView(Text("Unknown Location Status"))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    weatherContent
                }
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
            }
            .background(Color(red: 0.28627450980392155, green: 0.33725490196078434, blue: 0.4470588235294118))
            .onAppear {
                if !hasLoadedData {
                    locationManager.requestLocation()
                    Task {
                        await fetchWeather()
                    }
                    hasLoadedData = true
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
