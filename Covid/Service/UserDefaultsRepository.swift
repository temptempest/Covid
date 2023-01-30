//
//  UserDefaultsRepository.swift
//  Covid
//
//  Created by temptempest on 17.12.2022.
//

import Foundation

protocol IUserDefaultsRepository {
    var isOnboardingCompleteBefore: Bool { get }
    func setOnboardingComplete()
    func getMyCountry(completion: @escaping (Result<Country, Error>) -> Void)
    func setMyCountry(_ country: Country)
}

struct UserDefaultsRepository: IUserDefaultsRepository {
    private let container: UserDefaults
    
    init(container: UserDefaults) {
        self.container = container
    }
    
    var isOnboardingCompleteBefore: Bool {
        return container.bool(forKey: UserDefaultsKey.onboardingComplete)
    }
    
    var isSetMyCountry: Bool {
        return container.value(forKey: UserDefaultsKey.myCountry).debugDescription.isEmpty
    }
    
    func setOnboardingComplete() {
        container.set(true, forKey: UserDefaultsKey.onboardingComplete)
    }
    
    func getMyCountry(completion: @escaping (Result<Country, Error>) -> Void) {
        if let data = container.data(forKey: UserDefaultsKey.myCountry) {
            do {
                let country = try data.decoded() as Country
                completion(.success(country))
            } catch {
                Log.error("Unable to Decode Note", error)
                completion(.failure(error))
            }
        } else {
            completion(.success(Country(country: "", slug: "", iso2: "")))
        }
    }
    func setMyCountry(_ country: Country) {
        do {
            let data = try country.encoded()
            container.set(data, forKey: UserDefaultsKey.myCountry)
        } catch {
            Log.error("Unable to Encode Note", error)
        }
    }
}
