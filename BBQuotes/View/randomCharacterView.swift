//
//  randomCharacterView.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 02/04/26.
//

import SwiftUI

struct randomCharacterView: View {
    let character: Char
    let show: String
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
            VStack(alignment: .leading) {
                        
                        TabView {
                            ForEach(character.images, id: \.self) { characterImageURL in
                                AsyncImage(url: characterImageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                
                            }
                            
                        }
                        .tabViewStyle(.page)
                        //.frame(width: 350, height: 550)
                        .clipShape(.rect(cornerRadius: 25))
                        //.padding(.top, 60)
                        
                        VStack(alignment: .center) {
                            Text(character.name)
                                .font(.largeTitle)
                            Text("Portrayed by: \(character.portrayedBy)")
                                .font(.subheadline)
                            
                            VStack(spacing: 12) {
                                
                                if vm.isFetchingCharacterQuote {
                                    ProgressView()
                                } else {
                                    Text("\"\(vm.characterQuote.quote)\"")
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .clipShape(.rect(cornerRadius: 15))
                                }
                                
                                Button {
                                    Task {
                                        await vm.getQuoteForCharacter(for: character.name)
                                    }
                                } label: {
                                    Text("Get Quote")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color("\(show.removeSpaces())Button"))
                                        .clipShape(.rect(cornerRadius: 10))
                                }
                            }
                            .padding(.top)
                        }
                        
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.6))
                    .clipShape(.rect(cornerRadius: 25))
                    .padding(.horizontal)
    }
}

#Preview {
    randomCharacterView(character: ViewModel().character, show: "Breaking Bad", vm: ViewModel())
}
