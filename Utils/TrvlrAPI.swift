//
//  TrvlrAPI.swift
//  Trvlr
//
//  Created by Vo Huy on 8/4/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import Foundation

enum ContinentsResult {
    case success(Continent)
    case failure(ContinentError)
}

enum CountriesResult {
    case success([(key: String, value: CountryValue)])
    case failure(CountryError)
}

enum CitiesResult {
    case success(City)
    case failure(CityError)
}

struct TrvlrAPI {
    
    private static let continentUrl = URL(string: "https://api.myjson.com/bins/lylg0")
    private static let countryUrl = URL(string: "https://api.myjson.com/bins/qty0s")
    private static let cityUrl = URL(string: "https://api.myjson.com/bins/12i970")
    
    static func fetchContinents(completion: @escaping (ContinentsResult) -> Void) {
        guard let downloadURL = continentUrl else { return }
        // its a continuous process -> resume to finish and return the url
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                completion(.failure(.continentJsonError))
                return
            }
            print("downloaded continents")
            do {
                let decoder = JSONDecoder()
                let continents = try decoder.decode(Continent.self, from: data)
                completion(.success(continents))
            } catch {
                completion(.failure(.continentDecodeError))
            }
        }.resume()
    }
    
    static func fetchCountries(byContinent continent: String, completion: @escaping (CountriesResult) -> Void) {
        guard let downloadURL = countryUrl else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                completion(.failure(.countryJsonError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let countries = try decoder.decode(Country.self, from: data)
                let filteredCountries = countries.filter { $0.value.continent.rawValue == continent }
                let sortedCountries = filteredCountries.sorted(by: { $0.value.name < $1.value.name })
                
                completion(.success(sortedCountries))
                print("downloaded countries")
            } catch {
                print(error)
                completion(.failure(.countryDecodeError))
            }
        }.resume()
    }
    
    static func fetchCities(byCountry country: String, completion: @escaping (CitiesResult) -> Void) {
        guard let downloadURL = cityUrl else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                completion(.failure(.cityJsonError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let cities = try decoder.decode(City.self, from: data)
                let filteredCities = cities.filter { $0.country == country }
                let sortedCities = filteredCities.sorted(by: { $0.name < $1.name })
                completion(.success(sortedCities))
                print("downloaded cities")
            } catch {
                print(error)
                completion(.failure(.cityDecodeError))
            }
        }.resume()
    }
}
