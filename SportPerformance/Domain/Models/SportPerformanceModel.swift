//
//  SportPerformanceModel.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import Foundation

struct SportPerformanceModel: Identifiable {
    public let id: String
    public let athlete: String
    public let sport: String
    public let score: Int
    public let isLocal: Bool
}

enum SaveMode {
    case local
    case backend
}
