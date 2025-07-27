//
//  SportPerformanceListViewModel.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import SwiftUI

@MainActor
final class SportPerformanceListViewModel: ObservableObject {
    enum Filter: CaseIterable, Identifiable {
        case all, local, backend

        var id: Filter { self }

        var title: LocalizedStringKey {
            switch self {
            case .all: return L10n.SportPerformanceList.filterAll
            case .local: return L10n.SportPerformanceList.filterLocal
            case .backend: return L10n.SportPerformanceList.filterRemote
            }
        }
    }

    @Published var performances: [SportPerformance] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var filter: Filter = .all

    private let fetchUseCase: FetchSportPerformancesUseCase
    private let deleteUseCase: DeleteSportPerformanceUseCase

    public init(
        fetchSportPerformancesUseCase: FetchSportPerformancesUseCase,
        deleteSportPerformanceUseCase: DeleteSportPerformanceUseCase
    ) {
        self.fetchUseCase = fetchSportPerformancesUseCase
        self.deleteUseCase = deleteSportPerformanceUseCase
    }

    func loadPerformances() async {
        isLoading = true
        do {
            performances = try await fetchUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func deletePerformances(at offsets: IndexSet) async {
        for offset in offsets {
            let performance = filteredPerformances[offset]
            do {
                try await deleteUseCase.execute(performance)
                if let index = performances.firstIndex(where: { $0.id == performance.id }) {
                    performances.remove(at: index)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
        await loadPerformances()
    }
    
    public var filteredPerformances: [SportPerformance] {
        switch filter {
        case .all:
            return performances
        case .local:
            return performances.filter { $0.isLocal }
        case .backend:
            return performances.filter { !$0.isLocal }
        }
    }
}
