//
//  Application+helper.swift
//  Applied
//

import Foundation
import CoreData

extension Application {
    
    var id_ : UUID {
#if DEBUG
        id!
#else
        id ?? UUID()
#endif
    }
    
    // syntactic sugar
    var jobTitle_: String {
        get { jobTitle ?? "" }
        set { jobTitle = newValue }
    }
    
    var company_: String {
        get { company ?? "" }
        set { company = newValue }
    }
    
    var location_: String {
        get { location ?? "" }
        set { location = newValue }
    }
    
    var employmentType_: String {
        get { employmentType ?? Constants.employmentTypes[0] }
        set { employmentType = newValue}
    }
    
    var workMode_: String {
        get { workMode ?? Constants.workModes[0] }
        set { workMode = newValue }
    }
    
    var applicationStatus_: String {
        get { applicationStatus ?? Constants.applicationStatuses[0] }
        set { applicationStatus = newValue }
    }
    
    var dateApplied_: Date {
        get { dateApplied ?? Date() }
        set { dateApplied = newValue }
    }
    
    var note_: String{
        get { note ?? "" }
        set { note = newValue }
    }
    
    var events_: Set<Event> {
        get { (events as? Set<Event>) ?? [] }
        set { events = newValue as NSSet }
    }
    
    convenience init(jobTitle: String, company: String, location: String,employmentType: String, workMode: String, applicationStatus: String, dateApplied: Date, note: String, events: Set<Event>, context: NSManagedObjectContext ) {
        self.init(context: context)
        self.jobTitle_ = jobTitle
        self.company_ = company
        self.location_ = location
        self.employmentType_ = employmentType
        self.workMode_ = workMode
        self.applicationStatus_ = applicationStatus
        self.dateApplied_ = dateApplied
        self.note_ = note
        self.events_ = events
    }
    
    // called when new object created
    public override func awakeFromInsert() {
        self.id = UUID()
    }
    
    static func delete(application: Application){
        guard let context =  application.managedObjectContext else {return}
        context.delete(application)
    }
    
    static func fetch(_ predicate: NSPredicate = .all) -> NSFetchRequest<Application> {
        let request = Application.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Application.dateApplied, ascending: false),NSSortDescriptor(keyPath: \Application.jobTitle, ascending: false)]
        request.predicate = predicate
        return request
    }
    
    // MARK: - Preview helpers
    static var example: Application {
        let context = DataController.preview.container.viewContext
        
        let application = Application(jobTitle: "iOS Developer", company: "Google", location: "Toronto, ON", employmentType: Constants.employmentTypes[0], workMode: Constants.workModes[0], applicationStatus: Constants.applicationStatuses[0], dateApplied: Date(), note: "no note", events: [Event(title: "Interview with HR", dueDate: Date(), context: context)], context: context)
        
        return application
    }
}
