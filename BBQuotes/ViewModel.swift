//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 06/02/26.
//

import Foundation

@Observable
@MainActor
class ViewModel: ObservableObject {
    enum FetchStatus {
        case notStarted
        case loading
        case successQuote
        case successEpisode
        case successCharacter
        case failure(error: Error)
    }
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var isFetchingCharacterQuote = false
    var quote: Quote
    var character: Char
    var episode: Episode
    var randomCharacter: Char
    var characterQuote: Quote
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        
        character = try! decoder.decode(Char.self, from: characterData)
        
        let EpisodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        
        episode = try! decoder.decode(Episode.self, from: EpisodeData)
        
        let randomCharacterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        
        randomCharacter = try! decoder.decode(Char.self, from: randomCharacterData)
        
        let characterQuoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        
        characterQuote = try! decoder.decode(Quote.self, from: characterQuoteData)
    }
    
    func getQuoteData(from show: String) async {
        status = .loading
        do {
            quote = try await fetcher.fetchQuote(from: show)
            
            character = try await fetcher.fetchCharacter(quote.character)
            
            character.death = try await fetcher.fetchDeath(character.name)
            
            status = .successQuote

        } catch {
            status = .failure(error: error)
        }
    }
    
    func getEpisodeData(from show: String) async {
        status = .loading
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
            }
            
            status = .successEpisode
        } catch {
            status = .failure(error: error)
        }
    }
    
    func getCharacterData(from show: String) async {
        status = .loading
        do {
            randomCharacter = try await fetcher.fetchCharacterFromShow(from: show)
            
            status = .successCharacter
        } catch {
            status = .failure(error: error)
        }
    }
    
    func getQuoteForCharacter(for char: String) async {
        isFetchingCharacterQuote = true
        do {
            characterQuote = try await fetcher.fetchQuoteForCharacter(for: char)
            isFetchingCharacterQuote = false
        } catch {
            isFetchingCharacterQuote = false
            print(error) // or handle separately
        }
    }
}
