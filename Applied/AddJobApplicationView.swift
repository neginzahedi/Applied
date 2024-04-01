//
//  AddJobApplicationView.swift
//  Applied
//
//  Created by Negin Zahedi on 2024-03-27.
//

import SwiftUI

struct AddJobApplicationView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State private var jobTitle: String = ""
    @State private var companyName: String = ""
    @State private var city: String = ""
    @State private var employmentType: String = "Full-time"
    @State private var applicationStatus: String = "Received"
    @State private var workMode: String = "Onsite"
    @State private var dateApplied: Date = Date()
    
    
    // MARK: - Body
    
    var body: some View {
        Form{
            TextField("Title", text: $jobTitle)
            TextField("Company's name", text: $companyName)
            TextField("City", text: $city)
            DatePicker("Date Applied", selection: $dateApplied, in: ...Date(), displayedComponents: [.date])
            Picker("Employment Type", selection: $employmentType) {
                ForEach(Constants.employmentTypes, id: \.self) { type in
                    Text(type)
                        .tag(type)
                }
            }
            Picker("Work Mode", selection: $workMode) {
                ForEach(Constants.workModes, id: \.self) { type in
                    Text(type)
                        .tag(type)
                }
            }
            Picker("Application Status", selection: $applicationStatus) {
                ForEach(Constants.applicationStatuses, id: \.self) { status in
                    Text(status)
                        .tag(status)
                }
            }
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        
        .navigationTitle("Job Application")
        .toolbar{
            ToolbarItem {
                Button("Save") {
                    saveApplication()
                }
                .disabled(jobTitle.isEmpty || companyName.isEmpty)
            }
        }
    }
    
    // MARK: - Methods
    
    private func saveApplication(){
        let application = Application(context: managedObjectContext)
        application.id = UUID()
        application.jobTitle = jobTitle
        application.companyName = companyName
        application.city = city
        application.employmentType = employmentType
        application.workMode = workMode
        application.dateApplied = dateApplied
        application.applicationStatus = applicationStatus
        
        do {
            try self.managedObjectContext.save()
            print("Application saved!")
            dismiss()
        } catch {
            print("whoops \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddJobApplicationView()
}
