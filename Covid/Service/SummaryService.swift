//
//  SummaryService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation
import CoreData

typealias SummaryResult = Result<Summary, Error>
protocol ISummaryService {
    func getSummary(completion: @escaping (SummaryResult) -> Void)
}

struct SummaryService: ISummaryService {
    private let networkService: IHTTPClient
    private let coreDataService: ISummaryCoreDataService
    private let analyticsReporterService: IAnalyticsReporterService
    init(_ dependencies: IDependencies) {
        networkService = dependencies.networkService
        coreDataService = dependencies.summaryCoreDataService
        analyticsReporterService = dependencies.analyticsReporterService
    }
    func getSummary(completion: @escaping (SummaryResult) -> Void) {
        coreDataService.fetch { result in
            switch result {
            case .success(let summary):
                if let summary = summary {
                    analyticsReporterService.reportEvent(with: "GET Summary from storage", parameters: nil)
                    OperationQueue.mainAsyncIfNeeded {
                        completion(.success(summary))
                    }
                } else {
                    analyticsReporterService.reportEvent(with: "GET Summary from internet", parameters: nil)
                    downloadSummary(completion: completion)
                }
            case .failure:
                fatalError()
            }
        }
    }
}

// MARK: - Private
extension SummaryService {
    private func downloadSummary(completion: @escaping (SummaryResult) -> Void) {
        networkService.request(target: .summary) { result in
            let returnedResult: SummaryResult
            defer {
                OperationQueue.mainAsyncIfNeeded {
                    completion(returnedResult)
                }
            }
            switch result {
            case .success(let data):
                do {
                    let model = try data.decoded() as Summary
                    coreDataService.update(summary: model)
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
struct SummaryServiceMock: ISummaryService {
    func getSummary(completion: @escaping (SummaryResult) -> Void) {
        completion(.success(loadJson(bundle: .main, fileName: "summary", type: Summary.self)))
    }
}
