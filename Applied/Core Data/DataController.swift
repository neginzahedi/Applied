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
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("error saving context: \(error)")
        }
    }
    
    // MARK: - SwiftUI preview helper
    static var preview: DataController = {
        let controller = DataController()
        let context = controller.container.viewContext
        
        for index in 0..<10 {
            let application = Application(jobTitle: "iOS Developer", company: "Google", location: "Toronto, ON", employmentType: Constants.employmentTypes[0], workMode: Constants.workModes[0], applicationStatus: Constants.applicationStatuses[0], dateApplied: Date(), note: "no note", context: context)
        }
        return controller
    }()
}
