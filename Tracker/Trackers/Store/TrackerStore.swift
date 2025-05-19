//
//  TrackerStore.swift
//  Tracker
//
//  Created by Maxim on 15.05.2025.
//
import CoreData
import UIKit
protocol TrackerStoreDelegate: AnyObject {
    func didSendTrackerCoreData(_ tracker: [TrackerCategory])
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate{
    private let colorMarshalling = UIColorMarshalling.shared
    private lazy var trackerRecordStore = TrackerRecordStore()
    private lazy var trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
            fatalError("Error getting AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: "name", ascending: false)
                ]
        let fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedController.delegate = self
        try? fetchedController.performFetch()
        return fetchedController
    }()
    
    weak var delegate: TrackerStoreDelegate?
    
    func addNewTracker(tracker:Tracker,category: String){
        let newTracker = TrackerCoreData(context: context)
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.id = tracker.id
        newTracker.color = colorMarshalling.hexString(from: tracker.color)
        newTracker.schedule = tracker.schedule as NSArray?
        newTracker.category = trackerCategoryStore.fetchCategory(string: category)
        newTracker.record = NSSet()
        if context.hasChanges{
            try? context.save()
        }
    }
    
    func getTrackerById(id:UUID) -> TrackerCoreData?{
        if let objects = try? context.fetch(NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")){
            for tracker in objects{
                if tracker.id == id{
                    return tracker
                }
            }
        }
        return nil
    }
    func set(id:UUID){
        if let objects = try? context.fetch(NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")){
            for tracker in objects{
                if tracker.id == id{
                    tracker.record = NSSet(array: trackerRecordStore.v(id: id))
                }
            }
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        print(000)
    }
    
}
