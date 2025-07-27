//
//  DefaultContainer.swift
//  SportPerformance
//
//  Created by Ivan Fabri on 26/07/2025.
//

import Foundation
import CoreData

protocol DIContainer: AnyObject {
    @MainActor
    func makeSportPerformanceListViewModel() -> SportPerformanceListViewModel

    @MainActor
    func makeAddSportPerformanceViewModel() -> AddSportPerformanceViewModel
}

final class DefaultContainer: DIContainer {
    private let persistentContainer: PersistentContainerProtocol
    private let fetchSportPerformancesUseCase: FetchSportPerformancesUseCase
    private let saveSportPerformanceUseCase: SaveSportPerformanceUseCase
    private let deleteSportPerformanceUseCase: DeleteSportPerformanceUseCase

    init() {
        let container: PersistentContainerProtocol = DefaultPersistentContainer(name: "SportPerformance")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }
        self.persistentContainer = container
        let remoteDataSource = SportPerformanceAPIDataSource()
        let localDataSource = SportPerformanceCoreDataDataSource(context: persistentContainer.viewContext)
        let repository = SportPerformanceRepositoryImpl(
            remote: remoteDataSource,
            local: localDataSource
        )

        fetchSportPerformancesUseCase = FetchSportPerformancesUseCase(repository: repository)
        saveSportPerformanceUseCase = SaveSportPerformanceUseCase(repository: repository)
        deleteSportPerformanceUseCase = DeleteSportPerformanceUseCase(repository: repository)
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
