//
//  ExampleApp.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            EntryPointView()
                .onAppear {
                    // Use iOS 13 navigation bar appearance.
                    //
                    // While the entry point scene looks better with an opaque navigation background, the child scenes look
                    // better with the default navigation background. As we can't update the appearance per scene we fallback
                    // to an appearance with the default background here.
                    //
                    // Based on: https://sarunw.com/posts/uinavigationbar-changes-in-ios13/
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithDefaultBackground()

                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
        }
    }
}
