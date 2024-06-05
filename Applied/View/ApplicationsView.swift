//
//  ApplicationsView.swift
//  Applied
//

import SwiftUI

struct ApplicationsView: View {
    
    // MARK: - Properties
    
    var applications: FetchedResults<Application>
    @State var selectedStatus: String = "All"
    private let applicationStatus = ["All", "Applied", "Interview", "Closed"]
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20){
            StatusSelectionScrollView
            applicationsScrollView
        }
    }
    
    // MARK: - Computed Properties
    private var StatusSelectionScrollView: some View {
        ScrollView (.horizontal, showsIndicators: false){
            HStack{
                ForEach(applicationStatus, id: \.self) { status in
                    let count = getCount(for: status)
                    
                    Text("\(status) (\(count))")
                        .font(.caption)
                        .modifier(RoundedRectangleModifier(cornerRadius: 10))
                        .foregroundColor(status == selectedStatus ? .white : .black)
                        .background(status == selectedStatus ? Color(.black) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(2)
                        .onTapGesture {
                            selectedStatus = status
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var applicationsScrollView: some View{
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15) {
                switch selectedStatus {
                case "All":
                    applicationsList(applications: Array(applications))
                case "Applied":
                    let filteredApplications = applications.filter {$0.applicationStatus == "Received"}
                    applicationsList(applications: filteredApplications)
                case "Interview":
                    let filteredApplications = applications.filter { ["Interview Scheduled", "Interviewed", "Pending Decision"].contains($0.applicationStatus) }
                    applicationsList(applications: filteredApplications)
                case "Closed":
                    let filteredApplications = applications.filter { ["Offer Accepted", "Not Selected", "Withdrawn"].contains($0.applicationStatus) }
                    applicationsList(applications: filteredApplications)
                default:
                    applicationsList(applications: Array(applications))
                }
            }
        }
    }
    
    private func applicationsList(applications: [Application]) -> some View {
        ForEach(applications) { application in
            NavigationLink {
                ApplicationDetailsView(application: application)
            } label: {
                ApplicationCardView(application: application)
            }
        }
    }
    
    private func getCount(for status: String) -> Int {
        switch status {
        case "All":
            return applications.count
        case "Applied":
            return applications.filter { $0.applicationStatus == "Received" }.count
        case "Interview":
            return applications.filter { ["Interview Scheduled", "Interviewed", "Pending Decision"].contains($0.applicationStatus) }.count
        case "Closed":
            return applications.filter { ["Offer Accepted", "Not Selected", "Withdrawn"].contains($0.applicationStatus) }.count
        default:
            return 0
        }
    }
}
