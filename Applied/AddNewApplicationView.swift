//
//  AddNewApplicationView.swift
//  Applied
//

// TODO: add note

import SwiftUI

struct AddNewApplicationView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    
    @State private var jobTitle: String = ""
    @State private var company: String = ""
    @State private var location: String = ""
    @State private var employmentType: String = "Full-time"
    @State private var applicationStatus: String = "Received"
    @State private var workMode: String = "Onsite"
    @State private var note: String = ""
    @State private var dateApplied: Date = Date()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack(spacing: 20){
                    TextFieldWithTitle(title: "Job title", placeholder: "Enter job title (required)", text: $jobTitle)
                    TextFieldWithTitle(title: "Company", placeholder: "Enter company name (required)", text: $company)
                    TextFieldWithTitle(title: "Location", placeholder: "Enter location (e.g., city, province)", text: $location)
                    
                    PickerWithTitle(title: "Employment Type", selection: $employmentType, options: Constants.employmentTypes)
                    PickerWithTitle(title: "Work Mode", selection: $workMode, options: Constants.workModes)
                    PickerWithTitle(title: "Application Status", selection: $applicationStatus, options: Constants.applicationStatuses)
                    
                    DatePicker("Date Applied", selection: $dateApplied, in: ...Date(), displayedComponents: [.date])
                        .bold()
                    
                    CharacterLimitedTextEditor(text: $note, characterLimit: 255)
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
                Button(action: {
                    saveApplication()
                }, label: {
                    Text("Add")
                })
                .disabled(jobTitle.isEmpty || company.isEmpty)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Methods
    
    private func saveApplication() {
        
        _ = Application(jobTitle: jobTitle, company: company, location: location, employmentType: employmentType, workMode: workMode, applicationStatus: applicationStatus, dateApplied: dateApplied, note: note, events: [], context: managedObjectContext)
        DataController.shared.save()
        dismiss()
    }
}

// MARK: - Custom Components

struct TextFieldWithTitle: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).bold()
            TextField(placeholder, text: $text)
                .modifier(RoundedRectangleModifier(cornerRadius: 10))
        }
    }
}

struct PickerWithTitle: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        HStack {
            Text(title).bold()
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option.description).tag(option)
                }
            }
        }
    }
}


// MARK: - AddNewApplicationView Preview

#if DEBUG
#Preview {
    AddNewApplicationView()
}
#endif

