//
//  DashboardView.swift
//  Applied
//


import SwiftUI

struct DashboardView: View {
    
    // MARK: - Properties
    
    @FetchRequest(fetchRequest: Application.fetch(), animation: .bouncy)
    var applications: FetchedResults<Application>
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            VStack{
                if applications.isEmpty{
                    EmptyListView()
                } else {
                    VStack(spacing: 25){
                        CalendarView()
                        RecentApplicationsListView(applications: applications)
                    }
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
                            ApplicationDetailsView(application: application)
                        } label: {
                            ApplicationCardView(application: application)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview MainView

#Preview {
    DashboardView()
}
