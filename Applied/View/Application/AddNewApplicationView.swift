//
//  AddNewApplicationView.swift
//  Applied
//

import SwiftUI

struct AddNewApplicationView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @State private var jobTitle: String = ""
    @State private var company: String = ""
    @State private var location: String = ""
    @State private var employmentType: String = Constants.employmentTypes[0]
    @State private var applicationStatus: String = Constants.applicationStatuses[0]
    @State private var workMode: String = Constants.workModes[0]
    @State private var note: String = ""
    @State private var dateApplied: Date = Date()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                formFields
            }
            .font(.subheadline)
            .padding()
            .scrollIndicators(.hidden)
            .textInputAutocapitalization(.never)
        }
        
        // MARK: Navigation Bar
        
        .navigationTitle("Job Application")
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                addApplicationButton
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var formFields: some View {
        VStack(spacing: 20){
            TextFieldWithTitle(title: "Job title", placeholder: "Enter job title (required)", text: $jobTitle)
            TextFieldWithTitle(title: "Company", placeholder: "Enter company name (required)", text: $company)
            TextFieldWithTitle(title: "Location", placeholder: "Enter location (e.g., city, province)", text: $location)
            
            PickerWithTitle(title: "Employment Type", options: Constants.employmentTypes, selection: $employmentType)
            PickerWithTitle(title: "Work Mode", options: Constants.workModes, selection: $workMode)
            PickerWithTitle(title: "Application Status", options: Constants.applicationStatuses, selection: $applicationStatus)
            
            DatePicker("Date Applied", selection: $dateApplied, in: ...Date(), displayedComponents: [.date])
                .bold()
            
            Divider()
            
            CharacterLimitedTextEditor(text: $note, characterLimit: 255)
        }
    }
    
    private var addApplicationButton: some View {
        Button(action: {
            saveApplication()
        }, label: {
            Text("Add")
        })
        .disabled(jobTitle.isEmpty || company.isEmpty)
    }
    
    // MARK: - Private Methods
    
    private func saveApplication() {
        
        _ = Application(jobTitle: jobTitle, company: company, location: location, employmentType: employmentType, workMode: workMode, applicationStatus: applicationStatus, dateApplied: dateApplied, note: note, events: [], context: managedObjectContext)
        DataController.shared.save()
        dismiss()
    }
}


// MARK: - AddNewApplicationView Preview

#if DEBUG
#Preview {
    AddNewApplicationView()
}
#endif

