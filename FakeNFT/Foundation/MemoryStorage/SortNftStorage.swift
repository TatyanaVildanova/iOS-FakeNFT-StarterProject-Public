//
//  SortNftStorage.swift
//  FakeNFT
//
//  Created by Эмилия on 19.02.2024.
//

import Foundation

//MARK: - Sort
enum Sort: String {
    case byName
    case byCount
}

//MARK: - SortNftProtocol
protocol SortNftProtocol {
    func saveSort(_ type: Sort)
    func getSort() -> Sort
}

//MARK: - SortNftStorage
final class SortNftStorage: SortNftProtocol {
    
    //MARK: - Private properties
    private let sortKey = "sort"
    private let userDefaults = UserDefaults.standard
    
    //MARK: - Public methods
    func saveSort(_ type: Sort){
        userDefaults.set(type.rawValue, forKey: sortKey)
    }
    
    func getSort()-> Sort {
        guard let value = userDefaults.value(forKey: sortKey) as? String else { return Sort.byCount }
        return Sort(rawValue: value) ?? Sort.byCount
    }
}
