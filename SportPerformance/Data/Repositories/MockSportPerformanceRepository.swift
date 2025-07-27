//
//  MockSportPerformanceRepository.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import Foundation

final class MockSportPerformanceRepository: SportPerformanceRepositoryProtocol {

    private var storage: [SportPerformance] = [
        .init(id: UUID().uuidString, date: Date() - (10 * 60), isLocal: true, length: 200, name: "Strength", place: "Paris"),
        .init(id: UUID().uuidString, date: Date() - (20 * 60), isLocal: false, length: 1500, name: "Speed", place: "Lyon"),
        .init(id: UUID().uuidString, date: Date() - (30 * 60), isLocal: true, length: 5000, name: "Conditioning", place: "Marseille"),
    ]

    func fetchAll() async throws -> [SportPerformance] {
        storage
    }

    func save(_ performance: SportPerformance) async throws {
        storage.append(performance)
    }
    
    func delete(_ performance: SportPerformance) async throws {
        storage.removeAll { $0.id == performance.id }
    }
}
