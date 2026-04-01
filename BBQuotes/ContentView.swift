//
//  ContentView.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 21/01/26.
//

import SwiftUI

struct ContentView: View {
    //@State var randomQuote: Quote?
    
    var body: some View {
        TabView {
            
            //MARK: Breaking Bad Tab
            Tab(Constants.bbName, systemImage: "tortoise") {
                FetchView(show: Constants.bbName)
                    //.toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            //MARK: Better Call Saul Tab
            Tab(Constants.bcsName, systemImage: "briefcase") {
                FetchView(show: Constants.bcsName)
                    //.toolbarBackgroundVisibility(.visible, for: .tabBar)
                
            }
            
            //MARK:
            Tab(Constants.ecName, systemImage: "car") {
                FetchView(show: Constants.ecName)
                //.toolbarBackgroundVisibility(.visible, for: .tabBar)
                
            }

            
        }
//        .task {
//            do {
//                randomQuote = try await FetchService().fetchQuote(from: "Better call saul")
//            } catch {
//                print("Error fetching: \(error)")
//            }
//        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
