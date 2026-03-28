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
            Tab("Breaking Bad", systemImage: "tortoise") {
                QuoteView(show: "Breaking Bad")
                    //.toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            Tab("Better call saul", systemImage: "briefcase") {
                QuoteView(show: "Better Call Saul")
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
