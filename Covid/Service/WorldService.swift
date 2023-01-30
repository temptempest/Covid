//
//  WorldService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

typealias WorldResult = Result<[World], Error>
protocol IWorldService {
    func getWorld(completion: @escaping (WorldResult) -> Void)
}

struct WorldService: IWorldService {
    private let networkService: IHTTPClient
    private let coreDataService: IWorldCoreDataService
    private let analyticsReporterService: IAnalyticsReporterService
    init(_ dependencies: IDependencies) {
        networkService = dependencies.networkService
        coreDataService = dependencies.worldCoreDataService
        analyticsReporterService = dependencies.analyticsReporterService
    }
    func getWorld(completion: @escaping (WorldResult) -> Void) {
        coreDataService.fetch { result in
            switch result {
            case .success(let worlds):
                if let worlds = worlds {
                    analyticsReporterService.reportEvent(with: "GET World from storage", parameters: nil)
                    OperationQueue.mainAsyncIfNeeded {
                        completion(.success(worlds))
                    }
                } else {
                    analyticsReporterService.reportEvent(with: "GET World from internet", parameters: nil)
                    downloadWord(completion: completion)
                }
            case .failure:
                fatalError()
            }
        }
    }
}

// MARK: - Private
extension WorldService {
    private func downloadWord(completion: @escaping (WorldResult) -> Void) {
        networkService.request(target: .world) { result in
            let returnedResult: WorldResult
            defer {
                OperationQueue.mainAsyncIfNeeded {
                    completion(returnedResult)
                }
            }
            switch result {
            case .success(let data):
                do {
                    let model = try data.decoded() as [World]
                    coreDataService.update(worlds: model)
                    returnedResult = .success(model)
                } catch let error {
                    returnedResult = .failure(error)
                }
            case .failure(let error):
                returnedResult = .failure(error)
            }
        }
    }
}

// MARK: - SummaryService Mock
struct WorldServiceMock: IWorldService {
    func getWorld(completion: @escaping (WorldResult) -> Void) {
        completion(.success(loadJson(bundle: .main, fileName: "world", type: [World].self)))
    }
}
