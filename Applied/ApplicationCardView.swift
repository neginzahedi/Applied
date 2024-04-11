//
//  ApplicationCardView.swift
//  Applied
//

import SwiftUI

struct ApplicationCardView: View {
    
    // MARK: - Properties
    
    @ObservedObject var application : Application
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading){
            jobInfoView
            applicationStatusView
        }
        .bold()
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.primary, lineWidth: 1)
        )
        .tint(.primary)
        .padding(.horizontal,20)
        .padding(.vertical, 5)
    }
    
    // MARK: - Private Views
    
    private var jobInfoView: some View {
        VStack(alignment:.leading){
            Text(application.jobTitle ?? "Job Title")
            Text("(\(String(describing: application.company ?? "Company")))")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
    private var applicationStatusView: some View {
        HStack {
            dateAppliedView
            Spacer()
            statusTextView
        }
    }
    
    private var dateAppliedView: some View {
        HStack {
            Image(systemName: "calendar")
            Text("\(Utils.formatDateToMonthDayYear(application.dateApplied ?? Date()))")
                .font(.footnote)
        }
    }
    
    private var statusTextView: some View {
        Text(application.applicationStatus ?? "Application Status")
            .frame(minWidth: 100)
            .font(.caption)
            .padding(10)
            .background(application.applicationStatus == "Not Selected" ? Color.red.opacity(0.8) : Color.yellow.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
    }
}


//#Preview {
//     ApplicationCardView()
//}
