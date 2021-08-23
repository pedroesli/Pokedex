//
//  PokemonImageRequest.swift
//  Pokedex
//
//  Created by Pedro Ésli Vieira do Nascimento on 19/08/21.
//
//  https://github.com/PokeAPI/sprites/raw/master/sprites/pokemon/1.png

import Foundation
import UIKit

struct PokemonImageRequest {
    private static let urlString = "https://github.com/PokeAPI/sprites/raw/master/sprites/pokemon/"
    
    static func getImage(id: Int, complition: @escaping (Result<UIImage, PokemonsError>) -> Void){
        guard let url = URL(string: urlString + String(id) + ".png") else{
            complition(.failure(.urlError))
            return
        }
        
        let getImageData = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                complition(.failure(.noDataAvailable))
                return
            }
            
            guard let image = UIImage(data: data) else{
                complition(.failure(.canNotProcessData))
                return
            }
            
            complition(.success(image))
        }
        
        getImageData.resume()
    }
}
