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
    @State var applicationStatus: String
    @State private var showConfirmation: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        List{
            Section {
                Label(application.company ?? "Company", systemImage: "building.2.fill")
                Label(application.location ?? "Location" , systemImage: "mappin")
                Label((application.employmentType ?? "Employment Type") + " . " + (application.workMode ?? "Work Mode") , systemImage: "briefcase.fill")
                Label(Utils.formatDateToMonthDayYear(application.dateApplied ?? Date()), systemImage: "calendar")
            } header: {
                Text("Job information")
            }
            
            Section {
                Text(application.note ?? "Note")
                
            } header: {
                Text("Note")
            }
            
            Section {
                Picker("Current Status", selection: $applicationStatus) {
                    ForEach(Constants.applicationStatuses, id: \.self) { status in
                        Text(status)
                            .tag(status)
                    }
                }
                .onChange(of: applicationStatus) {
                    saveChanges()
                }
            } header: {
                Text("Application Status")
            }
            
            Section {
                Button("Delete"){
                    showConfirmation.toggle()
                }
                .tint(.red)
            }
        }
        .listStyle(.insetGrouped)
        
        .confirmationDialog("Delete Application",
                            isPresented: $showConfirmation,
                            titleVisibility: .visible) {
            Button(role: .destructive) {
                deleteApplication(application: application)
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete \(application.jobTitle ?? "this") application?")
        }
        
        .navigationTitle(application.jobTitle ?? "Job title")
    }
    
    // MARK: - Methods
    
    private func saveChanges() {
        application.applicationStatus = applicationStatus
        do {
            try self.managedObjectContext.save()
            print("Application status updated.")
        } catch {
            fatalError("Error updating status: \(error.localizedDescription)")
        }
    }
    
    private func deleteApplication(application: Application) {
        managedObjectContext.delete(application)
        do {
            try managedObjectContext.save()
            print("Application deleted.")
            dismiss()
        } catch {
            // Handle the Core Data error
            print("Failed to delete application: \(error.localizedDescription)")
        }
    }
}
