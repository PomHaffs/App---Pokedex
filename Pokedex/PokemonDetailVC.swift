//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Tomas-William Haffenden on 15/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
//create a new example of the class Pokemon
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name
        
    }


}
