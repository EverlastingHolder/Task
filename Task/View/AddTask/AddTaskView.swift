//
//  AddTaskView.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI


struct AddTaskView: View {
    @Environment(\.presentationMode) private var presentation
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject
    private var appViewModel: TaskApp.ViewModel
    
    @ObservedObject private var viewModel: Self.ViewModel = .init()
    
    @State var title: String = ""
    @State var tasks: String = ""
    
    private let tags: [TagItem] = [
        TagItem(title: "Long", style: .long, color: .blue),
        TagItem(title: "Favorites", style: .favorite, color: .orange)
    ]
    
    @State private var arrayTag: [TagItem] = []
    @State private var isFavorites: Bool = false
    @State private var isLong: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Title").font(.callout)
                ) {
                    TextField("", text: $title)
                }.font(.callout)
                
                Section(
                    header: Text("Task").font(.callout)
                ) {
                    TextEditor(text: $tasks)
                }.font(.callout)
                
                Section(
                    header: Text("Tags").font(.callout)
                ) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(tags, id: \.hashValue) { tag in
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
    
    private func buttonItem(tag: TagItem) -> some View {
        VStack {
            if case .long = tag.style {
                TransparentButtonView(title: tag.title ?? "", isSelect: isLong, color: tag.color ?? .clear) {
                    isLong.toggle()
                }
            }
            else if case .favorite = tag.style {
                TransparentButtonView(title: tag.title ?? "", isSelect: isFavorites, color: tag.color ?? .clear) {
                    isFavorites.toggle()
                }
            }
        }
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
                    appViewModel.countCurrentTask += 1
                    
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
