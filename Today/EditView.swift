//
//  EditView.swift
//  Today
//
//  Created by Sarah Reichelt on 18/1/2023.
//

import SwiftUI

struct EditView: View {
  @Binding var todos: [Todo]
  @State private var newTitle = ""
  @State private var dataStore = DataStore()

  var body: some View {
    List {
      ForEach($todos) { $todo in
        HStack {
          TextField("", text: $todo.title)

          Spacer()

          HStack(spacing: 20) {
            Button {
              move(todo, direction: "up")
            } label: {
              Image(systemName: "arrow.up")
            }
            .disabled(todo.id == 1)

            Button {
              move(todo, direction: "down")
            } label: {
              Image(systemName: "arrow.down")
            }
            .disabled(todo.id == todos.count)

            Button {
              deleteTodo(todo)
            } label: {
              Image(systemName: "trash")
                .foregroundColor(.red)
            }
          }
          .buttonStyle(.plain)
        }
      }

      TextField("Enter new todo and press Return.", text: $newTitle)
        .onSubmit() {
          // only works with Return
          if !newTitle.isEmpty {
            let newTodo = Todo(id: todos.count + 1, title: newTitle)
            todos.append(newTodo)
            newTitle = ""
            saveChanges()
          }
        }

      Spacer()
    }
    .listStyle(.inset(alternatesRowBackgrounds: true))
    .frame(minWidth: 350)
    .environment(\.defaultMinListRowHeight, 30)
  }

  func deleteTodo(_ todo: Todo) {
    todos.removeAll {
      $0.id == todo.id
    }
    reassignIDs()

    saveChanges()
  }

  func move(_ todo: Todo, direction: String) {
    let todoIndex = todos.firstIndex {
      $0.id == todo.id
    }


    if direction == "up" {
      guard let todoIndex, todoIndex > 0 else {
        return
      }

      todos[todoIndex].id -= 1
      todos[todoIndex - 1].id += 1
    } else {
      guard let todoIndex, todoIndex < todos.count - 1 else {
        return
      }

      todos[todoIndex].id += 1
      todos[todoIndex + 1].id -= 1
    }

    todos.sort(using: KeyPathComparator(\.id))

    saveChanges()
  }

  func reassignIDs() {
    for todoIndex in 0 ..< todos.count {
      todos[todoIndex].id = todoIndex + 1
    }
  }

  func saveChanges() {
    dataStore.saveTodos(todos: todos)
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView(todos: .constant(Todo.sampleToDos))
      .frame(width: 350)
  }
}
