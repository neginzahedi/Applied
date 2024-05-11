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
                VStack(spacing: 20){
                    
                    TextFieldWithTitle(title: "Job title", placeholder: "Enter job title (required)", text:$editedJobTitle)
                    TextFieldWithTitle(title: "Company", placeholder: "Enter company name (required)", text: $editedCompany)
                    TextFieldWithTitle(title: "Location", placeholder: "Enter location (e.g., city, province)", text: $editedLocation)
                    
                    PickerWithTitle(title: "Employment Type", selection: $editedEmploymentType, options: Constants.employmentTypes)
                    PickerWithTitle(title: "Work Mode", selection: $editedWorkMode, options: Constants.workModes)
                    PickerWithTitle(title: "Application Status", selection: $editedApplicationStatus, options: Constants.applicationStatuses)
                    
                    DatePicker("Date Applied", selection: $editedDateApplied, in: ...Date(), displayedComponents: [.date])
                        .bold()
                    
                    CharacterLimitedTextEditor(text: $editedNote, characterLimit: 255)
                        .modifier(RoundedRectangleModifier(cornerRadius: 10))
                    
                    
                }
                .padding()
            }
            .font(.subheadline)
        }
        .scrollIndicators(.hidden)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        
        .navigationTitle("Job Application")
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.backward")
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveApplication()
                }
                .disabled(editedJobTitle.isEmpty || editedCompany.isEmpty)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
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
