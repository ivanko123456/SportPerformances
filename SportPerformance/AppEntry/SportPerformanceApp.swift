//
//  SportPerformanceApp.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import SwiftUI
import Firebase

@main
struct SportPerformanceApp: App {
    private let container: DIContainer = DefaultContainer()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SportPerformanceListView()
                .environment(\.container, container)
        }
    }
}
