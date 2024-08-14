//
//  ApplicationHelperTests.swift
//  AppliedTests
//
//

import XCTest
import CoreData
@testable import Applied

final class ApplicationHelperTests: XCTestCase {
    
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
    
    func testDeleteApplication() throws {
        let application = Application(jobTitle: "iOS Developer", company: "Apple", location: "Cupertino, CA", employmentType: Constants.employmentTypes[0], workMode: Constants.workModes[0], applicationStatus: Constants.applicationStatuses[0], dateApplied: Date(), note: "Initial application", events: [], context: context)
        try context.save()
        
        let fetchRequest: NSFetchRequest<Application> = Application.fetchRequest()
        var fetchedApplications = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedApplications.count, 1, "There should be one application in the context.")
        
        Application.delete(application: application)
        try context.save()
        
        fetchedApplications = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedApplications.count, 0, "There should be no applications left after deletion.")
    }
    
    func testFetchApplications() throws {
        _ = Application(jobTitle: "iOS Developer", company: "Apple", location: "Cupertino, CA", employmentType: Constants.employmentTypes[0], workMode: Constants.workModes[0], applicationStatus: Constants.applicationStatuses[0], dateApplied: Date(), note: "First application", events: [], context: context)
        
        _ = Application(jobTitle: "Android Developer", company: "Google", location: "Mountain View, CA", employmentType: Constants.employmentTypes[1], workMode: Constants.workModes[1], applicationStatus: Constants.applicationStatuses[1], dateApplied: Date(), note: "Second application", events: [], context: context)
        
        _ = Application(jobTitle: "Web Developer", company: "Amazon", location: "Seattle, WA", employmentType: Constants.employmentTypes[2], workMode: Constants.workModes[2], applicationStatus: Constants.applicationStatuses[2], dateApplied: Date(), note: "Third application", events: [], context: context)
        
        try context.save()
        
        var fetchRequest: NSFetchRequest<Application> = Application.fetch()
        var fetchedApplications = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedApplications.count, 3, "There should be three applications in the context.")
        
        fetchRequest = Application.fetch(NSPredicate(format: "jobTitle CONTAINS[cd] %@", "Developer"))
        fetchedApplications = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedApplications.count, 3, "There should be three applications matching 'Developer' in the job title.")
        
        fetchRequest = Application.fetch(NSPredicate(format: "company == %@", "Apple"))
        fetchedApplications = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedApplications.count, 1, "There should be one application with the company 'Apple'.")
        
        fetchRequest = Application.fetch(NSPredicate(format: "company == %@", "Microsoft"))
        fetchedApplications = try context.fetch(fetchRequest)
        XCTAssertEqual(fetchedApplications.count, 0, "There should be no applications with the company 'Microsoft'.")
    }
    
    func testApplicationInitializer() throws {
        let event = Event(title: "Initial Interview", dueDate: Date(), context: context)
        let events: Set<Event> = [event]
        
        let jobTitle = "iOS Developer"
        let company = "Apple"
        let location = "Cupertino, CA"
        let employmentType = Constants.employmentTypes[0]
        let workMode = Constants.workModes[0]
        let applicationStatus = Constants.applicationStatuses[0]
        let dateApplied = Date()
        let note = "Excited about this opportunity"
        
        let application = Application(jobTitle: jobTitle, company: company, location: location, employmentType: employmentType, workMode: workMode, applicationStatus: applicationStatus, dateApplied: dateApplied, note: note, events: events, context: context)
        
        XCTAssertEqual(application.jobTitle_, jobTitle, "The job title should be correctly set.")
        XCTAssertEqual(application.company_, company, "The company should be correctly set.")
        XCTAssertEqual(application.location_, location, "The location should be correctly set.")
        XCTAssertEqual(application.employmentType_, employmentType, "The employment type should be correctly set.")
        XCTAssertEqual(application.workMode_, workMode, "The work mode should be correctly set.")
        XCTAssertEqual(application.applicationStatus_, applicationStatus, "The application status should be correctly set.")
        XCTAssertEqual(application.dateApplied_, dateApplied, "The date applied should be correctly set.")
        XCTAssertEqual(application.note_, note, "The note should be correctly set.")
        XCTAssertEqual(application.events_, events, "The events should be correctly set.")
        
        XCTAssertEqual(application.events_.count, 1, "There should be one event associated with the application.")
        XCTAssertEqual(application.events_.first?.title_, event.title_, "The event's title should be correctly set.")
    }
}
