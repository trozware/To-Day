//
//  AppGroup.swift
//  To-Day
//
//  Created by Sarah Reichelt on 18/2/2023.
//

import SwiftUI
import Sparkle

struct AppGroup: View {
  @Environment(\.openWindow) private var openWindow

  private let updaterController = SPUStandardUpdaterController(
    startingUpdater: true,
    updaterDelegate: nil,
    userDriverDelegate: nil
  )

  var body: some View {
    Group {
      Divider()

      CheckForUpdatesView(updater: updaterController.updater)

      Button("About To-Day…") {
        openWindow(id: "about_today")
        NSApp.activate(ignoringOtherApps: true)
      }

      Button("Quit To-Day") {
        NSApp.terminate(nil)
      }
    }
  }
}

struct AppGroup_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      AppGroup()
    }
  }
}
