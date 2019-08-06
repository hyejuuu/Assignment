//
//  RequestMaker.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation

class RequestMakerImp: RequestMaker {
    func makeRequest(url: URL,
                     method: HTTPMethod,
                     header: [String : String]?,
                     body: Data?) -> URLRequest? {
        var request = URLRequest(url: url)
        
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
}
