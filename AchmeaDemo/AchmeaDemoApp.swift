//
//  AchmeaDemoApp.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import SwiftUI

@main
struct AchmeaDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
