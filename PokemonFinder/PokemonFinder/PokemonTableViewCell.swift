//
//  PokemonTableViewCell.swift
//  PokemonFinder
//
//  Created by Justin on 4/14/23.
//

import UIKit
import PokemonAPI

class PokemonTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let pokemonNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonNumberLabel)
        
        let marginGuide = contentView.layoutMarginsGuide
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            pokemonImageView.centerYAnchor.constraint(equalTo: marginGuide.centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            
            pokemonNumberLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16),
            pokemonNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            pokemonNumberLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            pokemonNumberLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with pokemon: PKMPokemon) {
        nameLabel.text = pokemon.name?.capitalized
        if let pokemonNumber = pokemon.id {
            pokemonNumberLabel.text = "#\(pokemonNumber)"
        }
        pokemonImageView.image = UIImage(named: "pokeball")
        
        // TODO: Move the image loading logic else where and use async/await
        if let spriteURL = URL(string: pokemon.sprites?.frontDefault ?? "nada") {
            URLSession.shared.dataTask(with: spriteURL) { data, response, error in
                guard let data = data else {
                    print(error?.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    self.pokemonImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
