//
//  ViewController.swift
//  PokemonFinder
//
//  Created by Justin on 4/5/23.
//

import UIKit
import PokemonAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        PokemonAPI().berryService.fetchBerry(1) { result in
            switch result {
            case .success(let berry):
                 print(berry.name) // cheri
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


}

