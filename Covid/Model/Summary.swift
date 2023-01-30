//
//  Summary.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation
// Response -> Summary
struct Summary: Codable {
    let message: String
    let global: Global
    let countries: [SummaryCountry]
    let date: String
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case global = "Global"
        case date = "Date"
        case countries = "Countries"
    }
}

struct Global: Codable {
    let newConfirmed: Int
    let totalConfirmed: Int
    let newDeaths: Int
    let totalDeaths: Int
    let newRecovered: Int
    let totalRecovered: Int
    let date: String
    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}

struct SummaryCountry: Codable {
    let id: String
    let country: String
    let countryCode: String
    let slug: String
    let newConfirmed: Int
    let totalConfirmed: Int
    let newDeaths: Int
    let totalDeaths: Int
    let newRecovered: Int
    let totalRecovered: Int
    let date: String
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}

// MARK: COREDATA
extension Summary {
    init(_ entity: SummaryEntity) {
        message = entity.message.emptyStringIfEmpty
        date = entity.date.emptyStringIfEmpty
        global = Global(entity.global!)
        if let countriesEntities = entity.country?.allObjects as? [CountryEntity] {
            countries = countriesEntities.map { SummaryCountry($0) }
        } else {
            countries = []
        }
    }
}

// MARK: COREDATA
extension Global {
    init(_ entity: GlobalEntity) {
        totalConfirmed = Int(entity.totalConfirmed)
        newConfirmed = Int(entity.newConfirmed)
        totalRecovered = Int(entity.totalRecovered)
        newRecovered = Int(entity.newRecovered)
        totalDeaths = Int(entity.totalDeath)
        newDeaths = Int(entity.newDeath)
        date = entity.date.emptyStringIfEmpty
    }
}

// MARK: COREDATA
extension SummaryCountry {
    init(_ entity: CountryEntity) {
        country =  entity.countryName.emptyStringIfEmpty
        totalDeaths = Int(entity.totalDeath)
        // MARK: - Not Used information
        id = ""
        countryCode = ""
        slug = ""
        date = ""
        newConfirmed = 0
        totalConfirmed = 0
        newDeaths = 0
        newRecovered = 0
        totalRecovered = 0
    }
}
