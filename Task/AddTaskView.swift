//
//  AddTaskView.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct AddTaskView: View {
    @Environment(\.presentationMode) private var presentation
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var viewModel: Self.ViewModel = .init()
    
    @Binding var title: String
    @Binding var tasks: String
    
    @State private var tags: [Tag] = [
        Tag(title: "Long", style: .long, color: .blue),
        Tag(title: "Favorites", style: .favorite, color: .orange)
    ]
    @State private var isFavorites: Bool = false
    @State private var isLong: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("", text: $title)
                }.font(.title3)
                
                Section("Tasks") {
                    TextEditor(text: $tasks)
                }.font(.title3)
                
                Section("Tags") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(tags, id: \.self) { tag in
                                buttonItem(tag: tag)
                            }
                        }
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
    
    private func buttonItem(tag: Tag) -> some View {
        VStack {
            if case .long = tag.style {
                EmptyButtonView(title: tag.title, isSelect: isLong, color: tag.color) {
                    isLong.toggle()
                }
            }
            else if case .favorite = tag.style {
                EmptyButtonView(title: tag.title, isSelect: isFavorites, color: tag.color) {
                    isFavorites.toggle()
                }
            }
        }
    }
    
    private struct EmptyButtonView: View {
        var title: String
        var isSelect: Bool
        var color: Color
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
            }.buttonStyle(EmptyButton(color: color, isSelect: isSelect))
        }
    }
    
    private var leadingItem: some View {
        Button(action: {
            tasks = ""
            title = ""
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
                    task.isLong = isLong
                    task.isFavorites = isFavorites
                    
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
    
    private struct Tag: Hashable {
        var title: String
        var style: ButtonsStyle
        var color: Color
    }
}
