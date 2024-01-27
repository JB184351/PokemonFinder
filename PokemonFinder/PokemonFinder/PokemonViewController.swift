//
//  ViewController.swift
//  PokemonFinder
//
//  Created by Justin on 4/5/23.
//

import UIKit
import PokemonAPI

class PokemonViewController: UIViewController {
    
    let pokemonViewModel = PokemonViewModel()
    var tableView = UITableView()
    var pokemon = [PKMPokemon]()
    var pokemonLocations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        
        Task {
            await self.fetchPokemon()
        }
    }
    
    private func fetchPokemon() async {
        do {
            try await pokemonViewModel.fetchPokemon()
            pokemon = pokemonViewModel.getPokemonList()
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}

extension PokemonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeman = pokemon[indexPath.row]

        let cell = PokemonTableViewCell()
        cell.configure(with: pokeman)
        
        return cell
    }


}

extension PokemonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokeman = pokemon[indexPath.row]
        
        Task {
            try await pokemonLocations = pokemonViewModel.fetchPokemonLocations(pokemon: pokeman)
        }
        
        for location in pokemonLocations {
            print(location)
        }
    }
}

