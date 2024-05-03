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
    
    var dueDate_: Date {
        get { dueDate ?? Date() }
        set { dueDate = newValue }
    }
    
    var note_: String{
        get { note ?? "" }
        set { note = newValue }
    }
    
    convenience init(title: String, dueDate: Date, note: String, context: NSManagedObjectContext ) {
        self.init(context: context)
        self.title_ = title
        self.dueDate_ = dueDate
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
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Event.dueDate, ascending: false),NSSortDescriptor(keyPath: \Event.title, ascending: false)]
        request.predicate = predicate
        return request
    }
    
    // MARK: - Preview helpers
    static var example: Event {
        let context = DataController.preview.container.viewContext
        
        let event = Event(title: "First Interview with HR", dueDate: Date(), note: "", context: context)
        
        return event
    }
}
