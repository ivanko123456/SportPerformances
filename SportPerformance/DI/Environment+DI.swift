//
//  Environment+DI.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import SwiftUI

private struct ContainerKey: EnvironmentKey {
    static var defaultValue: DIContainer {
        DefaultContainer()
    }
}

extension EnvironmentValues {
    var container: DIContainer {
        get { self[ContainerKey.self] }
        set { self[ContainerKey.self] = newValue }
    }
}
