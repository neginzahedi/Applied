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
    
    @State private var selectedStatus: String = "All"
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
                        Text("Get started by adding your first job application! Tap the \(Image(systemName: "pencil.and.list.clipboard")) button to begin.")
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
                            .padding(.top,20)
                        }
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                if selectedStatus == "All" {
                                    ForEach(applications) { application in
                                        NavigationLink(value: application) {
                                            ApplicationCardView(application: application)
                                        }
                                    }
                                } else{
                                    let filteredApplications = applications.filter {$0.applicationStatus == selectedStatus}
                                    ForEach(filteredApplications) { application in
                                        NavigationLink(value: application) {
                                            ApplicationCardView(application: application)
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            .navigationDestination(for: Application.self) { application in
                ApplicationDetailsView(application: application, applicationStatus: application.applicationStatus ?? "")
            }
            .navigationTitle("Applications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem {
                    NavigationLink {
                        AddJobApplicationView()
                    } label: {
                        Image(systemName: "pencil.and.list.clipboard")
                    }.tint(.primary)
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

// MARK: - Status View

struct StatusView: View {
    let status: String
    let isSelected: Bool
    
    var body: some View {
        Text(status)
            .foregroundColor(.black)
            .padding(8)
            .background(isSelected ?                                         Color(.customYellow)
                        : Color.white)
            .font(.system(.caption, design: .rounded))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black, lineWidth: 1) // Adjust the color and line width as needed
            )
            .padding(2)
    }
}

// MARK: - Preview ApplicationsListView

#Preview {
    ApplicationsListView()
}
