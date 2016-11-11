//
//  PokeCell.swift
//  Pokedex
//
//  Created by Tomas-William Haffenden on 11/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
 
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!
    
//This is allow for image layers/styles to be added to cells
    required init?(coder eDecoder: NSCoder) {
        super.init(coder: eDecoder)
        
        layer.cornerRadius = 10.0
    }
  
//Info used for each cell - name and ID
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLabel.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
}
