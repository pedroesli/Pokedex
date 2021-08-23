//
//  Pokemons.swift
//  Pokedex
//
//  Created by Pedro Ésli Vieira do Nascimento on 18/08/21.
//

import Foundation

struct Pokemons: Decodable{
    var count: Int
    var next: String
    var results: [PokemonResource]
}

struct PokemonResource: Decodable{
    var name: String
    var url: String
    var id: Int{
        get{
            let strSplit = url.split(separator: "/")
            var id = 0
            
            for item in strSplit{
                if let intVal = Int(item){
                     id = intVal
                }
            }
            
            return id
        }
    }
}
