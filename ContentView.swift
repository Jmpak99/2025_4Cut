//
//  ContentView.swift
//  fourcut
//
//  Created by 박종민 on 11/21/24.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > 600 {
                // iPad 레이아웃
                HomeView()
            } else {
                // iPhone 레이아웃
                MobileHomeView()
            }
        }
    }
}


#Preview {
    ContentView()
}

