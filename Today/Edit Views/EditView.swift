//
//  EditView.swift
//  Today
//
//  Created by Sarah Reichelt on 18/1/2023.
//

import SwiftUI

struct EditView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    VStack {
      Form {
        ForEach($appState.todos) { $todo in
          EditTodoView(todo: $todo)
        }

        VStack(alignment: .leading) {
          Text("Enter new todo and press Return:")
            .accessibilityHidden(true)
          NewTodoField()
        }
      }
      .formStyle(.grouped)
      .textFieldStyle(.squareBorder)

      EditButtons()
    }
    .frame(minWidth: 350, minHeight: 300)

  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView()
      .environmentObject(AppState())
      .frame(width: 350)
  }
}
