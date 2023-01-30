//
//  SummaryEntity.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import CoreData

extension SummaryEntity {
    @discardableResult
    static func make(context: NSManagedObjectContext, model: Summary) -> SummaryEntity {
        let entity = SummaryEntity(context: context)
        entity.message = model.message
        entity.global = GlobalEntity.make(context: context, model: model)
        let countries: [CountryEntity] = model.countries
            .map({ CountryEntity.make(context: context, model: $0) })
        entity.addToCountry(NSSet(array: countries))
        entity.date = model.date
        return entity
    }
}

extension GlobalEntity {
    static func make(context: NSManagedObjectContext, model: Summary) -> GlobalEntity {
        let global = model.global
        let entity = GlobalEntity(context: context)
        entity.date = global.date
        entity.totalConfirmed = Int64(global.totalConfirmed)
        entity.totalRecovered = Int64(global.totalRecovered)
        entity.newConfirmed = Int64(global.newConfirmed)
        entity.newRecovered = Int64(global.newRecovered)
        entity.totalDeath = Int64(global.totalDeaths)
        entity.newDeath = Int64(global.newDeaths)
        return entity
    }
}

extension CountryEntity {
    static func make(context: NSManagedObjectContext, model: SummaryCountry) -> CountryEntity {
        let entity = CountryEntity(context: context)
        entity.countryName = model.country
        entity.totalDeath = Int64(model.totalDeaths)
        return entity
    }
}
