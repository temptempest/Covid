//
//  SearchCountryViewModel.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

protocol SearchCountryViewModelDelegate: AnyObject {
    var updateHandler: (([Country]) -> Void)? { get set }
    var updateFilteredHandler: (([Country]) -> Void)? { get set }
    var updateAlertHandler: ((String) -> Void)? { get set }
    var alertBuilder: IAlertsBuilder? { get }
    func getCountries()
    func getFlagImage(by country: Country)
    func selectCountry(country: Country)
    func updateSearchResults(searchText: String, countries: [Country], filteredCountries: [Country])
    func willDisplayCells(indexPath: IndexPath, isActiveSearch: Bool, countries: [Country], filteredCountries: [Country])
}

final class SearchCountryViewModel: SearchCountryViewModelDelegate {
    var updateAlertHandler: ((String) -> Void)?
    var updateHandler: (([Country]) -> Void)?
    var updateFilteredHandler: (([Country]) -> Void)?
    var alertBuilder: IAlertsBuilder?
    
    private var dataService: ICountriesService?
    private var flagImageService: IFlagImageService?
    private var userDefaultsRepository: IUserDefaultsRepository?
    private var contries: [Country] = []
    private let detailCountryCoreDataService: ICountryCoreDataService
    private let summaryCoreDataService: ISummaryCoreDataService
    private var allowedContries: [String] = []
    
    init(_ dependencies: IDependencies) {
        summaryCoreDataService = dependencies.summaryCoreDataService
        detailCountryCoreDataService = dependencies.detailCountryCoreDataService
        dataService = dependencies.countriesCountriesService
        flagImageService = dependencies.flagImageService
        userDefaultsRepository = dependencies.userDefaultsRepository
        alertBuilder = dependencies.alertBuilder
    }
    func getCountries() {
        setAllAllowedCountries()
        dataService?.getCountries(completion: { [weak self] result in
            switch result {
            case .success(let countries):
                var sortedCountries = countries.sorted(by: {$0.country < $1.country})
                if let allowedCountries = self?.allowedContries,
                   allowedCountries.isNotEmpty {
                    sortedCountries = sortedCountries.filter({ allowedCountries.contains($0.country) })
                }
                self?.contries = sortedCountries
                self?.updateHandler?(sortedCountries)
            case .failure(let error):
                Log.error(error.localizedDescription)
            }
        })
    }
    func getFlagImage(by country: Country) {
        flagImageService?.getFlagImageData(by: country.iso2, completion: { [weak self] result in
            switch result {
            case .success(let flagData):
                guard let countryIndex = self?.contries.firstIndex(where: {$0 == country}) else { return }
                self?.contries[countryIndex].flag = flagData
                if let self = self {
                    self.updateHandler?(self.contries)
                }
            case .failure(let error):
                Log.error(error.localizedDescription)
            }
        })
    }
    func selectCountry(country: Country) {
        detailCountryCoreDataService.deleteAll()
        userDefaultsRepository?.setMyCountry(country)
        updateAlertHandler?(country.country)
    }
}

extension SearchCountryViewModel {
    private func setAllAllowedCountries() {
        summaryCoreDataService.fetch { [weak self] result in
            switch result {
            case .success(let summary):
                if let summary = summary {
                    self?.allowedContries = summary.countries.map { $0.country }
                }
            case .failure(let error):
                Log.error(error.localizedDescription)
            }
        }
    }
}

extension SearchCountryViewModel {
    func updateSearchResults(searchText: String, countries: [Country], filteredCountries: [Country]) {
        if let filteredCountries = FilteredCountries(countries: countries, searchText: searchText) {
            updateFilteredHandler?(filteredCountries.countries)
        } else if searchText.isNotEmpty {
            updateFilteredHandler?([])
        } else {
            updateHandler?(countries)
        }
    }
    
    func willDisplayCells(indexPath: IndexPath, isActiveSearch: Bool, countries: [Country], filteredCountries: [Country]) {
        let index = indexPath.row
        guard
            let searchedCountry = SearchedCountry(isActive: isActiveSearch,
                                                  countries: filteredCountries,
                                                  index: index)
        else {
            let country = countries[index]
            getFlagImage(by: country)
            return
        }
        getFlagImage(by: searchedCountry.country)
    }
}
