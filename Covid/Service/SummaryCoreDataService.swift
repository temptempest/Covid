//
//  SummaryCoreDataService.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import CoreData

typealias SummaryCoreDataResult = Result<Summary?, CoreDataError>
protocol ISummaryCoreDataService {
    func fetch(completion: @escaping (SummaryCoreDataResult) -> Void)
    func update(summary: Summary)
}

final class SummaryCoreDataService: ISummaryCoreDataService {
    private let container: NSPersistentContainer
    private let containerName: String = CoreDataConstant.summaryContainerName
    private let entityName: String = CoreDataConstant.summaryEntityName
    private var savedEntities: [SummaryEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                Log.error("\(CoreDataError.errorLoading(error))")
            }
        }
    }
    func fetch(completion: @escaping (SummaryCoreDataResult) -> Void) {
        let request = NSFetchRequest<SummaryEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
            if savedEntities.isNotEmpty {
                completion(.success(Summary(savedEntities[0])))
            } else {
                completion(.success(nil))
            }
        } catch let error {
            completion(.failure(.errorFetching(error)))
        }
    }
    
    func update(summary: Summary) {
        if let entity = savedEntities.first(where: { $0.date == summary.date }) {
            delete(entity: entity)
        }
        add(summary: summary)
    }
    
    private func add(summary: Summary) {
        SummaryEntity.make(context: container.viewContext, model: summary)
        applyChanges()
    }
    
    private func delete(entity: SummaryEntity) {
        container.viewContext.delete(entity)
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
