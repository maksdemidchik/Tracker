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
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    
    func addNewCategory(name: String) {
        if !nameCategories.contains(name) {
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
        var newCategoryTrackers: [TrackerCategory] = []
        var pinnedCategories: [TrackerCategory] = []
        if  let categories = fetchResultsController.fetchedObjects{
            var trackerPinned: [Tracker] = []
            for currentCategories in 0..<categories.count{
                if let tracker = categories[currentCategories].trackers as? Set<TrackerCoreData>, tracker.count > 0,let categoryName = categories[currentCategories].categoryName {
                    var trackers: [Tracker] = []
                    for category in tracker {
                        if let id = category.id,let color = category.color, let name = category.name, let emoji = category.emoji, let schedule = category.schedule as? Array<Int>,let date = category.dateOfAddition{
                            let pinned = category.isItPinned
                            if pinned == true{
                                trackerPinned.append(Tracker(id: id, color: colorMarshalling.color(from: color), name: name, emoji: emoji, schedule: schedule, dateOfAddition: date, isItPinned: pinned))
                            }
                            else{
                                trackers.append(Tracker(id: id, color: colorMarshalling.color(from: color), name: name, emoji: emoji, schedule: schedule, dateOfAddition: date, isItPinned: pinned))
                            }
                        }
                    }
                    let newCategoryTracker = TrackerCategory(categoryName: categoryName, tracker: trackers)
                    newCategoryTrackers.append(newCategoryTracker)
                }
            }
            let text = NSLocalizedString("pinned", comment: "pinned")
            let newPinnedCategoryTracker = TrackerCategory(categoryName: text, tracker: trackerPinned)
            pinnedCategories.append(newPinnedCategoryTracker)
        }
        newCategoryTrackers = pinnedCategories + newCategoryTrackers
        return newCategoryTrackers
    }
    
    func getTrackerAndCategoryName(id:UUID) -> TrackerCategory{
        var trackerCategory: [TrackerCategory] = []
        if  let categories = fetchResultsController.fetchedObjects{
            for currentCategories in 0..<categories.count{
                if let trackers = categories[currentCategories].trackers as? Set<TrackerCoreData>{
                    for tracker in trackers{
                        if tracker.id == id{
                            if let categoryName = categories[currentCategories].categoryName,let color = tracker.color, let name = tracker.name, let emoji = tracker.emoji, let schedule = tracker.schedule as? Array<Int>,let date = tracker.dateOfAddition{
                                let newTracker = Tracker(id: id, color: colorMarshalling.color(from: color), name: name, emoji: emoji, schedule: schedule, dateOfAddition: date, isItPinned: tracker.isItPinned)
                                trackerCategory.append(TrackerCategory(categoryName: categoryName, tracker: [newTracker]))
                                                       return trackerCategory[0]
                            }
                        }
                    }
                }
            }
        }
        return trackerCategory[0]
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
    func getGategories() -> [String]{
        var categoriesTracker: [String] = []
        if let categories = fetchResultsController.fetchedObjects{
            for category in categories {
                if let categoryName = category.categoryName{
                    categoriesTracker.append(categoryName)
                }
            }
            
        }
        return categoriesTracker
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

