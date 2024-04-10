//
//  ApplicationsListView.swift
//  Applied
//


import SwiftUI

struct ApplicationsListView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateApplied", ascending: false)]) var applications: FetchedResults<Application>
    @State private var showConfirmation: Bool = false
    @State private var toBeDeletedApplication: Application?
    
    @State private var selectedStatus: String = "Received"
    private let applicationStatus = ["All", "Received", "Interview Scheduled", "Interviewed", "Pending Decision", "Offer Accepted", "Not Selected", "Withdrawn"]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            VStack {
                if applications.isEmpty{
                    VStack{
                        Spacer()
                        Image("applications")
                            .resizable()
                            .scaledToFit()
                            .padding(50)
                        Text("Get started by adding your first job application! Tap the 'Add' button to begin.")
                            .multilineTextAlignment(.center)
                            .fontDesign(.rounded)
                            .foregroundStyle(.secondary)
                            .padding()
                        Spacer()
                    }
                    .padding()
                } else {
                    VStack{
                        ScrollView (.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(applicationStatus, id: \.self) { status in
                                    StatusView(status: status, isSelected: status == selectedStatus)
                                        .onTapGesture {
                                            selectedStatus = status
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                            
                        }
                        List{
                            if selectedStatus == "All" {
                                ForEach(applications) { application in
                                    NavigationLink(value: application) {
                                        ApplicationRowView(application: application)
                                    }
                                    .swipeActions(allowsFullSwipe: false) {
                                        deleteApplicationButton(for: application)
                                    }
                                }
                            } else{
                                let filteredApplications = applications.filter {$0.applicationStatus == selectedStatus}
                                ForEach(filteredApplications) { application in
                                    NavigationLink(value: application) {
                                        ApplicationRowView(application: application)
                                    }
                                    .swipeActions(allowsFullSwipe: false) {
                                        deleteApplicationButton(for: application)
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .navigationDestination(for: Application.self) { application in
                            ApplicationDetailsView(application: application, applicationStatus: application.applicationStatus ?? "")
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
            }
            
            .navigationTitle("Applications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem {
                    NavigationLink("Add") {
                        AddJobApplicationView()
                    }
                }
            }
            .fontDesign(.rounded)
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
            Text("\(application.company ?? "company's name")")
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

// MARK: - Status View

struct StatusView: View {
    let status: String
    let isSelected: Bool
    
    var body: some View {
        Text(status)
            .foregroundColor(.black)
            .padding(8)
            .background(isSelected ?                                         Color(red: 255/255, green: 206/255, blue: 0/255)
                        : Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
            .font(.system(.caption, design: .rounded))
            .padding(2)
    }
}

// MARK: - Preview ApplicationsListView

#Preview {
    ApplicationsListView()
}
