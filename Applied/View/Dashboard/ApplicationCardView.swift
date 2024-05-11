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
        HStack(spacing: 0) {
            statusRectangleView
            jobInfoRectangleView
        }
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Private Views
    
    private var statusRectangleView : some View {
        Rectangle()
            .fill(statusColor)
            .frame(width: 50, height: 130)
            .overlay(statusText)
    }
    
    private var statusColor: Color {
        switch application.applicationStatus {
        case "Not Selected":
            return .customPink
        case "Offer Accepted":
            return .customGreen
        case "Interview Scheduled":
            return .customBlue
        case "Interviewed":
            return .customBlue
        case "Withdrawn":
            return .gray
        case "Pending Decision":
            return .customBlue
        default:
            return .customYellow
        }
    }
    
    private var statusText: some View {
        Text(application.applicationStatus ?? "application status")
            .rotationEffect(.degrees(-90))
            .font(.caption)
            .fixedSize(horizontal: true, vertical: false) // Allow text to expand horizontally
    }
    
    private var jobInfoRectangleView: some View{
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(height: 130)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                HStack{
                    VStack(alignment: .leading){
                        jobInfoView
                        Spacer()
                        dateAppliedView
                    }
                    Spacer()
                }.padding()
            )
    }
    
    private var jobInfoView: some View {
        VStack(alignment:.leading){
            Text(application.jobTitle ?? "Job Title")
                .font(.headline)
                .multilineTextAlignment(.leading)
                .bold()
            Text("\(String(describing: application.company ?? "Company"))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var dateAppliedView: some View {
        HStack{
            Spacer()
            
            HStack {
                Text(DateUtils.monthDayYearFormatter.string(from: application.dateApplied_))
            }
            .foregroundStyle(.secondary)
            .font(.footnote)
        }
    }
}


#Preview {
    ApplicationCardView(application: Application.example)
}
