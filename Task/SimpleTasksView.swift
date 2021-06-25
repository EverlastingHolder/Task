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
        sortDescriptors: [NSSortDescriptor(keyPath: \SimpleTasks.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<SimpleTasks>
    
    @State private var isPresentation: Bool = false
    @State private var title: String = ""
    @State private var tasks: String = ""

    var body: some View {
        List {
            ForEach(items) { item in
                VStack(alignment: .leading) {
                    Text(item.title ?? "")
                        .font(.headline)
                    Text(item.task ?? "" )
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationBarItems(trailing: trailingItem)
        .sheet(isPresented: $isPresentation) {
            AddTaskView(title: $title, tasks: $tasks)
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
