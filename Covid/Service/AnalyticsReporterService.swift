//
//  AnalyticsReporterService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

protocol IAnalyticsReporterService {
    func reportEvent(with message: String, parameters: [String: Any]?)
}

struct AnalyticsReporterService: IAnalyticsReporterService {
    func reportEvent(with message: String, parameters: [String: Any]?) {
        Log.info(message)
    }
}
