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
        StatusSelectionScrollView(selectedStatus: $selectedStatus)
        ApplicationsScrollView(applications: applications, selectedStatus: selectedStatus)
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
        }
    }
}


struct ApplicationsScrollView: View {
    
    var applications: FetchedResults<Application>
    var selectedStatus: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
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
