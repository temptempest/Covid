//
//  World.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation
// Response->[World]
struct World: Codable {
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

// MARK: COREDATA
extension World {
    init(_ entity: WorldEntity) {
        newConfirmed = Int(entity.newConfirmed)
        totalConfirmed = Int(entity.totalConfirmed)
        newDeaths = Int(entity.newDeath)
        totalDeaths = Int(entity.totalDeath)
        newRecovered = Int(entity.newRecovered)
        totalRecovered = Int(entity.totalRecovered)
        date = entity.date.emptyStringIfEmpty
    }
}
