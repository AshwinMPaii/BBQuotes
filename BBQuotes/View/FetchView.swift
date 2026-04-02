//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 09/02/26.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String
    
    @State var showCharacterInfo = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.removeCaseAndSpace())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .loading:
                            ProgressView()
                        case .successQuote:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                AsyncImage(
                                    url: vm.character.images.randomElement()) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                                
                                Text("\(vm.character.name)")
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                            
                        case .successCharacter:
                            randomCharacterView(character: vm.randomCharacter, show: show, vm: vm)
                            
                            
                        case .failure(let error):
                            Text(error.localizedDescription)
                            
                        }
                        
                        Spacer(minLength: 20)

                    }
                    HStack(spacing: 12) {
                        Button {
                            Task {
                                await vm.getQuoteData(from: show)
                            }
                        } label: {
                            Text("Get Quote")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                //.frame(maxWidth: .infinity)
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        
                        //Spacer()
                        
                        Button {
                            Task {
                                await vm.getCharacterData(from: show)
                            }
                        } label: {
                            Text("Get Character")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                                
                        }

                        //Spacer()
                        
                        Button {
                            Task {
                                await vm.getEpisodeData(from: show)
                            }
                        } label: {
                            Text("Get Episode")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                //.frame(maxWidth: .infinity)
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                    }
                    .padding(.horizontal, 30)
                    Spacer(minLength: 95)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .task {
            await vm.getQuoteData(from: show)
        }
        .fullScreenCover(isPresented: $showCharacterInfo) {
            CharacterView(character: vm.character, show: show)
        }
        
    }
}

#Preview {
    FetchView(show: "Breaking Bad")
        .preferredColorScheme(.dark)
}
