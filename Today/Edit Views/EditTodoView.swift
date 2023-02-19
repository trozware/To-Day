//
//  EditTodoView.swift
//  To-Day
//
//  Created by Sarah Reichelt on 16/2/2023.
//

import SwiftUI

struct EditTodoView: View {
  @EnvironmentObject var appState: AppState
  @Binding var todo: Todo
  @FocusState var editingTodo: UUID?

  var body: some View {
    HStack {
      TextField("", text: $todo.title)
        .labelsHidden()
        .focused($editingTodo, equals: todo.id)
        .padding(.trailing, 10)

      Spacer()

      HStack(spacing: 20) {
        Button {
          appState.deleteTodo(todo)
        } label: {
          Image(systemName: "trash")
            .foregroundColor(.red)
        }

        Toggle("", isOn: $todo.isComplete)
          .labelsHidden()
          .padding(.trailing, 6)
          .toggleStyle(.switch)
          .tint(.green)
      }
      .buttonStyle(.plain)
    }
    .onChange(of: editingTodo) { newValue in
      if newValue == nil && appState.todoBeingEdited?.id == todo.id {
        appState.todoBeingEdited = nil
      }
      let matchingTodo = appState.todos.first {
        $0.id == newValue
      }
      if let matchingTodo {
        appState.todoBeingEdited = matchingTodo
      }
    }
    .onChange(of: todo.isComplete) { _ in
      appState.saveData()
    }
    .onChange(of: appState.todoBeingEdited) { newValue in
      if let newValue, newValue == todo {
        editingTodo = todo.id
      }
    }
  }
}

struct EditTodoView_Previews: PreviewProvider {
  static var previews: some View {
    EditTodoView(todo: .constant(Todo.sampleToDos[0]))
      .environmentObject(AppState())
      .frame(width: 350)
  }
}
