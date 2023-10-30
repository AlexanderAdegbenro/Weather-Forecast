//
//  WeatherRow.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import SwiftUI

struct WeatherRow: View {
    var name: String
    var value: String
    
    var body: some View {
        HStack(spacing: 15) {
            HStack() {
                Text(name)
                    .font(.caption)
                Text(value)
                    .bold()
                    .font(.title2)
            }
        }
    }
}


#Preview {
    WeatherRow(name: "Feels like", value: "8°")
}
