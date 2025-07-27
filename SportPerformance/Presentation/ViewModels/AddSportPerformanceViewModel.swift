//
//  AddSportPerformanceViewModel.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import SwiftUI

@MainActor
final class AddSportPerformanceViewModel: ObservableObject {
    
    enum AddSportPerformanceError: Error, LocalizedError, Identifiable {
        case saveFailed(Error)

        public var id: String { localizedDescription }
        public var errorDescription: String? {
            switch self {
            case .saveFailed(let err):
                return err.localizedDescription
            }
        }
    }
    
    @Published var length = ""
    @Published var name = ""
    @Published var place = ""
    @Published var saveMode: SaveMode = .local
    @Published var isSaving = false
    @Published var error: AddSportPerformanceError?

    private let saveUseCase: SaveSportPerformanceUseCase
    private var parsedLength: Double {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter.number(from: length)?.doubleValue ?? 0
    }

    init(saveSportPerformanceUseCase: SaveSportPerformanceUseCase) {
        self.saveUseCase = saveSportPerformanceUseCase
    }

    var isValid: Bool {
        !name.isEmpty &&
        !place.isEmpty &&
        !length.isEmpty &&
        Double(length) != .zero
    }

    @MainActor
    func save() async {
        isSaving = true
        do {
            let performance = SportPerformance(
                id: UUID().uuidString,
                date: Date(),
                isLocal: saveMode == .local,
                length: parsedLength,
                name: name,
                place: place
            )
            try await saveUseCase.execute(performance)
        } catch {
            self.error = .saveFailed(error)
        }
        isSaving = false
    }
}
