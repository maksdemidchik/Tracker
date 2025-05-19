//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Maxim on 15.05.2025.
//

import CoreData
import UIKit

protocol TrackerRecordStoreDelegate: AnyObject {
    func changeRecordValue()
}
protocol testDelegate: AnyObject {
    func test()
}

final class TrackerRecordStore: NSObject {
    private lazy var trackerStore = TrackerStore()
    weak var testDelegate: testDelegate?
    weak var delegate: TrackerRecordStoreDelegate?
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
        if let tracker = trackerStore.getTrackerById(id: trackerId){
            newTrackerRecord.tracker = tracker
        }
        if context.hasChanges {
            try? context.save()
        }
        trackerStore.set(id: trackerId)
    }
    
    func deleteTrackerRecord(id: UUID,date:Date){
        if let objects = try? context.fetch(NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")) {
            for trackerRecord in objects {
                if id == trackerRecord.id && Calendar.current.isDate(date, inSameDayAs: trackerRecord.date ?? Date()){
                    context.delete(trackerRecord)
                }
            }
        }
        delegate?.changeRecordValue()
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
    
    func v(id:UUID) -> [TrackerRecordCoreData]{
        var x : [TrackerRecordCoreData] = []
        if let obj = fetchResultsController.fetchedObjects{
            for i in obj{
                if i.id == id{
                    x.append(i)
                }
            }
        }
        return x
    }
}
extension TrackerRecordStore: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let delegate = delegate{
            delegate.changeRecordValue()
        }
        else{
            print("error")
        }
    }
}

