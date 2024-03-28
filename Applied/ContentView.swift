//
//  ContentView.swift
//  Applied
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateApplied", ascending: false)]) var applications: FetchedResults<Application>
    @State private var showConfirmation: Bool = false
    @State private var toBeDeletedApplication: Application?
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(applications){ application in
                    NavigationLink {
                        ApplicationDetailsView(application: application)
                    } label: {
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
                    .swipeActions(allowsFullSwipe: false) {
                        Button{
                            toBeDeletedApplication = application
                            showConfirmation.toggle()
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .tint(.red)
                        }
                    }
                }
            }
            .listStyle(.plain)
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
                Button(role: .destructive) {
                    if let application = toBeDeletedApplication {
                        deleteApplication(application: application)
                    }
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("Are you sure you want to delete \(toBeDeletedApplication?.jobTitle ?? "this") application?")
            }
        }
    }
    
    // MARK: - Methods
    
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

#Preview {
    ContentView()
}
