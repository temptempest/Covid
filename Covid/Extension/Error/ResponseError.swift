//
//  ResponseError.swift
//  Covid
//
//  Created by temptempest on 18.12.2022.
//

import Foundation
import Moya

extension Response {
     func handle(url: URL) throws -> Data {
        guard let response = response else {
            throw HTTPError.invalidResponse
        }
        guard response.statusCode >= 200 && response.statusCode < 300 else {
            let statusCode = response.statusCode
            if (500..<600) ~= statusCode {
                throw HTTPError.serverError(statusCode: statusCode)
            } else if response.statusCode == 400 {
                throw HTTPError.validationError("")
            } else {
                throw HTTPError.badURL(url: url)
            }
        }
        return data
    }
}
