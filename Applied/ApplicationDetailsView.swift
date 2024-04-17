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
    
    private var statusColor: Color {
        switch application.applicationStatus {
        case "Not Selected":
            return .customPink
        case "Offer Accepted":
            return .customGreen
        case "Interview Scheduled":
            return .customBlue
        case "Interviewed":
            return .customBlue
        case "Pending Decision":
            return .customBlue
        default:
            return .customYellow
        }
    }

    // MARK: - Body
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 50){
                VStack(alignment: .leading){
                    Text(application.jobTitle ?? "Job Title")
                        .font(.title3)
                        .bold()
                    Text(application.company ?? "Company")
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 25){
                    HStack{
                        VStack{
                            HStack{
                                Image(systemName: "globe.desk")
                                    .foregroundStyle(.customBlue)
                                Text("Location")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .font(.footnote)
                            HStack{
                                Text(application.location ?? "Location")
                                Spacer()
                            }
                        }
                        VStack{
                            HStack{
                                Image(systemName: "briefcase")
                                    .foregroundStyle(.customPink)
                                Text("Employment Type")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .bold()
                            .font(.footnote)
                            HStack{
                                Text(application.employmentType ?? "")
                                Spacer()
                            }
                        }
                    }
                    
                    HStack{
                        VStack{
                            HStack{
                                Image(systemName: "building.2")
                                    .foregroundStyle(.customGreen)
                                Text("Work Mode")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .font(.footnote)
                            HStack{
                                Text(application.workMode ?? "")
                                Spacer()
                            }
                        }
                        VStack{
                            HStack{
                                Image(systemName: "calendar")
                                    .foregroundStyle(.customYellow)
                                Text("Date Applied")
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                            .bold()
                            .font(.footnote)
                            HStack{
                                Text(Utils.formatDateToMonthDayYear(application.dateApplied ?? Date()))
                                Spacer()
                            }
                        }
                    }
                }
                .bold()
                statusPicker()
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
