//
//  NetworkProtocol.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation

protocol Network {
    func dispatch(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}
