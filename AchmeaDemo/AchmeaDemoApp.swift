//
//  AchmeaDemoApp.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import SwiftUI

@main
struct AchmeaDemoApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(viewModel: .init(apiService: APIService(), employerRepository: CDEmployerRepository()))
        }
    }
}
