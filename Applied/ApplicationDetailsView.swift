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
        VStack{
            VStack(alignment: .leading, spacing: 20){
                jobTitleView()
                Divider()
                applicationInfoView()
                Divider()
                statusPicker()
                Divider()
                // schedule view
                VStack(alignment: .leading){
                    Text("Upcoming Schedule")
                        .font(.headline)
                    VStack{
                        Text("There is no upcoming events for this application.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .padding(20)
        }
        
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
        
        .navigationTitle("Application Detail")
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.backward")
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
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
                } label: {
                    Image(systemName: "ellipsis")
                    
                }
            }
        }
        .tint(.primary)
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Views
    
    private func jobTitleView() -> some View {
        VStack(alignment: .leading){
            Text(application.jobTitle ?? "Job Title")
                .font(.title3)
                .bold()
            Text(application.company ?? "Company")
                .foregroundStyle(.secondary)
        }
    }
    
    
    private func applicationInfoView() -> some View {
        VStack(spacing: 25){
            infoView(icon: "globe.desk", title: "Location", text: application.location ?? Constants.defaultText)
            infoView(icon: "briefcase", title: "Employment Type", text: (application.employmentType ?? Constants.defaultText) + " - " + (application.workMode ?? Constants.defaultText))
            infoView(icon: "calendar", title: "Date Applied", text: Utils.formatDateToMonthDayYear(application.dateApplied ?? Date()))
        }
        .bold()
    }
    
    private func infoView(icon: String, title: String, text: String) -> some View {
        VStack{
            HStack{
                Image(systemName: icon)
                Text(title)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .font(.footnote)
            HStack{
                Text(text)
                Spacer()
            }
        }
    }
    
    private func statusPicker() -> some View{
        HStack{
            Text("Application Status:")
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
