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
    
    // MARK: - Body
    
    var body: some View {
        List{
            Section{
                Label(application.companyName ?? "", systemImage: "building.2.fill")
                Label( application.city ?? "" , systemImage: "mappin")
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
            
            Section{
                Button("Delete"){
                    deleteApplication(application: application)
                }
                .tint(.red)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(application.jobTitle ?? "Job title")
    }
    
    // MARK: - Methods
    
    private func saveChanges() {
        application.applicationStatus = applicationStatus
        do {
            try managedObjectContext.save()
            print("Application status updated.")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
