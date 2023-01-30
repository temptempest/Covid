//
//  HTTPError.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

public enum HTTPError: LocalizedError {
    // Received an invalid response, e.g. non-HTTP result
    case invalidResponse
    // Server-side validation error
    case validationError(String)
    // General server-side error. If `retryAfter` is set, the client can send the same request after the given time.
    case serverError(statusCode: Int, reason: String? = nil, retryAfter: String? = nil)
    // The server sent data in an unexpected format
    case badURL(url: URL)
    case decodingError
    case timedOut(url: URL)
    case notConnectedToInternet
    case transportError(Error)
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case unclassifiedError(Error)
    case unknown
    public var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response"
        case .validationError(let reason): return "Validation Error: \(reason)"
        case .serverError(let statusCode, let reason, let retryAfter):
            return "Server error with code \(statusCode)," +
            " reason: \(reason ?? "no reason given")," +
            "retry after: \(retryAfter ?? "no retry after provided")"
        case .badURL(url: let url): return "Bad url: \(url)"
        case .timedOut(url: let url): return "Timed out: \(url)"
        case .notConnectedToInternet: return "Not connected to internet"
        case .transportError(let error): return "Transport error: \(error)"
        case .decodingError: return "The server returned data in an unexpected format. Try updating the model"
        case .unclassifiedError(let error): return "Error \(error)"
        case .unknown: return "Unknown error occured"
        }
    }
}
