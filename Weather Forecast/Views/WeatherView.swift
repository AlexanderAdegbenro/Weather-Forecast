import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var headerContent: some View {
        VStack {
            Text(viewModel.weather?.name ?? "Loading..")
                .font(.largeTitle)
                .fontWeight(.regular)
                .foregroundColor(.white)
            
            Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    var mainWeatherContent: some View {
        VStack {
            WeatherIconView(iconCode: viewModel.weather?.weather[0].icon ?? "")
                .font(.system(size: 70))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
                .padding()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.weather?.weather[0].main ?? "Loading..")
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
    }
    
    var fiveDayForecastContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("5-DAY FORECAST")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            let groupedForecasts = Dictionary(grouping: viewModel.forecastData?.list ?? [], by: { Date(timeIntervalSince1970: TimeInterval($0.dt)).formatted(.dateTime.day()) })
            
            let currentDate = Calendar.current.startOfDay(for: Date())
            let filteredKeys = groupedForecasts.keys.filter { dateKey in
                return DateFormatter.localizedString(from: currentDate, dateStyle: .short, timeStyle: .none) != dateKey
            }.sorted()
            
            ForEach(filteredKeys.prefix(5), id: \.self) { day in
                if let dailyForecasts = groupedForecasts[day], let firstForecast = dailyForecasts.first {
                    let averageTemp = dailyForecasts.reduce(0, { $0 + $1.main.temp }) / Double(dailyForecasts.count)
                    
                    HStack {
                        Text(Date(timeIntervalSince1970: TimeInterval(firstForecast.dt)).formatted(.dateTime.month().day()))
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        WeatherIconView(iconCode: firstForecast.weather[0].icon)
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
    
    
    var body: some View {
            ZStack {
                if viewModel.weather == nil {
                    ProgressView()
                        .scaleEffect(1.5)
                        .animation(.easeInOut(duration: 0.5))
                } else {
                    VStack(spacing: 10) {
                        headerContent
                        mainWeatherContent
                        ScrollView {
                            LazyVStack {
                                fiveDayForecastContent
                            }
                            .padding(.top, 80)
                            .refreshable {
                                viewModel.requestLocation()
                                viewModel.fetchWeather()
                                viewModel.fetchForecast()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if viewModel.isRefreshing {
                        ProgressView()
                            .scaleEffect(1.5)
                            .opacity(viewModel.isRefreshing ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5))
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .preferredColorScheme(.dark)
            .background(Color(red: 0.286, green: 0.337, blue: 0.447))
            .ignoresSafeArea()
        }}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
