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
    @State private var note: String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .center,spacing: 30){
                    TextFieldWithTitle(title: "Title", placeholder: "Enter event's title (required)", text: $eventTitle)
                        .onChange(of: eventTitle) {
                            if eventTitle.count > 40 {
                                // Truncate the text to the character limit
                                eventTitle = String(eventTitle.prefix(40))
                            }
                        }
                    VStack(alignment: .leading){
                        DatePicker("Date", selection: $dueDate)
                            .bold()
                    }
                    
                    VStack(alignment: .leading){
                        Text("Note")
                            .bold()
                        CharacterLimitedTextEditor(text: $note, characterLimit: 255)
                            .modifier(RoundedRectangleModifier(cornerRadius: 10))
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
                        let newEvent = Event(title: eventTitle, dueDate: dueDate, note: note, context: managedObjectContext)
                        application.addToEvents(newEvent)
                        //DataController.shared.save()
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
