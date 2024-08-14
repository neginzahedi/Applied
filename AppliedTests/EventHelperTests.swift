//
//  EventHelperTests.swift
//  AppliedTests
//
//  Created by Negin Zahedi on 2024-08-14.
//

import XCTest
import CoreData
@testable import Applied

final class EventTests: XCTestCase {

    var dataController: DataController!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        context = dataController.container.viewContext
    }

    override func tearDownWithError() throws {
        dataController = nil
        context = nil
    }

    func testEventInitializer() throws {
        let title = "First Interview"
        let dueDate = Date()
        
        let event = Event(title: title, dueDate: dueDate, context: context)
        
        XCTAssertEqual(event.title_, title, "The title should be correctly set.")
        XCTAssertEqual(event.dueDate_, dueDate, "The due date should be correctly set.")
    }

    func testFetchEvents() throws {
        _ = Event(title: "First Interview", dueDate: Date(), context: context)
        _ = Event(title: "Second Interview", dueDate: Date().addingTimeInterval(86400), context: context)
        _ = Event(title: "Final Interview", dueDate: Date().addingTimeInterval(172800), context: context)
        
        try context.save()
        
        var fetchRequest: NSFetchRequest<Event> = Event.fetch()
        var fetchedEvents = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedEvents.count, 3, "There should be three events in the context.")
        
        fetchRequest = Event.fetch(NSPredicate(format: "title CONTAINS[cd] %@", "Interview"))
        fetchedEvents = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedEvents.count, 3, "There should be three events matching 'Interview' in the title.")
        
        fetchRequest = Event.fetch(NSPredicate(format: "title == %@", "Final Interview"))
        fetchedEvents = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedEvents.count, 1, "There should be one event with the title 'Final Interview'.")
        
        fetchRequest = Event.fetch(NSPredicate(format: "title == %@", "Meeting"))
        fetchedEvents = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedEvents.count, 0, "There should be no events with the title 'Meeting'.")
    }

    func testDeleteEvent() throws {
        let event = Event(title: "First Interview", dueDate: Date(), context: context)
        
        try context.save()
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetch()
        var fetchedEvents = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedEvents.count, 1, "There should be one event in the context.")
        
        Event.delete(event: event)
        try context.save()
        
        fetchedEvents = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedEvents.count, 0, "There should be no events left after deletion.")
    }
}
