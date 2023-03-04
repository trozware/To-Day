//
//  NewTodoField.swift
//  To-Day
//
//  Created by Sarah Reichelt on 16/2/2023.
//

import SwiftUI

struct NewTodoField: View {
  @EnvironmentObject var appState: AppState
  @State private var newTitle = ""

  var body: some View {
    TextField("", text: $newTitle)
      .labelsHidden()
      .onSubmit {
        // only works with Return
        if !newTitle.isEmpty {
          appState.createNewTodo(title: newTitle)
          newTitle = ""
        }
      }
  }
}

struct NewTodoField_Previews: PreviewProvider {
  static var previews: some View {
    NewTodoField()
      .environmentObject(AppState())
      .frame(width: 350)
  }
}
