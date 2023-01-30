//
//  DetailCountry.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation
// Response -> [DetailCountry]
struct DetailCountry: Codable {
    let id: String
    let country: String
    let countryCode: String
    let lat: String
    let lon: String
    let date: String
    let confirmed: Int
    let deaths: Int
    let recovered: Int
    let active: Int
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case country = "Country"
        case countryCode = "CountryCode"
        case lat = "Lat"
        case lon = "Lon"
        case date = "Date"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case active = "Active"
    }
}
// MARK: COREDATA
extension DetailCountry {
    init(_ entity: DetailCountryEntity) {
        id = entity.id.emptyStringIfEmpty
        country = entity.country.emptyStringIfEmpty
        countryCode = entity.countryCode.emptyStringIfEmpty
        lat = entity.lat.emptyStringIfEmpty
        lon = entity.lon.emptyStringIfEmpty
        date = entity.date.emptyStringIfEmpty
        confirmed = Int(entity.confirmed)
        deaths = Int(entity.death)
        recovered = Int(entity.recovered)
        active = Int(entity.active)
    }
}
