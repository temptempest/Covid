//
//  CovidEndpoint.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Moya
import Foundation

enum CovidEndpoint {
    case countries
    case countryDailyInfo(countrySlug: String, day: String, dayBefore: String)
    case summary
    case world
}

extension CovidEndpoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: API.baseUrl) else { fatalError() }
        return url
    }
    var path: String {
        switch self {
        case .countries: return "countries"
        case .countryDailyInfo(countrySlug: let countrySlug, day: _, dayBefore: _):
            return "country/\(countrySlug)"
        case .summary: return "summary"
        case .world: return "world"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case let .countryDailyInfo(_, day, dayBefore):
            return .requestParameters(parameters: [
                "from": "\(dayBefore)T00:00:00Z",
                "to": "\(day)T00:00:00Z"],
                encoding: URLEncoding.queryString)
        case .summary, .world, .countries:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
