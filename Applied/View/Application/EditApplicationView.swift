//
//  EditApplicationView.swift
//  Applied
//

import SwiftUI

struct EditApplicationView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var application : Application
    
    @State private var editedJobTitle: String
    @State private var editedCompany: String
    @State private var editedLocation: String
    @State private var editedEmploymentType: String
    @State private var editedWorkMode: String
    @State private var editedApplicationStatus: String
    @State private var editedDateApplied: Date
    @State private var editedNote: String
    
    // MARK: - Initialization
    
    init(application: Application) {
        self.application = application
        
        _editedJobTitle = State(initialValue: application.jobTitle_)
        _editedCompany = State(initialValue: application.company_)
        _editedLocation = State(initialValue: application.location_)
        _editedEmploymentType = State(initialValue: application.employmentType_)
        _editedWorkMode = State(initialValue: application.workMode_)
        _editedApplicationStatus = State(initialValue: application.applicationStatus_)
        _editedDateApplied = State(initialValue: application.dateApplied_)
        _editedNote = State(initialValue: application.note_)
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                formFields
            }
            .padding()
            .font(.subheadline)
            .scrollIndicators(.hidden)
            .textInputAutocapitalization(.never)
        }
        
        // MARK: - Navigation Bar
        
        .navigationTitle("Edit Application")
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                saveButton
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var formFields: some View {
        VStack(spacing: 20) {
            TextFieldWithTitle(title: "Job title", placeholder: "Enter job title (required)", text: $editedJobTitle)
            TextFieldWithTitle(title: "Company", placeholder: "Enter company name (required)", text: $editedCompany)
            TextFieldWithTitle(title: "Location", placeholder: "Enter location (e.g., city, province)", text: $editedLocation)
            PickerWithTitle(title: "Employment Type", options: Constants.employmentTypes, selection: $editedEmploymentType)
            PickerWithTitle(title: "Work Mode", options: Constants.workModes, selection: $editedWorkMode)
            PickerWithTitle(title: "Application Status", options: Constants.applicationStatuses, selection: $editedApplicationStatus)
            DatePicker("Date Applied", selection: $editedDateApplied, in: ...Date(), displayedComponents: [.date])
                .bold()
            CharacterLimitedTextEditor(text: $editedNote, characterLimit: 255)
                .modifier(RoundedRectangleModifier(cornerRadius: 10))
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            saveApplication()
        }) {
            Text("Save")
        }
        .disabled(editedJobTitle.isEmpty || editedCompany.isEmpty)
    }
    
    // MARK: - Methods
    
    private func saveApplication(){
        application.jobTitle_ = editedJobTitle
        application.company_ = editedCompany
        application.location_ = editedLocation
        application.employmentType_ = editedEmploymentType
        application.workMode_ = editedWorkMode
        application.applicationStatus_ = editedApplicationStatus
        application.dateApplied_ = editedDateApplied
        application.note_ = editedNote
        
        do {
            try managedObjectContext.save()
            dismiss()
        } catch {
            // Handle error
            print("Error saving application: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    EditApplicationView(application: Application.example)
}
#endif
