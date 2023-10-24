//
//  LoadingView.swift
//  Weather Forecast
//
//  Created by Consultant on 10/24/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
     ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
