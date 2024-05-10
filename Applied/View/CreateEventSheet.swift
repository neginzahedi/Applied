//
//  CreateEventSheet.swift
//  Applied
//

import SwiftUI

struct CreateEventSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var application: Application
    
    @State private var eventTitle: String = ""
    @State private var dueDate: Date = Date()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .center,spacing: 30){
                    TextFieldWithTitle(title: "Title", placeholder: "Enter event's title (required)", text: $eventTitle)
                        .onChange(of: eventTitle) {
                            if eventTitle.count > 100 {
                                // Truncate the text to the character limit
                                eventTitle = String(eventTitle.prefix(100))
                            }
                        }
                    VStack(alignment: .leading){
                        Text("Date")
                            .bold()
                        DatePicker("Date", selection: $dueDate, in: Date()...)
                            .datePickerStyle(.graphical)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
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
                        let newEvent = Event(title: eventTitle, dueDate: dueDate, context: managedObjectContext)
                        application.addToEvents(newEvent)
                        dismiss()
                    }
                    .disabled(eventTitle.isEmpty)
                }
            })
        }
    }
}

#Preview {
    CreateEventSheet(application: Application.example)
}
