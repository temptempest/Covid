//
//  WorldCoreDataService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import CoreData

typealias WorldCoreDataResult = Result<[World]?, CoreDataError>
protocol IWorldCoreDataService {
    func fetch(completion: @escaping (WorldCoreDataResult) -> Void)
    func update(worlds: [World])
}

final class WorldCoreDataService: IWorldCoreDataService {
    private let container: NSPersistentContainer
    private let containerName: String = CoreDataConstant.worldContainerName
    private let entityName: String = CoreDataConstant.worldEntityName
    private var savedEntities: [WorldEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                Log.error("\(CoreDataError.errorLoading(error))")
            }
        }
    }
    func fetch(completion: @escaping (WorldCoreDataResult) -> Void) {
        let request = NSFetchRequest<WorldEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
            if savedEntities.isNotEmpty {
                let worlds = savedEntities.map { World($0) }
                completion(.success(worlds))
            } else {
                completion(.success(nil))
            }
        } catch let error {
            completion(.failure(.errorFetching(error)))
        }
    }
    
    func update(worlds: [World]) {
        if savedEntities.isNotEmpty {
            delete(entities: savedEntities)
        }
        add(worlds: worlds)
    }
    
    private func add(worlds: [World]) {
        worlds.enumerated().forEach { _, world in
            WorldEntity.make(context: container.viewContext, model: world)
            applyChanges()
        }
    }
    
    private func delete(entities: [WorldEntity]) {
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
