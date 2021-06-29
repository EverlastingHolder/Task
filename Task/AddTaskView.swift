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
    
    @State var title: String = ""
    @State var tasks: String = ""
    
    @State private var tags: [TagItemCurrent] = [
        TagItemCurrent(title: "Long", style: .long, color: .blue),
        TagItemCurrent(title: "Favorites", style: .favorite, color: .orange)
    ]
    @State private var isFavorites: Bool = false
    @State private var isLong: Bool = false
    
    private let transform: Transformer = Transformer()
//    private let favorites: TagItem = TagItem(title: "", style: .base, color: .clear)
//    private let long: TagItem = TagItem(title: "", style: .base, color: .clear)
    @State private var arrayTag: [TagItem] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("", text: $title)
                }.font(.callout)
                
                Section("Tasks") {
                    TextEditor(text: $tasks)
                }.font(.callout)
                
                Section("Tags") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(tags, id: \.self) { tag in
                                buttonItem(tag: tag)
                            }
                        }
                    }
                }.font(.callout)
            }
            .navigationTitle(Text("New Task"))
            .navigationBarItems(leading: leadingItem, trailing: trailingItem)
            .alert(isPresented: $viewModel.isError) {
                Alert(title: Text(viewModel.errorTitle), message: Text(viewModel.errorMessage), dismissButton: .cancel())
            }
        }
    }
    
    private func buttonItem(tag: TagItemCurrent) -> some View {
        VStack {
            if case .long = tag.style {
                TransparentButtonView(title: tag.title, isSelect: isLong, color: tag.color) {
                    isLong.toggle()
                }
            }
            else if case .favorite = tag.style {
                TransparentButtonView(title: tag.title, isSelect: isFavorites, color: tag.color) {
                    isFavorites.toggle()
                }
            }
        }
    }
    
    private struct TagItemCurrent: Hashable {
        var title: String
        var style: TagsStyle
        var color: Color
    }
    
    private struct TransparentButtonView: View {
        var title: String
        var isSelect: Bool
        var color: Color
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
            }.buttonStyle(TransparentButton(color: color, isSelect: isSelect))
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
                    
                    if isLong {
                        arrayTag.append(TagItem(title: "Long", style: .long, color: .blue))
                    }
                    
                    if isFavorites {
                        arrayTag.append(TagItem(title: "Favorites", style: .favorite, color: .orange))
                    }
                    
                    
                    task.tags = arrayTag
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
}
