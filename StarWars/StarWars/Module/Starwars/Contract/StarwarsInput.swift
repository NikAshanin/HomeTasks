//
//  StarwarsInput.swift
//  Starwars
//
//  Created by Антон Назаров on 16.11.2017.
//

protocol StarwarsInput {
  weak var output: StarwarsDelegate? { get set }
}
