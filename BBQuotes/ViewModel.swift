//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 06/02/26.
//

import Foundation

@Observable
@MainActor
class ViewModel {
    enum FetchStatus {
        case notStarted
        case loading
        case successQuote
        case successEpisode
        case failure(error: Error)
    }
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: Char
    var episode: Episode
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        
        character = try! decoder.decode(Char.self, from: characterData)
        
        let EpisodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        
        episode = try! decoder.decode(Episode.self, from: EpisodeData)
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
}
