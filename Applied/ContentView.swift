//
//  ContentView.swift
//  Applied
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: []) var applications: FetchedResults<Application>
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(applications){ application in
                    HStack{
                        Text(application.jobTitle ?? "title")
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        let application = applications[index]
                        // MARK: Core Data Operations
                        self.managedObjectContext.delete(application)
                        do {
                            try managedObjectContext.save()
                            print("perform delete")
                        } catch {
                            // handle the Core Data error
                        }
                    }
                })
            }
            .navigationTitle("Applications")
            .toolbar{
                ToolbarItem {
                    NavigationLink("Add") {
                        AddJobApplicationView()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
