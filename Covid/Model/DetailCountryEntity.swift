//
//  DetailCountryEntity.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import CoreData

extension DetailCountryEntity {
    @discardableResult
    static func make(context: NSManagedObjectContext, model: DetailCountry) -> DetailCountryEntity {
        let entity = DetailCountryEntity(context: context)
        entity.id = model.id
        entity.country = model.country
        entity.countryCode = model.countryCode
        entity.lat = model.lat
        entity.lon = model.lon
        entity.date = model.date
        entity.confirmed = Int64(model.confirmed)
        entity.death = Int64(model.deaths)
        entity.recovered = Int64(model.recovered)
        entity.active = Int64(model.active)
        return entity
    }
}
