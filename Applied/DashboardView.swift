//
//  DashboardView.swift
//  Applied
//


import SwiftUI

struct DashboardView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateApplied", ascending: false)]) var applications: FetchedResults<Application>
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            VStack{
                if applications.isEmpty{
                    EmptyListView()
                } else {
                    RecentApplicationsListView(applications: applications)
                }
            }
            .navigationTitle("Applications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem {
                    NavigationLink {
                        AddNewApplicationView()
                    } label: {
                        Image(systemName: "pencil.and.list.clipboard")
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
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

// MARK: - Subviews

extension DashboardView {
    
    // MARK: - EmptyListView
    
    struct EmptyListView: View {
        var body: some View {
            VStack{
                Spacer()
                Image("applications")
                    .resizable()
                    .scaledToFit()
                    .padding(50)
                Text("Get started by adding your first job application! Tap the \(Image(systemName: "pencil.and.list.clipboard")) button to begin.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding()
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - RecentApplicationsListView
    
    struct RecentApplicationsListView: View {
        var applications: FetchedResults<Application>
        
        var body: some View {
            VStack(spacing: 25){
                UpcomingInterviewsSectionView()
                VStack(spacing: 25){
                    HStack{
                        Text("Recent Applications")
                            .bold()
                        Spacer()
                        NavigationLink(destination: ApplicationsView(applications: applications)) {
                            Text("See All")
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    
                    ScrollView(.vertical) {
                        ForEach(applications.prefix(5)) { application in
                            NavigationLink {
                                ApplicationDetailsView(application: application, applicationStatus: application.applicationStatus ?? "Received")
                            } label: {
                                ApplicationCardView(application: application)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK: - UpcomingInterviewsSectionView
    struct UpcomingInterviewsSectionView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 15){
                HStack{
                    Text("Upcoming Interviews")
                        .bold()
                    Spacer()
                    // TODO: - display all events
                    NavigationLink(destination: EmptyView()) {
                        Text("See All")
                            .font(.footnote)
                    }
                }
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(0..<4){ _ in
                            UpcomingInterviewCardView()
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.top,20)
        }
    }
}

// MARK: - Preview MainView

#Preview {
    DashboardView()
}
