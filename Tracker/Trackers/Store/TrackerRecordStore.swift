//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Maxim on 15.05.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore: NSObject,NSFetchedResultsControllerDelegate {
    
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
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
    
    func newTrackerRecord(trackerId: UUID,date:Date) {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.id = trackerId
        newTrackerRecord.date = date
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func deleteTrackerRecord(id: UUID,date:Date){
        if let objects = try? context.fetch(NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")) {
            for trackerRecord in objects {
                if id == trackerRecord.id && Calendar.current.isDate(date, inSameDayAs: trackerRecord.date ?? Date()){
                    context.delete(trackerRecord)
                }
            }
        }
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func getAllTrackerRecords() -> [TrackerRecord] {
        var trackersRecord: [TrackerRecord] = []
        if let objects = try? context.fetch(NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")) {
            for trackerRecord in objects {
                if let id = trackerRecord.id, let date = trackerRecord.date{
                    trackersRecord.append(TrackerRecord(id: id, date: date))
                }
            }
        }
        return trackersRecord
    }
    
    func getTrackersRecordCoreData(id:UUID) -> [TrackerRecordCoreData]{
        var trackersRecordCoreData : [TrackerRecordCoreData] = []
        if let obj = fetchResultsController.fetchedObjects{
            for trackerRecordCoreData in obj{
                if trackerRecordCoreData.id == id{
                    trackersRecordCoreData.append(trackerRecordCoreData)
                }
            }
        }
        return trackersRecordCoreData
    }
}

