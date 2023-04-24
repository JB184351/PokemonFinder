//
//  PokemonTableViewCell.swift
//  PokemonFinder
//
//  Created by Justin on 4/14/23.
//

import UIKit
import PokemonAPI

enum ImageError: Error {
    case failedToLoad
}

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

    func loadImage(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageError.failedToLoad
        }
        return image
    }

    
    func configure(with pokemon: PKMPokemon) {
        nameLabel.text = pokemon.name?.capitalized
        if let pokemonEntryNumber = pokemon.id {
            pokemonNumberLabel.text = "#\(pokemonEntryNumber)"
        }
        
        if let spriteURL = URL(string: pokemon.sprites?.frontDefault ?? "nada") {
            Task {
                do {
                    let spriteImage = try await loadImage(url: spriteURL)
                    pokemonImageView.image = spriteImage
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
