//
//  PokemonViewModel.swift
//  PokemonFinder
//
//  Created by Justin on 4/15/23.
//

import Foundation
import PokemonAPI

class PokemonViewModel {
    
    private var pokemon = [PKMPokemon]()
    private var pokemonEntries = [PKMPokemonEntry]()
    private var cachedPokmeon = [PKMPokemon]()
    
    private func fetchPokedex() async throws {
        if !cachedPokmeon.isEmpty {
            pokemon = cachedPokmeon
        } else {
            do {
                let pokedex = try await PokemonAPI().gameService.fetchPokedex("kanto")
                if let pokemonEntries = pokedex.pokemonEntries {
                    self.pokemonEntries = pokemonEntries
                }
            } catch {
                print(error.localizedDescription)
            }
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
    
    public func fetchPokemonLocations(pokemon: PKMPokemon) async throws {
        do {
            if let locationURLString = pokemon.locationAreaEncounters, let locationURL = URL(string: locationURLString) {
                let data = try await URLSession.shared.data(from: locationURL)
                
                let locationAreaEncounters = try JSONDecoder().decode([PKMLocationAreaEncounter].self, from: data.0)

                for locationAreaEncounter in locationAreaEncounters {
                    
                }
            }
        } catch {
            print(error.localizedDescription)
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
