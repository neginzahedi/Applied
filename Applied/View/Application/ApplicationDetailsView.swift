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
    
    @State private var showDeleteConfirmationDialog: Bool = false
    @State private var showStatusConfirmationDialog: Bool = false
    @State private var showCreateEventSheet: Bool = false
    @State private var showEventPopOver: Bool = false
    
    
    // MARK: - Body
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 20){
                jobTitleView()
                Divider()
                applicationInfoView()
                Divider()
                noteView()
                Divider()
                upcomingScheduleView()
            }
            .padding(.horizontal,20)
            Spacer()
        }
        .scrollIndicators(.hidden)
        
        // MARK: - Confirmation Dialog
        .confirmationDialog("Change Status", isPresented: $showStatusConfirmationDialog) {
            ForEach(Constants.applicationStatuses, id: \.self) { status in
                Button(action: {
                    application.applicationStatus_ = status
                    showStatusConfirmationDialog = false
                }) {
                    Text(status)
                }
            }
        } message: {
            Text("Current Status: \(application.applicationStatus_)")
        }
        
        .confirmationDialog("Delete Application",
                            isPresented: $showDeleteConfirmationDialog,
                            titleVisibility: .visible) {
            Button(role: .destructive) {
                Application.delete(application: application)
                //DataController.shared.save()
                dismiss()
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete \(application.jobTitle ?? "this") application?")
        }
        
        // MARK: - Sheet
        
        .sheet(isPresented: $showCreateEventSheet) {
            CreateEventSheet(application: application)
        }
        
        // MARK: - Toolbar
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
                        showCreateEventSheet.toggle()
                    }, label: {
                        HStack{
                            Text("Create Event")
                            Image(systemName: "calendar.badge.plus")
                        }
                    })
                    
                    Button(action: {
                        showStatusConfirmationDialog.toggle()
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
                        showDeleteConfirmationDialog.toggle()
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
    
    // MARK: - SubViews
    
    private func jobTitleView() -> some View {
        VStack(alignment: .leading){
            Text(application.jobTitle_)
                .font(.title3)
                .bold()
            Text(application.company_)
                .foregroundStyle(.secondary)
        }
    }
    
    private func applicationInfoView() -> some View {
        VStack(spacing: 25){
            HStack{
                infoView(icon: "globe.desk", title: "Location", text: application.location_.isEmpty ? "N/A" : application.location_)
                infoView(icon: "briefcase", title: "Employment Type", text: application.employmentType_ + " - " + application.workMode_)
            }
            HStack{
                infoView(icon: "calendar", title: "Date Applied", text: Utils.formatDateToMonthDayYear(application.dateApplied_))
                infoView(icon: "folder.badge.questionmark", title: "Application's Status", text: application.applicationStatus_)
            }
        }
        .bold()
    }
    
    private func noteView() -> some View {
        DisclosureGroup {
            if application.note_.isEmpty{
                HStack{
                    Text("There is no note for this application.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            } else {
                HStack{
                    Text(application.note_)
                        .font(.callout)
                    Spacer()
                }
            }
        }label: {
            Text("Note")
                .font(.headline)
        }
        .tint(.primary)
    }
    
    private func upcomingScheduleView() -> some View {
        VStack(alignment: .leading){
            HStack{
                Text("Upcoming Schedule")
                    .font(.headline)
                Spacer()
                Button {
                    showCreateEventSheet.toggle()
                } label: {
                    Image(systemName: "calendar.badge.plus")
                }
                
            }
            VStack{
                if application.events_.isEmpty {
                    Text("There is no upcoming events for this application.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView{
                        VStack{
                            let events = application.events_.sorted{$0.dueDate_ < $1.dueDate_}
                            ForEach(events) { event in
                                UpcomingInterviewCardView(event: event)
                            }
                        }
                    }
                }
            }
        }
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
