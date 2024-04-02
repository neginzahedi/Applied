//
//  ContentView.swift
//  Applied
//

import SwiftUI

// MARK: - Content View

struct ContentView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateApplied", ascending: false)]) var applications: FetchedResults<Application>
    @State private var showConfirmation: Bool = false
    @State private var toBeDeletedApplication: Application?
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            List(applications){ application in
                NavigationLink(value: application) {
                    ApplicationRowView(application: application)
                }
                .swipeActions(allowsFullSwipe: false) {
                    deleteApplicationButton(for: application)
                }
            }
            .navigationDestination(for: Application.self) { application in
                ApplicationDetailsView(application: application, applicationStatus: application.applicationStatus ?? "")
            }
            
            .navigationTitle("Applications")
            .toolbar{
                ToolbarItem {
                    NavigationLink("Add") {
                        AddJobApplicationView()
                    }
                }
            }
            .confirmationDialog("Delete Application",
                                isPresented: $showConfirmation,
                                titleVisibility: .visible) {
                deleteConfirmationDialogButton()
            } message: {
                Text("Are you sure you want to delete \(toBeDeletedApplication?.jobTitle ?? "this") application?")
            }
        }
    }
    
    // MARK: - Methods
    
    private func deleteApplicationButton(for application: Application) -> some View{
        Button{
            toBeDeletedApplication = application
            showConfirmation.toggle()
        } label: {
            Label("Delete", systemImage: "trash")
                .tint(.red)
        }
    }
    
    private func deleteConfirmationDialogButton() -> some View {
        Button(role: .destructive) {
            if let application = toBeDeletedApplication {
                deleteApplication(application: application)
            }
        } label: {
            Text("Delete")
        }
    }
    
    private func deleteApplication(application: Application) {
        managedObjectContext.delete(application)
        do {
            try managedObjectContext.save()
            print("Deleted application")
        } catch {
            // Handle the Core Data error
            print("Failed to delete application: \(error.localizedDescription)")
        }
    }
}

// MARK: - Application Row View

struct ApplicationRowView: View {
    // MARK: - Properties
    
    let application: Application
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(application.jobTitle ?? "job title")")
            Text("\(application.companyName ?? "company's name")")
                .font(.footnote)
            HStack{
                Text(Utils.formatDateToMonthDayYear(application.dateApplied!))
                    .font(.caption)
                Spacer()
                Text(application.applicationStatus ?? "status")
                    .font(.caption)
                    .padding(5)
                    .background(application.applicationStatus == "Not Selected" ? .red.opacity(0.8) : .yellow.opacity(0.8), in: Capsule())
            }
        }
    }
}

// MARK: - Content View Preview

#if DEBUG
#Preview {
    ContentView()
}
#endif
