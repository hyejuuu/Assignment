//
//  RequestMakerProtocol.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation

protocol RequestMaker {
    func makeRequest(url: URL,
                     method: HTTPMethod,
                     header: [String : String]?,
                     body: Data?) -> URLRequest?
}
