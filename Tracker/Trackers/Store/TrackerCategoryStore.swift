//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Maxim on 15.05.2025.
//

import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func getCategories()
}

final class TrackerCategoryStore: NSObject {
    private let colorMarshalling = UIColorMarshalling.shared
    
    private lazy var trackerStore = TrackerStore()
    weak var delegate: TrackerCategoryStoreDelegate?
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
        let fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedController.delegate = self
        try? fetchedController.performFetch()
        return fetchedController
    }()
    
    private lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            fatalError("Error getting AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    private lazy var nameCategories : [String] = {
        if let object = fetchResultsController.fetchedObjects{
            return object.map({$0.categoryName ?? ""})
        }
        return []
    }()
    
    func addNewCategory(name: String) {
        if nameCategories.contains(name) == false {
            let category = TrackerCategoryCoreData(context: context)
            category.categoryName = name
            category.trackers = NSSet(array: [])
            nameCategories.append(name)
            if context.hasChanges{
                try? context.save()
            }
        }
    }
    
    func getTracker()->[TrackerCategory]{
        var categoryTrackers1: [TrackerCategory] = []
        if  let categories = fetchResultsController.fetchedObjects{
            for z in 0..<categories.count{
                if let tracker = categories[z].trackers as? Set<TrackerCoreData>, tracker.count > 0,let categoryName = categories[z].categoryName {
                    var trackers: [Tracker] = []
                    for i in tracker {
                        if let id = i.id,let color = i.color, let name = i.name, let emoji = i.emoji, let schedule = i.schedule as? Array<Int>{
                            trackers.append(Tracker(id: id, color: colorMarshalling.color(from: color), name: name, emoji: emoji, schedule: schedule))
                        }
                    }
                    let newCategoryTracker = TrackerCategory(categoryName: categoryName, tracker: trackers)
                    categoryTrackers1.append(newCategoryTracker)
                }
            }
        }
        return categoryTrackers1
    }
    
    func fetchCategory(string: String) -> TrackerCategoryCoreData?{
        if let categories = fetchResultsController.fetchedObjects{
            for i in 0..<categories.count{
                if string == categories[i].categoryName{
                    return categories[i]
                }
            }
        }
        return nil
    }
    
}
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate{
    var numberOfSections: Int {
        fetchResultsController.sections?.count ?? 0
    }
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData? {
        fetchResultsController.object(at: indexPath)
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.getCategories()
    }
}

