//
//  Untitled.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 20/02/26.
//

import SwiftUI

struct CharacterView: View {
    @Environment(\.dismiss) var dismiss
    let character: Char
    let show: String
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.removeCaseAndSpace())
                        .resizable()
                        .scaledToFit()
                
                
                ScrollView {
                    
                    TabView {
                        ForEach(character.images, id: \.self) { characterImageURL in
                            AsyncImage(url: characterImageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            
                        }
                        
                    }
                    .tabViewStyle(.page)
                    .frame(width: geo.size.width/1.2, height: geo.size.height/1.7)
                    .clipShape(.rect(cornerRadius: 25))
                    .padding(.top, 60)
                    
                    VStack(alignment: .center) {
                        Text(character.name)
                            .font(.largeTitle)
                        Text("Portrayed by: \(character.portrayedBy)")
                            .font(.subheadline)
                        
                        Divider()
                        
                        Text("\(character.name) Character Info")
                            .font(.title2)
                        Text("Born: \(character.birthday)")
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Occupations:")
                            ForEach(character.occupations, id: \.self) { occupation in
                                Text("• \(occupation)")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            Text("Nicknames:")
                            
                            if character.aliases.count > 0 {
                                ForEach(character.aliases, id: \.self) { alias in
                                    Text("• \(alias)")
                                        .font(.subheadline)
                                }
                            } else {
                                Text("None")
                                    .font(.subheadline)
                            }
                            
                            Divider()
                            
                            DisclosureGroup("Status: (Spoiler Alert!)") {
                                VStack(alignment: .leading) {
                                    Text(character.status)
                                        .font(.title2)
                                    
                                    if let death = character.death {
                                        AsyncImage(url: death.image) {  image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear {
                                                    withAnimation {
                                                        proxy.scrollTo(1,anchor: .bottom)
                                                        
                                                    }
                                                }
                                            
                                            
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        Text("How: \(death.details)")
                                            .padding(.bottom, 7)
                                        
                                        Text("Last words: \"\(death.lastWords)\"")
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .tint(.primary)
                        }
                        .frame(width: geo.size.width/1.25, alignment: .leading)
                    }
                    .frame(width: geo.size.width, alignment: .center)
                    .padding(.bottom)
                    .background(Color(.systemBackground))
                    .id(1)
                    
                }
                .scrollIndicators(.hidden)
            }
                
            }
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .padding()
                    .foregroundStyle(.white)
            }
            .padding(.top, 50)
            .padding(.leading, 30)
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: "Breaking Bad")
        .preferredColorScheme(.dark)
}
