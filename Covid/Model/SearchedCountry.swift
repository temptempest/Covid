//
//  SearchedCountry.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

struct SearchedCountry {
    let country: Country
}

extension SearchedCountry {
    init?(isActive: Bool, countries: [Country], index: Int) {
        guard isActive && countries.count > index else { return nil }
        country = countries[index]
    }
}
