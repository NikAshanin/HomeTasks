//
//  JsonDecode.swift
//  json
//
//  Created by Sergey Gusev on 22.11.2017.
//  Copyright © 2017 Sergey Gusev. All rights reserved.
//

import Foundation

class JsonDecode {
    typealias dictionaryJSON = [String:Any]
    func getFromName(dataOfJson: Data) -> ([String], String) {
        guard let jsonOfResult = try? JSONSerialization.jsonObject(with: dataOfJson, options: [])  as!  dictionaryJSON else {
            print("error in serialization")
            return ([],"error")
        }
        guard let jsonALL = jsonOfResult["results"] as? [dictionaryJSON] else {
            print("error in serialization results")
            return ([],"error")
        }
        
        
        guard let json = jsonALL.first,
            let name = json["name"] as? String else {
            print("error in json[name]")
            return ([],"error")
        }
        guard let filmsString = json["films"] as? [String] else {
            print("error in json[films]")
            return ([],"error")
        }
        
        return (filmsString, name)
    }
    func getFilms(dataOfJson: Data) -> (String, Date) {
        let nonDate: Date? = nil
        guard let jsonOfFilm = try? JSONSerialization.jsonObject(with: dataOfJson, options: [])  as!  dictionaryJSON else {
            print("error in serialization of films")
            return ("error", nonDate!)
        }
        let title = jsonOfFilm["title"] as? String ?? " "
        let date = jsonOfFilm["release_date"] as? String ?? " "
        let releaseDate = formatter.date(from: date)
        return (title, releaseDate!)
    }
    
}
