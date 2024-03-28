//
//  ApplicationDetailsView.swift
//  Applied
//

import SwiftUI
import CoreData

struct ApplicationDetailsView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var application: Application
    @State private var applicationStatus: String
    private var applicationStatuses = ["Received", "Under Review", "Interview Scheduled", "Interviewed", "Pending Decision", "Offer Extended", "Offer Accepted", "Offer Declined", "Not Selected", "Withdrawn"]
    
    // MARK: - init
    init(application: Application){
        self.application = application
        self.applicationStatus = application.applicationStatus!
    }
    
    // MARK: - Body
    
    var body: some View {
        List{
            Section{
                Label(application.companyName ?? "Company's Name", systemImage: "building.2.fill")
                Label(application.city ?? "Location", systemImage: "mappin")
                Label((application.employmentType ?? "employment type") + " . " + (application.workMode ?? "workmode") , systemImage: "briefcase.fill")
                Label(Utils.formatDateToMonthDayYear(application.dateApplied ?? Date()), systemImage: "calendar")
            } header: {
                Text("Job information")
            }
            
            Section{
                Text("vfjhvbsljxdn;lwnmx;lnwklndxklwbxdjkwbxjkw kewnboibew ceiwnixoew cwenhpiocwhe cpekwopckwe lckwbnc ")
                
            } header: {
                Text("Note")
            }
            
            Section{
                Picker("Current Status", selection: $applicationStatus) {
                    ForEach(applicationStatuses, id: \.self) { status in
                        Text(status)
                            .tag(status)
                    }
                }
            } header: {
                Text("Application Status")
            }
            
            Section{
                Button("Delete"){
                    // TODO: fix warning
                    deleteApplication(application: application)
                }
                .tint(.red)
            }
        }
        .listStyle(.insetGrouped)
        
        .onDisappear(){
            // TODO: fix warning
            saveChanges()
        }
        .navigationTitle(application.jobTitle ?? "Job title")
    }
    
    // MARK: - Methods
    
    private func saveChanges() {
        application.applicationStatus = applicationStatus
        do {
            try managedObjectContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteApplication(application: Application) {
        managedObjectContext.delete(application)
        do {
            try managedObjectContext.save()
            print("Deleted application")
            dismiss()
        } catch {
            // Handle the Core Data error
            print("Failed to delete application: \(error.localizedDescription)")
        }
    }
}
