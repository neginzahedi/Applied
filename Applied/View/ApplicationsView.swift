//
//  ApplicationsView.swift
//  Applied
//
//  Created by Negin Zahedi on 2024-04-17.
//

import SwiftUI

struct ApplicationsView: View {
    
    var applications: FetchedResults<Application>
    @State var selectedStatus: String = "All"
    
    var body: some View {
        VStack(spacing: 20){
            StatusSelectionScrollView(selectedStatus: $selectedStatus)
            ApplicationsScrollView(applications: applications, selectedStatus: selectedStatus)
        }
    }
}

struct StatusSelectionScrollView: View {
    
    @Binding var selectedStatus: String
    
    private let applicationStatus = ["All", "Received", "Interview Scheduled", "Interviewed", "Pending Decision", "Offer Accepted", "Not Selected", "Withdrawn"]
    
    var body: some View {
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
            .padding(.top, 20)
        }
    }
}


struct ApplicationsScrollView: View {
    
    var applications: FetchedResults<Application>
    var selectedStatus: String
    
    var body: some View {
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


// MARK: - Status View

struct StatusView: View {
    let status: String
    let isSelected: Bool
    
    var body: some View {
        Text(status)
            .font(.caption)
            .modifier(RoundedRectangleModifier(cornerRadius: 10))
            .foregroundColor(isSelected ? .white : .black)
            .background(isSelected ? Color(.black) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(2)
    }
}
