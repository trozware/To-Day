//
//  SettingsGroup.swift
//  To-Day
//
//  Created by Sarah Reichelt on 18/2/2023.
//

import SwiftUI
import ServiceManagement

struct SettingsGroup: View {
  @EnvironmentObject var appState: AppState
  @State private var launchOnLogin = SMAppService.mainApp.status == .enabled

  var body: some View {
    Group {
      Divider()

      Toggle("Completed at End", isOn: appState.$sortCompletedToEnd)

      Toggle("Launch on Login", isOn: $launchOnLogin)
        .onChange(of: launchOnLogin) { _ in
          toggleLaunchOnLogin()
        }
    }
  }

  func toggleLaunchOnLogin() {
    do {
      if SMAppService.mainApp.status == .enabled {
        try SMAppService.mainApp.unregister()
      } else {
        try SMAppService.mainApp.register()
      }
    } catch {
      print(error)
    }
  }
}

struct SettingsGroup_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      SettingsGroup()
        .environmentObject(AppState())
    }
  }
}
