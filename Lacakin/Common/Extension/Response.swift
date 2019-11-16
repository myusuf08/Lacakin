//
//  Response.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 07/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import Moya

public extension Response {

    func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: try getJsonDataObject(path))
        } catch {
            if error is LacakinError {
                throw error
            } else {
                throw MoyaError.jsonMapping(self)
            }
        }
    }
    
    func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) throws -> [T] {
        do {
            return try JSONDecoder().decode([T].self, from: try getJsonDataArray(path))
        } catch {
            if error is LacakinError {
                throw error
            } else {
                throw MoyaError.jsonMapping(self)
            }
        }
    }
    
    private func getJsonDataArray(_ path: String? = nil) throws -> Data {
        do {
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {
                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                jsonObject = specificObject as AnyObject
            }
            // filter successfull status code
            guard (200...299 as ClosedRange<Int>).contains(self.statusCode) else {
                throw LacakinError(code: self.statusCode, description: jsonObject["message"] as? String)
            }
            
            let jsonResult = jsonObject["gtfwResult"] as Any
            return try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
        } catch {
            if error is LacakinError {
                throw error
            } else {
                throw MoyaError.jsonMapping(self)
            }
        }
    }
    
    private func getJsonDataObject(_ path: String? = nil) throws -> Data {
        do {
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if let path = path {
                guard let specificObject = jsonObject.value(forKeyPath: path) else {
                    throw MoyaError.jsonMapping(self)
                }
                jsonObject = specificObject as AnyObject
            }
            // filter successfull status code
            guard (200...299 as ClosedRange<Int>).contains(self.statusCode) else {
                throw LacakinError(code: self.statusCode, description: jsonObject["message"] as? String)
            }
            let jsonResult = jsonObject["gtfwResult"] as Any
            return try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
        } catch {
            if error is LacakinError {
                throw error
            } else {
                throw MoyaError.jsonMapping(self)
            }
        }
    }
}
