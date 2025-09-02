//
//  RandomImagesApp.swift
//  RandomImages
//
//  Created by Sanket Likhe on 9/1/25.
//

import SwiftUI

@main
struct RandomImagesApp: App {
    var body: some Scene {
        WindowGroup {
            //Basic Injection in ContentView
            ContentView(viewModel: AppDependencies.shared.photosViewModel)
        }
    }
}
