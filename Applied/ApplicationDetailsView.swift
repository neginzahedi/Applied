//
//  ApplicationDetailsView.swift
//  Applied
//

import SwiftUI
import CoreData

struct ApplicationDetailsView: View {
    
    var application: Application
    
    var body: some View {
        VStack(alignment: .leading){
            Text(application.jobTitle ?? "job title")
                .font(.title)
                .bold()
            Label(application.companyName ?? "Company's Name", systemImage: "building.2.fill")
            Label(application.city ?? "Location", systemImage: "mappin")
            Label((application.employmentType ?? "employment type") + " . " + (application.workMode ?? "workmode") , systemImage: "briefcase.fill")
            Label(Utils.formatDateToMonthDayYear(application.dateApplied!), systemImage: "calendar")
            Label(application.applicationStatus ?? "Status", systemImage: "clock.arrow.2.circlepath")
            Divider()
            
            VStack{
                Text("Note:")
            }
            
            Button("Edit"){
                //
            }
            Button("Delete"){
                //
            }
            Spacer()
        }
        .padding()
        
        .navigationTitle(application.jobTitle!)
    }
}
