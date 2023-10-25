import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                VStack {
                    Text(viewModel.weather?.name ?? "Unknown")
                        .font(.largeTitle)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                VStack {
                    WeatherIconView(iconCode: viewModel.weather?.weather[0].icon ?? "")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                        .padding()
                    HStack {
                      
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.weather?.weather[0].main ?? "Unknown")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            Text(String(format: "%.1f°", viewModel.weather?.main.feelsLike ?? 0.0))
                                .font(.system(size: 70))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                        .frame(height: UIScreen.main.bounds.width * 0.3)
                    }
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                }
                
              
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("5-DAY FORECAST")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        let nonOptionalForecast = viewModel.forecastData?.list ?? []
                        let groupedForecasts = Dictionary(grouping: nonOptionalForecast, by: { Date(timeIntervalSince1970: TimeInterval($0.dt)).formatted(.dateTime.day()) })
                        let sortedKeys = Array(groupedForecasts.keys.sorted().prefix(5))
                        
                        ForEach(sortedKeys, id: \.self) { day in
                            if let dailyForecasts = groupedForecasts[day] {
                                let averageTemp = dailyForecasts.reduce(0, { $0 + $1.main.temp }) / Double(dailyForecasts.count)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(Date(timeIntervalSince1970: TimeInterval(dailyForecasts[0].dt)).formatted(.dateTime.month().day()))
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    WeatherIconView(iconCode: dailyForecasts[0].weather[0].icon)
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                    
                                    Text("\(averageTemp.roundDouble())°")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                }
                .padding(.top, 80)
            }
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.fetchWeather()
            viewModel.fetchForecast()
        }
        .background(Color(red: 0.28627450980392155, green: 0.33725490196078434, blue: 0.4470588235294118))
        .ignoresSafeArea()
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
