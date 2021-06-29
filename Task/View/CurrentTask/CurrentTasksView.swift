//
//  ContentView.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI
import CoreData

struct CurrentTasksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject
    private var viewModel: TaskApp.ViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SimpleTasks.date, ascending: false)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(booleanLiteral: false)),
        animation: .default)
    private var items: FetchedResults<SimpleTasks>
    
    @State private var isPresentation: Bool = false
    
    var body: some View {
        List {
            Section{
                HStack {
                    Text("Total tasks")
                    Spacer()
                    Text(viewModel.countCurrentTask.description)
                }
            }
            ForEach(items) { item in
                if #available(iOS 15.0, *) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.title ?? "")
                                .font(.headline)
                            HStack {
                                ForEach(item.tags ?? [], id: \.self) { tag in
                                    Text(tag.title ?? "")
                                        .padding(.horizontal)
                                        .padding(.vertical, 4)
                                        .background(tag.color)
                                        .opacity(1)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        Text(item.task ?? "")
                            .lineLimit(1)
                    }
                    .swipeActions {
                        swipeItem(item: item)
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationBarItems(trailing: trailingItem)
        .navigationBarTitle(Text("Current tasks"), displayMode: .inline)
        .fullScreenCover(isPresented: $isPresentation) {
            AddTaskView()
        }
    }
    
    private var trailingItem: some View {
        HStack {
            EditButton()
            Button(action: {
                isPresentation = true
            }) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }
    
    private func swipeItem(item: FetchedResults<SimpleTasks>.Element) -> some View {
        VStack {
            Button(action: {
                deleteItems(offsets: IndexSet(integer: items.firstIndex(of: item)!))
            }) {
                Text("delete")
            }
            Button(action: {
                withAnimation {
                    item.isComplete = true
                    viewModel.countCompletedTask += 1
                    viewModel.countCurrentTask -= 1
                    do {
                        try viewContext.save()
                    } catch {
                        print("Error isComplete: \(error)")
                    }
                }
            }) {
                Image(systemName: "checkmark.circle.fill")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            viewModel.countCurrentTask -= 1
            do {
                try viewContext.save()
            } catch {
                print("Error delete Task: \(error)")
            }
        }
    }
}
