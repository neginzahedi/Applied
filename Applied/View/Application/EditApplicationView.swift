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
    
    // MARK: - Body
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack(spacing: 20){
                    
                    TextFieldWithTitle(title: "Job title", placeholder: "Enter job title (required)", text:$application.jobTitle_)
                    TextFieldWithTitle(title: "Company", placeholder: "Enter company name (required)", text: $application.company_)
                    TextFieldWithTitle(title: "Location", placeholder: "Enter location (e.g., city, province)", text: $application.location_)
                    
                    PickerWithTitle(title: "Employment Type", selection: $application.employmentType_, options: Constants.employmentTypes)
                    PickerWithTitle(title: "Work Mode", selection: $application.workMode_, options: Constants.workModes)
                    PickerWithTitle(title: "Application Status", selection: $application.applicationStatus_, options: Constants.applicationStatuses)
                    
                    DatePicker("Date Applied", selection: $application.dateApplied_, in: ...Date(), displayedComponents: [.date])
                        .bold()
                    
                    CharacterLimitedTextEditor(text: $application.note_, characterLimit: 255)
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
                    //DataController.shared.save()
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.backward")
                })
            }
        }
        .navigationBarBackButtonHidden()
    }
}
