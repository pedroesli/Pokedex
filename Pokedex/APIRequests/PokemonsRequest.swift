//
//  PokemonsRequest.swift
//  Pokedex
//
//  Created by Pedro Ésli Vieira do Nascimento on 18/08/21.
// 

import Foundation

enum PokemonsError: Error{
    case noDataAvailable
    case canNotProcessData
    case urlError
}

struct PokemonsRequest {
    var resourceURL: URL
    
    init(offset: Int, limit: Int){
        let resourceString = "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=\(limit)"
        
        guard let resourceURL = URL(string: resourceString) else{
            fatalError("PokemonsRequest Fatal Error!")
        }
        
        self.resourceURL = resourceURL
    }
    
    init(url: String){
        guard let resourceURL = URL(string: url) else{
            fatalError("PokemonsRequest Fatal Error! Error transforming url: \(url)")
        }
        
        self.resourceURL = resourceURL
    }
    
    func getPokemons (completion: @escaping (Result<Pokemons, PokemonsError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL){data,_,_ in
            guard let jsonData = data else{
                completion(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let pokemonsResponse = try decoder.decode(Pokemons.self, from: jsonData)
                completion(.success(pokemonsResponse))
            }catch{
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
    
    mutating func setURL(_ nextURL: String){
        guard let resourceURL = URL(string: nextURL) else{
            fatalError("PokemonsRequest setNextURL Fatal Error!")
        }
        
        self.resourceURL = resourceURL
    }
    
    func search(pokemonName: String, completion: @escaping (Result<[PokemonResource], PokemonsError>) -> Void){
        getPokemons { result in
            switch result{
            case .success(let pokemons):
                let pokemonResult = pokemons.results.filter { result in
                    return result.name.contains(pokemonName.lowercased())
                }
                
                completion(.success(pokemonResult))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
