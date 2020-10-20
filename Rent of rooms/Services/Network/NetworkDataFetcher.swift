//
//  NetworkDataFetcher.swift
//  Rent of rooms
//
//  Created by Administrator on 10.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    var networkService: Networking!
    
    init(networkService: Networking = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?) -> Void) {
        networkService.request(urlString: urlString) { (data, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let response = try? decoder.decode(T.self, from: data)
            completion(response)
        }
    }
}
