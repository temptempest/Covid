//
//  HTTPClient.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Moya
import Foundation

typealias HTTPResult = Result<Data, Error>
protocol IHTTPClient {
    func request(target: CovidEndpoint, completion: @escaping (HTTPResult) -> Void)
}

struct HTTPClient: IHTTPClient {
    private let provider = MoyaProvider<CovidEndpoint>()
    func request(target: CovidEndpoint, completion: @escaping (HTTPResult) -> Void) {
        provider.request(target) { result in
            var returnedResult: HTTPResult
            defer {
                completion(returnedResult)
            }
            switch result {
            case let .success(response):
                do {
                    let url = URL(target: target)
                    let data = try response.handle(url: url)
                    returnedResult = .success(data)
                } catch let error {
                    returnedResult = .failure(error)
                }
            case let .failure(error):
                returnedResult = .failure(error)
            }
        }
    }
}

// MARK: - Retry Fallback
extension IHTTPClient {
    func retry(_ retryCount: UInt) -> IHTTPClient {
        var service: IHTTPClient = self
        for _ in 0..<retryCount {
            service = service.fallback(self)
        }
        return service
    }
    private func fallback(_ fallback: IHTTPClient) -> IHTTPClient {
        IHTTPServiceWithFallback(primary: self, fallback: fallback)
    }
}

private struct IHTTPServiceWithFallback: IHTTPClient {
    let primary: IHTTPClient
    let fallback: IHTTPClient
    func request(target: CovidEndpoint, completion: @escaping (HTTPResult) -> Void) {
        primary.request(target: target) { result in
            switch result {
            case .success: completion(result)
            case .failure: fallback.request(target: target, completion: completion)
            }
        }
    }
}
