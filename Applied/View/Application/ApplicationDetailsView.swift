//
//  ApplicationDetailsView.swift
//  Applied
//

import SwiftUI

struct ApplicationDetailsView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var application: Application
    
    @State private var showDeleteConfirmationDialog: Bool = false
    @State private var showStatusConfirmationDialog: Bool = false
    @State private var showCreateEventSheet: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack{
            contentView
                .padding(.horizontal,20)
                .padding(.top, 20)
            Spacer()
        }
        // MARK: - Navigation Bar
        
        .navigationTitle("Application Detail")
        .navigationBarBackButtonHidden()
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                moreOptionsButton
            }
        }
        
        // MARK: - Confirmation Dialog
        
        .confirmationDialog("Change Status",
                            isPresented: $showStatusConfirmationDialog,
                            titleVisibility: .hidden) {
            changeStatusButton
        } message: {
            Text("Current Status: \(application.applicationStatus_)")
        }
        
        .confirmationDialog("Delete Application",
                            isPresented: $showDeleteConfirmationDialog,
                            titleVisibility: .visible) {
            deleteApplicationButton
        } message: {
            Text("Are you sure you want to delete \(application.jobTitle ?? "this") application?")
        }
        
        // MARK: - Sheet
        
        .sheet(isPresented: $showCreateEventSheet) {
            CreateEventSheet(application: application)
        }
    }
    
    // MARK: - Computed Properties
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            jobTitleView
            Divider()
            applicationInfoView
            Divider()
            noteView
            Divider()
            upcomingScheduleView
        }
    }
    
    private var jobTitleView: some View {
        VStack(alignment: .leading){
            Text(application.jobTitle_)
                .font(.title3)
                .bold()
            Text(application.company_)
                .foregroundStyle(.secondary)
        }
    }
    
    private var applicationInfoView: some View {
        VStack(spacing: 25){
            HStack{
                InfoItemWithIcon(icon: "globe.desk", title: "Location", text: application.location_.isEmpty ? "N/A" : application.location_)
                InfoItemWithIcon(icon: "briefcase", title: "Employment Type", text: application.employmentType_ + " - " + application.workMode_)
            }
            HStack{
                InfoItemWithIcon(icon: "calendar", title: "Date Applied", text: DateUtils.monthDayYearFormatter.string(from:application.dateApplied_))
                InfoItemWithIcon(icon: "folder.badge.questionmark", title: "Application's Status", text: application.applicationStatus_)
            }
        }
        .bold()
    }
    
    private var noteView: some View {
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
    
    private var upcomingScheduleView: some View {
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
            ScrollView {
                VStack {
                    let currentDate = Date()
                    let events = application.events_
                        .filter { $0.dueDate_ >= currentDate } // Filter events that are not from the past
                        .sorted { $0.dueDate_ < $1.dueDate_ } // Sort remaining events by due date
                    
                    if events.isEmpty {
                        Text("There are no upcoming events for this application.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(events) { event in
                            UpcomingInterviewCardView(event: event)
                        }
                    }
                }
            }
        }
    }
    
    private var moreOptionsButton: some View{
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
    
    private var deleteApplicationButton: some View {
        Button(role: .destructive) {
            Application.delete(application: application)
            dismiss()
        } label: {
            Text("Delete")
        }
    }
    
    private var changeStatusButton: some View{
        ForEach(Constants.applicationStatuses, id: \.self) { status in
            Button(action: {
                application.applicationStatus_ = status
                showStatusConfirmationDialog = false
            }) {
                Text(status)
            }
        }
    }
}


// MARK: - Preview
#if DEBUG
#Preview {
    ApplicationDetailsView(application: Application.example)
}
#endif
