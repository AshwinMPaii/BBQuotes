//
//  FetchService.swift
//  BBQuotes
//
//  Created by Ashwin Pai on 03/02/26.
//

import Foundation

struct FetchService {
    private enum fetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    func fetchQuote(from show: String) async throws -> Quote {
        //build the fetch url
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems:[URLQueryItem(name: "production", value: show)])
        //fetch the data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        //handle the response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw fetchError.badResponse
        }
        
        //decode the data
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        //return quote
        return quote
    }
    
    func fetchCharacter(_ name: String) async throws -> Char {
        let characterURL = baseURL.appending(path:"characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        //handle the response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw fetchError.badResponse
        }
        
        //decode the data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let characters = try decoder.decode([Char].self, from: data)
        
        return characters[0]
    }
    
    func fetchDeath(_ name: String) async throws -> Death? {
        let deathURL = baseURL.appending(path: "deaths")
        let (data, response) = try await URLSession.shared.data(from: deathURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw fetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let deaths = try decoder.decode([Death].self, from: data)
        
        for death in deaths {
            if death.character == name {
                return death
            }
        }
        return nil
    }
    
    func fetchEpisode(from show: String) async throws -> Episode? {
        let episodeURL = baseURL.appending(path: "episodes")
        let fetchURL = episodeURL.appending(queryItems:[URLQueryItem(name: "production", value: show)])
        //fetch the data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        //handle the response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw fetchError.badResponse
        }
        
        //decode the data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let episodes = try decoder.decode([Episode].self, from: data)
        
        //return quote
        return episodes.randomElement()
    }
    
    func fetchCharacterFromShow(from show: String) async throws -> Char {
        let characterFromShowURL = baseURL.appending(path: "characters/random")
        let fetchURL = characterFromShowURL.appending(queryItems:[URLQueryItem(name: "production", value: show)])
        //fetch the data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        //handle the response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw fetchError.badResponse
        }
        
        //decode the data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let character = try decoder.decode(Char.self, from: data)
        return character
    }
    
    func fetchQuoteForCharacter(for char: String) async throws -> Quote {
        let quoteForCharacterURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteForCharacterURL.appending(queryItems: [URLQueryItem(name: "character", value: char)])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw fetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteFromCharacter = try decoder.decode(Quote.self, from: data)
        return quoteFromCharacter
    }
}
