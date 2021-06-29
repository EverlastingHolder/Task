//
//  ContentView.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI
import CoreData

@available(iOS 15.0, *)
struct SimpleTasksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SimpleTasks.date, ascending: false)],
        animation: .default)
    private var items: FetchedResults<SimpleTasks>
    
    @State private var isPresentation: Bool = false
    
    var body: some View {
        List {
            ForEach(items) { item in
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
                    Text(item.task ?? "" )
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationBarItems(trailing: trailingItem)
        .navigationTitle(Text("All tasks"))
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error delete Task: \(error)")
            }
        }
    }
}
