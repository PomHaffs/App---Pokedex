//
//  ViewController.swift
//  Pokedex
//
//  Created by Tomas-William Haffenden on 11/11/16.
//  Copyright © 2016 PomHaffs. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

//This is the link to the VC
    @IBOutlet weak var collection: UICollectionView!
 
//Search
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemonArray = [Pokemon]()
    var pokemonSearchArray = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!
    
//This is where to define/link the dependancies which inturn allow use to use the methods associated with them.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    //This gets audio ready for AVPlayer
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "mp3")
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
//continous loop
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
//This will parse thru csv data and get whatever we want, goes thru each row, and then takes name and ID, then we append it to pokemon Array
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemonArray.append(poke)
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    

//This is where our cells are created, dequeue only loads screen worth
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = pokemonSearchArray[indexPath.row]
                cell.configureCell(poke)
                
            } else {
                poke = pokemonArray[indexPath.row]
                cell.configureCell(poke)
            }
            
            cell.configureCell(poke)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
//Once cell is selected this code will run and is now linked to PokemonDetailVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = pokemonSearchArray[indexPath.row]
            
        } else {
            poke = pokemonArray[indexPath.row]
        }
//Sender refer to the bit of info you are passing across 
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
//This dictates how many objects are in the view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return pokemonSearchArray.count
            
        }
            return pokemonArray.count
        
    }
    
//This is the number of sections in the view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//This is setting the size of each image NOTE cannot set in storyboard
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
  
//This will play and pause the music and create button effect (alpha)
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2
            
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
//This removes the keyboard on hardware once search completed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
//SEARCH This is allowing for each key stroke to norrow the returned results. This requires a bool for if we are in search mode
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
//SEARCH logic - search bar text included in array
            pokemonSearchArray = pokemonArray.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    
    
    
}


