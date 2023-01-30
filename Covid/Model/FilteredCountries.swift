//
//  FilteredCountries.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

struct FilteredCountries {
    let countries: [Country]
}
extension FilteredCountries {
    init?(countries: [Country], searchText: String) {
        let filteredCountries = countries.filter {
            return $0.country.lowercased()
                .range(of: searchText.lowercased()) != nil || $0.iso2.lowercased()
                .range(of: searchText.lowercased()) != nil
        }
        guard searchText.isNotEmpty else { return nil }
        guard filteredCountries.isNotEmpty else { return nil }
        self.countries = filteredCountries
    }
}
