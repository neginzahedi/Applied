//
//  Event+helper.swift
//  Applied
//

import Foundation
import CoreData

extension Event {
    
    var id_ : UUID {
#if DEBUG
        id!
#else
        id ?? UUID()
#endif
    }
    
    // syntactic sugar
    var title_: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    var startDate_: Date {
        get { startDate ?? Date() }
        set { startDate = newValue }
    }
    
    var endDate_: Date {
        get { endDate ?? Date() }
        set { endDate = newValue }
    }
    
    var note_: String{
        get { note ?? "" }
        set { note = newValue }
    }
    
    convenience init(title: String, endDate: Date, startDate: Date, note: String, context: NSManagedObjectContext ) {
        self.init(context: context)
        self.title_ = title
        self.startDate_ = startDate
        self.endDate_ = endDate
        self.note_ = note
    }
    
    // called when new object created
    public override func awakeFromInsert() {
        self.id = UUID()
    }
    
    static func delete(event: Event){
        guard let context =  event.managedObjectContext else {return}
        context.delete(event)
    }
    
    static func fetch(_ predicate: NSPredicate = .all) -> NSFetchRequest<Event> {
        let request = Event.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Event.startDate, ascending: false),NSSortDescriptor(keyPath: \Event.title, ascending: false)]
        request.predicate = predicate
        return request
    }
    
    // MARK: - Preview helpers
    static var example: Event {
        let context = DataController.preview.container.viewContext
        
        let event = Event(title: "First Interview with HR", endDate: Date(), startDate: Date(), note: "", context: context)
        
        return event
    }
}
