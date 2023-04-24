//
//  PokemonViewModel.swift
//  PokemonFinder
//
//  Created by Justin on 4/15/23.
//

import Foundation
import PokemonAPI

struct Pokemon {
    var name: String?
    var url: String?
}

class PokemonViewModel {
    
    var pokemon = [PKMPokemon]()
    var pokemonEntries = [PKMPokemonEntry]()
    var aPokemon: PKMPokemon?
    var pagedObject: PKMPagedObject<PKMPokemon>?
    
    private func fetchPokedex() async throws {
        do {
            let pokedex = try await PokemonAPI().gameService.fetchPokedex("kanto")
            if let pokemonEntries = pokedex.pokemonEntries {
                self.pokemonEntries = pokemonEntries
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func fetchPokemon() async throws {
        try await self.fetchPokedex()
        
        for pokemonEntry in pokemonEntries {
            if let pokemonName = pokemonEntry.pokemonSpecies?.name {
                let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(pokemonName)
                self.pokemon.append(pokemon)
            }
        }
    }
    
    public func numberOfPokemon() -> Int {
        return pokemon.count
    }
    
    public func getPokemonList() -> [PKMPokemon] {
        return pokemon
    }
    
    public func getPokemonEntries() -> [PKMPokemonEntry] {
        return pokemonEntries
    }
}

/*
 PokemonAPI().gameService.fetchPokedex() { result in
     switch result {
         
     case .success(let pokedex):
         self.pokemonEntries = pokedex.pokemonEntries!
     case .failure(let error):
         print(error.localizedDescription)
     }
     
     for pokemonEntry in self.pokemonEntries {
         print("\(pokemonEntry.entryNumber) \(pokemonEntry.pokemonSpecies?.name)")
         
         var pokemon: PKMPokemon?
         if let pokemonName = pokemonEntry.pokemonSpecies?.name {
             PokemonAPI().pokemonService.fetchPokemon(pokemonName) { result in
                 switch result {
                     
                 case .success(let pokemon):
                     self.pokemon = pokemon
                     print(pokemon.name)
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
             }
         }
     }
 }
 */
