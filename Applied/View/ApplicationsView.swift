//
//  ApplicationsView.swift
//  Applied
//

import SwiftUI

struct ApplicationsView: View {
    
    // MARK: - Properties
    
    var applications: FetchedResults<Application>
    @State var selectedStatus: String = "All"
    private let applicationStatus = ["All", "Received", "Interview Scheduled", "Interviewed", "Pending Decision", "Offer Accepted", "Not Selected", "Withdrawn"]
    
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
                    Text(status)
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
                if selectedStatus == "All" {
                    ForEach(applications) { application in
                        NavigationLink {
                            ApplicationDetailsView(application: application)
                        } label: {
                            ApplicationCardView(application: application)
                        }
                    }
                } else{
                    let filteredApplications = applications.filter {$0.applicationStatus == selectedStatus}
                    ForEach(filteredApplications) { application in
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
