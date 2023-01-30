//
//  MyCountryViewModel.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

enum MyCountryDataType {
    case confirmed
    case recovered
    case active
    case death
}

protocol MyCountryViewModelDelegate: AnyObject {
    var updateHandler: (([DetailCountry]) -> Void)? { get set }
    var updateNameHandler: ((String) -> Void)? { get set }
    func getCountry()
    func getChartAndTotalValue(_ type: MyCountryDataType) -> ([Chart], Int)
}

final class MyCountryViewModel: MyCountryViewModelDelegate {
    var updateHandler: (([DetailCountry]) -> Void)?
    var updateNameHandler: ((String) -> Void)?
    private var dataService: ICountryService?
    private var userDefaultsRepository: IUserDefaultsRepository?
    private var country: [DetailCountry]?
    private var countryName: String = ""
    init(_ dependencies: IDependencies) {
        dataService = dependencies.myCountryService
        userDefaultsRepository = dependencies.userDefaultsRepository
    }
    
    func getCountry() {
        getCountryName()
        guard countryName.isNotEmpty else { return }
        dataService?.getCountry(countryName: countryName, completion: { result in
            switch result {
            case .success(let country):
                self.country = country
                self.updateHandler?(country)
            case .failure(let error):
                Log.error(error.localizedDescription)
            }
        })
    }
}

extension MyCountryViewModel {
    private func getCountryName() {
        userDefaultsRepository?.getMyCountry(completion: { [weak self] result in
            switch result {
            case .success(let country):
                let countryName = country.slug
                self?.countryName = countryName
                self?.updateNameHandler?(country.country)
            case .failure(let error):
                Log.error(error.localizedDescription)
            }
        })
    }
    
    func getChartAndTotalValue(_ type: MyCountryDataType) -> ([Chart], Int) {
        if let country = country {
            return (getCharts(type, country: country), getTotalValue(type, country: country))
        } else {
            return ([], 0)
        }
    }
    
    private func getTotalValue(_ type: MyCountryDataType, country: [DetailCountry]) -> Int {
        switch type {
        case .confirmed: return country.map { $0.confirmed }.reduce(0, +)
        case .recovered: return country.map { $0.recovered }.reduce(0, +)
        case .active: return country.map { $0.active }.reduce(0, +)
        case .death: return country.map { $0.deaths }.reduce(0, +)
        }
    }
    
    private func getCharts(_ type: MyCountryDataType, country: [DetailCountry]) -> [Chart] {
        switch type {
        case .confirmed: return country.map { Chart(value: $0.confirmed, text: $0.date) }
        case .recovered: return country.map { Chart(value: $0.recovered, text: $0.date) }
        case .active: return country.map { Chart(value: $0.active, text: $0.date) }
        case .death: return country.map { Chart(value: $0.deaths, text: $0.date) }
        }
    }
}
