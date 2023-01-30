//
//  AllCountryViewModel.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

enum AllCountryDataType {
    case totalConfirmed
    case totalRecovered
    case totalDeath
    case newConfirmed
    case newRecovered
    case newDeath
}

protocol AllCountryViewModelDelegate: AnyObject {
    var updateSummaryHandler: ((Summary) -> Void)? { get set }
    var updateChartsHandler: (([World]) -> Void)? { get set }
    func getSummary()
    func getTopTotalDeathCountryCharts() -> [Chart]
    func getChartsData()
    func getTotalChart(_ type: AllCountryDataType) -> ([Chart])
}

final class AllCountryViewModel: AllCountryViewModelDelegate {
    var updateSummaryHandler: ((Summary) -> Void)?
    var updateChartsHandler: (([World]) -> Void)?
    var updateHandler: ((Summary) -> Void)?
    private var summaryService: ISummaryService?
    private var worldService: IWorldService?
    private var summary: Summary?
    private var world: [World]?
    init(_ dependencies: IDependencies) {
        summaryService = dependencies.summaryService
        worldService = dependencies.worldService
    }
    func getSummary() {
        summaryService?.getSummary(completion: { result in
            switch result {
            case .success(let summary):
                self.summary = summary
                self.updateSummaryHandler?(summary)
            case .failure(let error):
                Log.error(error.localizedDescription)
            }
        })
    }
    func getChartsData() {
        worldService?.getWorld(completion: { result in
            switch result {
            case .success(let worlds):
                let sortedWorld: [World] = worlds.sorted(by: { $0.date < $1.date })
                self.world = sortedWorld
                self.updateChartsHandler?(sortedWorld)
            case .failure(let error):
                Log.error(error.localizedDescription)
            }
        })
    }
}

extension AllCountryViewModel {
    func getTopTotalDeathCountryCharts() -> [Chart] {
        guard let summary = summary else { return [] }
        let countryCharts = summary.countries.map { Chart(value: $0.totalDeaths, text: $0.country) }
        let topCountriesCharts = Array(countryCharts.sorted(by: {$0.value > $1.value})[0...3])
        return topCountriesCharts.enumerated().map { index, _ in
            var chart = topCountriesCharts[index]
            if chart.text == "Russian Federation" {
                chart.text = "Russia"
            }
            if chart.text == "United States of America" {
                chart.text = "USA"
            }
            return chart
        }
    }
    func getTotalChart(_ type: AllCountryDataType) -> ([Chart]) {
        guard let world = world else { return [] }
        switch type {
        case .totalConfirmed: return world.map { Chart(value: $0.totalConfirmed, text: $0.date) }
        case .totalRecovered: return world.map { Chart(value: $0.totalRecovered, text: $0.date) }
        case .totalDeath: return world.map { Chart(value: $0.totalDeaths, text: $0.date) }
        case .newConfirmed: return world.map { Chart(value: $0.newConfirmed, text: $0.date) }
        case .newRecovered: return world.map { Chart(value: $0.newRecovered, text: $0.date) }
        case .newDeath: return world.map { Chart(value: $0.newDeaths, text: $0.date) }
        }
    }
}
