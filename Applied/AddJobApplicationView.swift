//
//  AddJobApplicationView.swift
//  Applied
//

// TODO: add note

import SwiftUI

struct AddJobApplicationView: View {
    
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
                    
                    Button(action: {
                        saveApplication()
                    }, label: {
                        Text("Save Application")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(.blue))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontDesign(.rounded)
                    })
                    .padding(20)
                    .opacity(jobTitle.isEmpty || company.isEmpty ? 0.5 : 1)
                    .disabled(jobTitle.isEmpty || company.isEmpty)
                    
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(20)
            }
            .font(.subheadline)
            .padding(.top, 100)
        }
        .background(content: {
            VStack(spacing: 0) {
                Color.customBlue
                    .frame(height: UIScreen.main.bounds.height / 3)
                Color.secondary.opacity(0.15)
                
            }
        })
        .ignoresSafeArea()
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
                .tint(.primary)
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Methods
    
    private func saveApplication() {
        
        let application = Application(context: managedObjectContext)
        application.id = UUID()
        application.jobTitle = jobTitle
        application.company = company
        application.location = location
        application.employmentType = employmentType
        application.workMode = workMode
        application.dateApplied = dateApplied
        application.applicationStatus = applicationStatus
        application.note = note
        
        do {
            try self.managedObjectContext.save()
            print("Application saved!")
            
            DispatchQueue.main.async {
                dismiss()
            }
        } catch {
            print("whoops \(error.localizedDescription)")
        }
        
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
                .modifier(RoundedRectangleModifier(cornerRadius: 30))
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
            .tint(.primary)
        }
    }
}


// MARK: - AddJobApplicationView Preview

#if DEBUG
#Preview {
    AddJobApplicationView()
}
#endif

