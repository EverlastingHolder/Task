//
//  AddTaskView.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentation
    
    @Binding var title: String
    @Binding var tasks: String
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("", text: $title)
                }
                Section("Tasks") {
                    TextEditor(text: $tasks)
                }
            }
            .navigationTitle(Text("New Task"))
            .navigationBarItems(leading: leadingItem, trailing: trailingItem)
        }
    }
    
    private var leadingItem: some View {
        Button(action: {
            presentation.wrappedValue.dismiss()
        }){
            Text("Back")
        }
    }
    
    private var trailingItem: some View {
        Button(action: {
            withAnimation {
                let task = SimpleTasks(context: viewContext)
                task.date = Date()
                task.title = title
                task.task = tasks
                
                presentation.wrappedValue.dismiss()
                
                do {
                    try viewContext.save()
                } catch {
                    print("Error add Task: \(error)")
                }
            }
        }) {
            Text("Done")
        }
    }
}
