//
//  ContentView.swift
//  Applied
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateApplied", ascending: false)]) var applications: FetchedResults<Application>
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(applications){ application in
                    VStack(alignment: .leading){
                        Text("\(application.jobTitle ?? "job title")")
                        Text("\(application.companyName ?? "company's name")")
                            .font(.footnote)
                        HStack{
                            Text(formatDateToMonthDayYear(application.dateApplied!))
                                .font(.caption)
                            Spacer()
                            Text(application.applicationStatus ?? "status")
                                .font(.caption)
                                .padding(5)
                                .background(application.applicationStatus == "Not Selected" ? .red.opacity(0.8) : .yellow.opacity(0.8), in: Capsule())
                        }
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
                            // TODO: handle the Core Data error
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
    
    // MARK: - Methods
    
    func formatDateToMonthDayYear(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
