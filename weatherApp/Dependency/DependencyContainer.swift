//
//  DependencyContainer.swift
//  weatherApp
//
//  Created by 이혜주 on 02/08/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import Foundation

class DependencyContainer {
    private let dependencyPool = DependencyPool()
    
    public static let shared: DependencyContainer = DependencyContainer()
    
    private init() {
        let weatherService: WeatherService =
            WeatherServiceImp(requestMaker: RequestMakerImp(),
                              network: NetworkImp())
        
        do {
            try dependencyPool.register(key: .weatherService,
                                        dependency: weatherService)
        } catch {
            fatalError("register Fail")
        }
    }
    
    public func getDependency<T>(key: DependencyKey) -> T {
        do {
            return try dependencyPool.pullOutDependency(key: key)
        } catch DependencyError.keyAlreadyExistsError {
            fatalError("keyAlreadyExistError")
        } catch DependencyError.unregisteredKeyError {
            fatalError("unregisteredKeyError")
        } catch DependencyError.downcastingFailureError {
            fatalError("downcastingFailureError")
        } catch {
            fatalError("getDependency Fail")
        }
    }
}

enum DependencyKey {
    case weatherService
}
