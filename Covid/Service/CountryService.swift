//
//  CountryService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

typealias CountryResult = Result<[DetailCountry], Error>
protocol ICountryService {
    func getCountry(countryName: String, completion: @escaping (CountryResult) -> Void)
}

struct CountryService: ICountryService {
    private let networkService: IHTTPClient
    private let coreDataService: ICountryCoreDataService
    private let analyticsReporterService: IAnalyticsReporterService
    init(_ dependencies: IDependencies) {
        coreDataService = dependencies.detailCountryCoreDataService
        networkService = dependencies.networkService
        analyticsReporterService = dependencies.analyticsReporterService
    }
    func getCountry(countryName: String, completion: @escaping (CountryResult) -> Void) {
        coreDataService.fetch { result in
            switch result {
            case .success(let detailCountries):
                if let detailCountries = detailCountries {
                    analyticsReporterService.reportEvent(with: "GET MyCountry from storage", parameters: nil)
                    OperationQueue.mainAsyncIfNeeded {
                        completion(.success(detailCountries))
                    }
                } else {
                    analyticsReporterService.reportEvent(with: "GET MyCountry from internet", parameters: nil)
                    downloadCountry(countryName: countryName, completion: completion)
                }
            case .failure:
                fatalError()
            }
        }
    }
}

// MARK: - Private
extension CountryService {
    private func downloadCountry(countryName: String, completion: @escaping (CountryResult) -> Void) {
        let slug = countryName.lowercased()
        let today = Date.today.stringValue()
        let monthAgo = Date.lastMonth.stringValue()
        networkService.request(target: .countryDailyInfo(countrySlug: slug,
                                                         day: today,
                                                         dayBefore: monthAgo)) { result in
            let returnedResult: CountryResult
            defer {
                OperationQueue.mainAsyncIfNeeded {
                    completion(returnedResult)
                }
            }
            switch result {
            case .success(let data):
                do {
                    let models = try data.decoded() as [DetailCountry]
                    coreDataService.update(models: models)
                    returnedResult = .success(models)
                } catch let error {
                    returnedResult = .failure(error)
                }
            case .failure(let error):
                returnedResult = .failure(error)
            }
        }
    }
}

// MARK: - CountryService Mock
struct CountryServiceMock: ICountryService {
    func getCountry(countryName: String, completion: @escaping (CountryResult) -> Void) {
        completion(.success(loadJson(bundle: .main, fileName: "countryRussia", type: [DetailCountry].self)))
    }
}
