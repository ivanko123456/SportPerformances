//
//  MockDIContainer.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import Foundation

final class MockDIContainer: DIContainer {
    private let fetchSportPerformancesUseCase: FetchSportPerformancesUseCase
    private let saveSportPerformanceUseCase: SaveSportPerformanceUseCase
    private let deleteSportPerformanceUseCase: DeleteSportPerformanceUseCase

    init() {
        let mockRepository = MockSportPerformanceRepository()
        
        fetchSportPerformancesUseCase = FetchSportPerformancesUseCase(repository: mockRepository)
        saveSportPerformanceUseCase = SaveSportPerformanceUseCase(repository: mockRepository)
        deleteSportPerformanceUseCase = DeleteSportPerformanceUseCase(repository: mockRepository)
    }
    
    func makeSportPerformanceListViewModel() -> SportPerformanceListViewModel {
        SportPerformanceListViewModel(
            fetchSportPerformancesUseCase: fetchSportPerformancesUseCase,
            deleteSportPerformanceUseCase: deleteSportPerformanceUseCase
        )
    }
    
    func makeAddSportPerformanceViewModel() -> AddSportPerformanceViewModel {
        AddSportPerformanceViewModel(
            saveSportPerformanceUseCase: saveSportPerformanceUseCase
        )
    }
}
