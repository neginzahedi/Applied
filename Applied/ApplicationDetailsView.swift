//
//  ApplicationDetailsView.swift
//  Applied
//

import SwiftUI
import CoreData

struct ApplicationDetailsView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var application: Application
    @State var applicationStatus: String
    @State private var showConfirmation: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 15){
            jobTitleView()
            applicationInfoView()
            if let note = application.note, !note.isEmpty {
                noteView(note: note)
            }
            statusPicker()
            Spacer()
            actionButtons()
        }
        .padding()
        
        
        .confirmationDialog("Delete Application",
                            isPresented: $showConfirmation,
                            titleVisibility: .visible) {
            Button(role: .destructive) {
                deleteApplication(application: application)
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete \(application.jobTitle ?? "this") application?")
        }
        
        .navigationTitle("Application Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Views
    
    private func jobTitleView() -> some View {
        HStack{
            Spacer()
            Text(application.jobTitle ?? "Job Title")
                .font(.headline)
                .bold()
            Spacer()
        }
        .modifier(RoundedRectangleModifier(cornerRadius: 10))
        .background(.customYellow, in: RoundedRectangle(cornerRadius: 10))
    }
    
    private func applicationInfoView() -> some View {
        VStack(alignment: .center, spacing: 10){
            VStack(spacing: 25){
                infoView(title: "Company", text: application.company ?? "company")
                infoView(title: "Location", text: application.location ?? "Location")
                infoView(title: "Employment Type", text: application.employmentType ?? "Employment Type")
                infoView(title: "Work Mode", text: application.workMode ?? "Work Mode")
                infoView(title: "Date Applied", text: Utils.formatDateToMonthDayYear(application.dateApplied ?? Date()))
            }
        }
        .modifier(RoundedRectangleModifier(cornerRadius: 10))
        .background(.white, in: RoundedRectangle(cornerRadius: 10))
        
    }
    
    private func infoView(title: String, text: String) -> some View {
        HStack{
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(text)
        }
    }
    
    private func noteView(note: String) -> some View {
        VStack(alignment: .leading){
            HStack{
                Text("Note:")
                Spacer()
            }
            Text(note)
        }
        .modifier(RoundedRectangleModifier(cornerRadius: 10))
        .background(.white, in: RoundedRectangle(cornerRadius: 10))
    }
    
    private func statusPicker() -> some View{
        HStack{
            Text("Application Status")
                .foregroundStyle(.secondary)
            Spacer()
            Picker("Status", selection: $applicationStatus) {
                ForEach(Constants.applicationStatuses, id: \.self) { status in
                    Text(status)
                        .tag(status)
                }
            }
            .tint(.primary)
            .onChange(of: applicationStatus) {
                saveChanges()
            }
        }
        .modifier(RoundedRectangleModifier(cornerRadius: 10))
        .background(.white, in: RoundedRectangle(cornerRadius: 10))
    }
    
    private func actionButtons() -> some View{
        HStack(spacing: 15){
            Button(action: {
                // TODO: Edit applications, navigate to edit view
                print("edited")
            }, label: {
                HStack{
                    Spacer()
                    Text("Edit")
                    Spacer()
                }
                .modifier(RoundedRectangleModifier(cornerRadius: 10))
                .background(.customBlue, in: RoundedRectangle(cornerRadius: 10))
                .foregroundColor(.black)
                .font(.headline)
                .fontDesign(.rounded)
            })
            
            Button(action: {
                showConfirmation.toggle()
            }, label: {
                HStack{
                    Spacer()
                    Text("Delete")
                    Spacer()
                }
                .modifier(RoundedRectangleModifier(cornerRadius: 10))
                .background(.customPink, in: RoundedRectangle(cornerRadius: 10))
                .foregroundColor(.black)
                .font(.headline)
                .fontDesign(.rounded)
            })
        }
        .padding(.bottom, 10)
    }
    
    // MARK: - Methods
    
    private func saveChanges() {
        guard let context = application.managedObjectContext else {
            fatalError("Application's managed object context is nil.")
        }
        
        context.perform {
            do {
                application.applicationStatus = applicationStatus
                try context.save()
                print("Application status updated.")
            } catch {
                print("Error updating application status: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteApplication(application: Application) {
        guard let context = application.managedObjectContext else {
            fatalError("Application's managed object context is nil.")
        }
        
        context.perform {
            context.delete(application)
            
            do {
                try context.save()
                print("Application deleted.")
                
                DispatchQueue.main.async {
                    dismiss()
                }
            } catch {
                print("Failed to delete application: \(error.localizedDescription)")
            }
        }
    }
}



//#Preview {
//    ApplicationDetailsView()
//}
