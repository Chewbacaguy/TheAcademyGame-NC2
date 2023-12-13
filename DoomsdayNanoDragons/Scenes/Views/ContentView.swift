//
//  ContentView.swift
//  DoomsdayNanoDragons
//
//  Created by Santiago Torres Alvarez on 13/12/23.
//

import SwiftUI


@main
struct YourGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            IntroView()
        }
    }
}

#Preview {
    ContentView()
}
