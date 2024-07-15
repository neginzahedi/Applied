//
//  DashboardView.swift
//  Applied
//

import SwiftUI

struct DashboardView: View {
    
    // MARK: - Properties
    
    @FetchRequest(fetchRequest: Application.fetch(), animation: .bouncy)
    var applications: FetchedResults<Application>
    @State private var showBottomBar = false

    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            content
            
            // MARK: Navigation Bar
                .navigationTitle("Applications")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem {
                        addButton
                    }
                }
        }
    }
    
    // MARK: - Computed Properties
    
    private var content: some View{
        VStack{
            if applications.isEmpty{
                emptyView
            } else {
                VStack(spacing: 25){
                    CalendarView()
                    mostRecentApplicationsView
                }
            }
        }
    }
    
    private var addButton: some View{
        NavigationLink {
            AddNewApplicationView()
        } label: {
            Image(systemName: "pencil.and.list.clipboard")
        }
    }
    
    private var emptyView: some View{
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
    
    private var mostRecentApplicationsView: some View{
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
                VStack(spacing: 15){
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
#if DEBUG
#Preview {
    DashboardView()
}
#endif
