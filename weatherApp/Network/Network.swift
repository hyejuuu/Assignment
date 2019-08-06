//
//  Network.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation

let baseURL = "https://api.openweathermap.org"

class NetworkImp: Network {
    let session = URLSession.shared
    
    func dispatch(request: URLRequest,
                  completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
