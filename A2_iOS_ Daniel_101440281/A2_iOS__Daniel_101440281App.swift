//
//  A2_iOS__Daniel_101440281App.swift
//  A2_iOS_ Daniel_101440281
//
//  Created by daniel demesa on 2025-04-01.
//

import SwiftUI

@main
struct A2_iOS__Daniel_101440281App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
