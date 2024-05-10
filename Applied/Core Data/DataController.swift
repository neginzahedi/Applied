//
//  DataController.swift
//  Applied
//

import Foundation
import CoreData

class DataController: ObservableObject{
    
    static let shared = DataController()
    
    let container : NSPersistentContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "JobApplication")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error  as NSError? {
                fatalError("Error loading container: \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        context.perform {
            guard context.hasChanges else { return }
            
            do {
                print("Changes to Core Data saved.")
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func deleteAllEventsData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Event.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            try container.viewContext.save()
        } catch {
            print("Error deleting events data: \(error.localizedDescription)")
        }
    }
    
    func deleteAllApplicationstData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Application.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            try container.viewContext.save()
        } catch {
            print("Error deleting applications data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - SwiftUI preview helper
    static var preview: DataController = {
        let controller = DataController()
        let context = controller.container.viewContext
        
        for index in 0..<10 {
            let application = Application(jobTitle: "iOS Developer", company: "Google", location: "Toronto, ON", employmentType: Constants.employmentTypes[0], workMode: Constants.workModes[0], applicationStatus: Constants.applicationStatuses[0], dateApplied: Date(), note: "no note", events: [Event(title: "", dueDate: Date(), context: context)], context: context)
        }
        return controller
    }()
}
