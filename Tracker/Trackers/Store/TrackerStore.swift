//
//  TrackerStore.swift
//  Tracker
//
//  Created by Maxim on 15.05.2025.
//
import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func changeRecordValue(completedTrackers: [TrackerRecord])
}

final class TrackerStore: NSObject{
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
                    NSSortDescriptor(key: "dateOfAddition", ascending: true)
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
        newTracker.dateOfAddition = tracker.dateOfAddition
        newTracker.category = trackerCategoryStore.fetchCategory(string: category)
        if context.hasChanges{
            try? context.save()
        }
    }
    
    func decodingTracker(indexPath:IndexPath) -> Tracker?{
        if let tracker = object(at: indexPath), let id = tracker.id, let colorString = tracker.color,let name = tracker.name ,let emoji = tracker.emoji,let schdule = tracker.schedule as? [Int],let date = tracker.dateOfAddition{
            return Tracker(id: id, color: colorMarshalling.color(from: colorString), name: name, emoji: emoji, schedule: schdule, dateOfAddition: date)
        }
        return nil
    }
    
    func addOrDeleteTrackerRecord(id:UUID, date: Date,isComplete: Bool){
        if !isComplete{
            trackerRecordStore.newTrackerRecord(trackerId: id, date: date)
        }
        else{
            trackerRecordStore.deleteTrackerRecord(id: id, date: date)
        }
        if let objects = fetchResultsController.fetchedObjects{
            for tracker in objects{
                if tracker.id == id{
                    tracker.record = NSSet(array: trackerRecordStore.getTrackersRecordCoreData(id: id))
                }
            }
        }
    }
    
    func getComletedTrackers() -> [TrackerRecord]{
        return trackerRecordStore.getAllTrackerRecords()
    }
    
}

extension TrackerStore: NSFetchedResultsControllerDelegate{
    var numberOfSections: Int {
        fetchResultsController.sections?.count ?? 0
    }
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    func object(at indexPath: IndexPath) -> TrackerCoreData? {
        fetchResultsController.object(at: indexPath)
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.changeRecordValue(completedTrackers: getComletedTrackers())
    }
}
