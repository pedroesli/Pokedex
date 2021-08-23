//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Pedro Ésli Vieira do Nascimento on 19/08/21.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "PokemonCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 15
    }

    func configure(pokemon: PokemonResource, image: UIImage){
        label.text = "#\(pokemon.id) \(pokemon.name.capitalized)"
        imageView.image = image
    }
    
    func setLabel(pokemon: PokemonResource){
        label.text = "#\(pokemon.id) \(pokemon.name.capitalized)"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
