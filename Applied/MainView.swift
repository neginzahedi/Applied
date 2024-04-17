//
//  MainView.swift
//  Applied
//


import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateApplied", ascending: false)]) var applications: FetchedResults<Application>
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            VStack{
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
                    VStack(spacing: 25){
                        VStack(alignment: .leading, spacing: 15){
                            HStack{
                                Text("Upcoming Interviews")
                                    .bold()
                                Spacer()
                                Text("See All")
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    UpcomingInterviewCardView()
                                    UpcomingInterviewCardView()
                                    UpcomingInterviewCardView()
                                    UpcomingInterviewCardView()
                                }
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.top,20)
                        
                        VStack(spacing: 25){
                            HStack{
                                Text("Recent Applications")
                                    .bold()
                                Spacer()
                                Text("See All")
                            }                        .padding(.horizontal, 20)

                            
                            ScrollView(.vertical) {
                                ForEach(applications.prefix(5)) { application in
                                    NavigationLink(value: application) {
                                        ApplicationCardView(application: application)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationDestination(for: Application.self) { application in
                ApplicationDetailsView(application: application, applicationStatus: application.applicationStatus ?? "Received")
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



// MARK: - Preview MainView

#Preview {
    MainView()
}
