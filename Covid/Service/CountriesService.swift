//
//  CountriesService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

typealias CountriesResult = Result<[Country], Error>
protocol ICountriesService {
    func getCountries(completion: @escaping (CountriesResult) -> Void)
}

struct CountriesService: ICountriesService {
    private let networkService: IHTTPClient
    
    init(_ dependencies: IDependencies) {
        networkService = dependencies.networkService
    }
    func getCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        downloadCountries(completion: completion)
    }
}

// MARK: - Private
extension CountriesService {
    private func downloadCountries(completion: @escaping (CountriesResult) -> Void) {
        networkService.request(target: .countries) { result in
            var returnedResult: CountriesResult
            defer {
                OperationQueue.mainAsyncIfNeeded {
                    completion(returnedResult)
                }
            }
            switch result {
            case .success(let data):
                do {
                    let model = try data.decoded() as [Country]
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

// MARK: - CountriesService Mock
struct CountriesServiceMock: ICountriesService {
    func getCountries(completion: @escaping (CountriesResult) -> Void) {
        completion(.success(loadJson(bundle: .main, fileName: "countries", type: [Country].self)))
    }
}
