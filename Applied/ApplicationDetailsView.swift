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
    //@State var applicationStatus: String
    @State private var showDeleteConfirmation: Bool = false
    @State private var showStatusConfirmation: Bool = false
    @State private var showingSheet = false
    
    
    // MARK: - Body
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 20){
                jobTitleView()
                Divider()
                applicationInfoView()
                Divider()
                DisclosureGroup {
                    HStack{
                        Text(application.note_)
                            .font(.callout)
                        Spacer()
                    }
                } label: {
                    Text("Note")
                        .font(.headline)
                }
                .tint(.primary)
                
                Divider()
                // schedule view
                VStack(alignment: .leading){
                    Text("Upcoming Schedule")
                        .font(.headline)
                    VStack{
                        Text("There is no upcoming events for this application.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        ScrollView{
                            VStack{
                                ForEach(application.events_.sorted(by: { $0.startDate_ < $1.startDate_ }), id:\.id_) { event in
                                    UpcomingInterviewCardView(event: event)
                                }
                            }
                        }
                        
                    }
                }
            }
            .padding(.horizontal,20)
        }
        .scrollIndicators(.hidden)
        
        
        .confirmationDialog("Change Status", isPresented: $showStatusConfirmation) {
            ForEach(Constants.applicationStatuses, id: \.self) { status in
                
                Button(action: {
                    // Update the application status here
                    application.applicationStatus_ = status
                    // Dismiss the confirmation dialog
                    DataController.shared.save()
                    showStatusConfirmation = false
                }) {
                    Text(status)
                }
            }
        } message: {
            Text("Current Status: \(application.applicationStatus_)")
        }
        
        .confirmationDialog("Delete Application",
                            isPresented: $showDeleteConfirmation,
                            titleVisibility: .visible) {
            Button(role: .destructive) {
                Application.delete(application: application)
                DataController.shared.save()
                dismiss()
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete \(application.jobTitle ?? "this") application?")
        }
        
        .sheet(isPresented: $showingSheet) {
            SheetView(application: application)
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
                        showingSheet.toggle()
                    }, label: {
                        HStack{
                            Text("add event")
                            Image(systemName: "plus")
                        }
                    })
                    
                    Button(action: {
                        showStatusConfirmation.toggle()
                    }, label: {
                        HStack{
                            Text("Update Status")
                            Image(systemName: "folder.badge.questionmark")
                        }
                    })
                    
                    NavigationLink {
                        EditApplicationView(application: application)
                    } label: {
                        HStack{
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                    }
                    
                    Button(role: .destructive, action: {
                        showDeleteConfirmation.toggle()
                    }, label: {
                        HStack{
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    })
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
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
            HStack{
                infoView(icon: "globe.desk", title: "Location", text: application.location ?? Constants.defaultText)
                infoView(icon: "briefcase", title: "Employment Type", text: (application.employmentType ?? Constants.defaultText) + " - " + (application.workMode ?? Constants.defaultText))
            }
            HStack{
                infoView(icon: "calendar", title: "Date Applied", text: Utils.formatDateToMonthDayYear(application.dateApplied ?? Date()))
                infoView(icon: "folder.badge.questionmark", title: "Application's Status", text: application.applicationStatus_)
            }
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
            .font(.caption)
            HStack{
                Text(text)
                Spacer()
            }
            .font(.footnote)
        }
    }
}


// MARK: - Preview

#Preview {
    ApplicationDetailsView(application: Application.example)
}


struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var eventTitle: String = ""
    @State private var startDate: Date = Date()
    @State private var EndDate: Date = Date()
    @State private var note: String = ""
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var application: Application

    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextFieldWithTitle(title: "Title", placeholder: "Enter event title (required)", text: $eventTitle)
                DatePicker("Start Date", selection: $startDate)
                    .bold()
                DatePicker("End Date", selection: $EndDate, in: startDate...)
                    .bold()
                CharacterLimitedTextEditor(text: $note, characterLimit: 100)
                    .modifier(RoundedRectangleModifier(cornerRadius: 10))
            }
            .padding()
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        // TODO: ADD new event
                        let newEvent = Event(title: eventTitle, endDate: EndDate, startDate: startDate, note: note, context: managedObjectContext)
                        application.addToEvents(newEvent)
                        DataController.shared.save()
                        dismiss()
                    }
                }
            })
        }
    }
}
