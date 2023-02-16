//
//  NewTodoField.swift
//  To-Day
//
//  Created by Sarah Reichelt on 16/2/2023.
//

import SwiftUI

struct NewTodoField: View {
  @ObservedObject var appState: AppState
  @State private var newTitle = ""
  @FocusState var editFieldHasFocus: Bool

  var body: some View {
    TextField("Enter new todo and press Return.", text: $newTitle)
      .focused($editFieldHasFocus)
      .onSubmit() {
        // only works with Return
        if !newTitle.isEmpty {
          appState.createNewTodo(title: newTitle)
          newTitle = ""
          editFieldHasFocus = true
        }
      }
      .onAppear {
        editFieldHasFocus = true
      }
  }
}

struct NewTodoField_Previews: PreviewProvider {
  static var previews: some View {
    NewTodoField(appState: AppState())
      .frame(width: 350)
  }
}
