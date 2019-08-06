//
//  UserDefaults.swift
//  weatherApp
//
//  Created by 이혜주 on 07/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation
import CoreLocation

extension UserDefaults {
    func set<T: Codable>(values: [T], forKey: String) throws {
        var data: [Data] = []
        
        for value in values {
            do {
                try data.append(JSONEncoder().encode(value))
            } catch let error {
                throw error
            }
        }

        set(data, forKey: forKey)
     
    }
    
    func object<T>(type: T.Type, forKey: String) throws -> [T] where T: Decodable {
        guard let encodedData = array(forKey: forKey) as? [Data] else {
            return []
        }
        
        var decodedData: [T] = []
        
        for data in encodedData {
            do {
                try decodedData.append(JSONDecoder().decode(type, from: data))
            } catch let error {
                throw error
            }
        }
        
        return decodedData
    }
}
