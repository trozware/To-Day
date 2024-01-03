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

  var body: some View {
    HStack {
      TextField("", text: $todo.title)
        .labelsHidden()
        .padding(.trailing, 10)

      HStack(spacing: 20) {
        Button {
          appState.deleteTodo(todo)
        } label: {
          Image(systemName: "trash")
            .foregroundColor(.red)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Delete \(todo.title)")

        Toggle("", isOn: $todo.isComplete)
          .labelsHidden()
          .padding(.trailing, 6)
          .toggleStyle(.switch)
          .tint(.green)
          .accessibilityLabel(
            todo.isComplete ? "\(todo.title) complete" : "\(todo.title) not done yet"
          )
      }
    }
    .onSubmit {
      if todo.title.isEmpty {
        appState.deleteTodo(todo)
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
