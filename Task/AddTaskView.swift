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
    
    @ObservedObject private var viewModel: Self.ViewModel = .init()
    
    @Binding var title: String
    @Binding var tasks: String
    
    @State private var tags: [Tags] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("", text: $title)
                }.font(.headline)
                
                Section("Tasks") {
                    TextEditor(text: $tasks)
                }.font(.headline)
                
                Section("Tags") {
                    ScrollView(.horizontal) {
                        Text("Long")
                        Text("Favorites")
                    }
                }
            }
            .navigationTitle(Text("New Task"))
            .navigationBarItems(leading: leadingItem, trailing: trailingItem)
            .alert(isPresented: $viewModel.isError) {
                Alert(title: Text(viewModel.errorTitle), message: Text(viewModel.errorMessage), dismissButton: .cancel())
            }
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
                if title.isEmpty || tasks.isEmpty {
                    viewModel.errorTitle = "Empty fields"
                    viewModel.errorMessage = "Fill in all the fields"
                    viewModel.isError = true
                } else {
                    let task = SimpleTasks(context: viewContext)
                    task.date = Date()
                    task.title = title
                    task.task = tasks
                    
                    tasks = ""
                    title = ""
                    
                    presentation.wrappedValue.dismiss()
                    
                    do {
                        try viewContext.save()
                    } catch {
                        print("Error add Task: \(error)")
                    }
                }
            }
        }) {
            Text("Done")
        }
    }
    
    struct Tags: Hashable {
        var title: String
//        var style:
//        var
    }
}
