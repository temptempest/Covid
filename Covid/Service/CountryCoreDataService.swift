//
//  CountryCoreDataService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import CoreData

typealias CountryCoreDataResult = Result<[DetailCountry]?, CoreDataError>
protocol ICountryCoreDataService {
    func fetch(completion: @escaping (CountryCoreDataResult) -> Void)
    func update(models: [DetailCountry])
    func deleteAll()
}

final class CountryCoreDataService: ICountryCoreDataService {
    private let container: NSPersistentContainer
    private let containerName: String = CoreDataConstant.detailCountryContainerName
    private let entityName: String = CoreDataConstant.detailCountryEntityName
    private var savedEntities: [DetailCountryEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                Log.error("\(CoreDataError.errorLoading(error))")
            }
        }
    }
    func fetch(completion: @escaping (CountryCoreDataResult) -> Void) {
        let request = NSFetchRequest<DetailCountryEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
            if savedEntities.isNotEmpty {
                let detailCountries = savedEntities.map { DetailCountry($0) }
                completion(.success(detailCountries))
            } else {
                completion(.success(nil))
            }
        } catch let error {
            completion(.failure(.errorFetching(error)))
        }
    }
    
    func update(models: [DetailCountry]) {
        if savedEntities.isNotEmpty {
            delete(entities: savedEntities)
        }
        add(models: models)
    }
    
    func deleteAll() {
        if savedEntities.isNotEmpty {
            delete(entities: savedEntities)
        }
    }
    
    private func add(models: [DetailCountry]) {
        models.enumerated().forEach { _, model in
            DetailCountryEntity.make(context: container.viewContext, model: model)
            applyChanges()
        }
    }
    
    private func delete(entities: [DetailCountryEntity]) {
        entities.forEach { entity in
            container.viewContext.delete(entity)
        }
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            Log.error("\(CoreDataError.errorSaving(error))")
        }
    }
    
    private func applyChanges() {
        save()
        fetch { _ in }
    }
}
