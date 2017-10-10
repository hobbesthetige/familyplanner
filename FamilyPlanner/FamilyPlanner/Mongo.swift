//
//  Mongo.swift
//  FamilyPlanner
//
//  Created by Daniel Meachum on 10/10/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import Foundation

public typealias Parameters = [String : CustomStringConvertible]

public typealias MongoCompletionReturn<ReturnClass : MongoCollection> = (ReturnClass)->Void
public typealias MongoErrorReturn = (MongoError)->Void

public protocol MongoCollection : Decodable
{
    var collectionName : String { get }
}

private struct MongoProperties
{
    private let uri = "https://api.mlab.com/api/1"
    private let database = "/databases/familyplanner/collections"
    
    private let apikey = "yzM9dduY9BKw5mWbLAUx5tvg8FEv-gq_"
    
    fileprivate func url(withCollection collectionName : String) -> URL? {
        
        return URL(string: uri)!.appendingPathComponent(database).appendingPathComponent(collectionName, isDirectory: true)
    }
    
    fileprivate var apiKeyQueryItem : URLQueryItem {
        
        return URLQueryItem(name: "apiKey", value: apikey)
    }
}

fileprivate enum MongoQueryType : String
{
    case query = "q", limit = "l", insertIfNotFound = "u"
}


public class Mongo
{
    public func sendRequest<Collection : MongoCollection>(collectionName : String, parameters : Parameters, completionHandler : @escaping MongoCompletionReturn<Collection>, errorHandler : @escaping MongoErrorReturn) {
        
        let urlConstructionResult = createQueryURL(collectionName: collectionName, parameters: parameters, limit: nil, shouldInsertIfNotFound: false)
        
        guard let url = urlConstructionResult.url else {
            
            if let error = urlConstructionResult.error {
                
                errorHandler(error)
            }
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do {
                    let table = try decoder.decode(Collection.self, from: data)
                    
                    completionHandler(table)
                }
                catch (let error) {
                    
                    errorHandler(.responseError(error.localizedDescription))
                }
            }
        }
        
        task.resume()
    }
    
    private func constructJSON(parameters : Parameters) -> (json : String?,error : MongoError?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            let string = String.init(data: data, encoding: .utf8)
            if let encodedString = string {
                return (encodedString, nil)
            } else {
                return (nil, .jsonEncodingError("Cannot encode json string"))
            }
        } catch (let error as NSError) {
            return (nil, .jsonEncodingError(error.localizedDescription))
        }
    }
    
    private func createQueryURL(collectionName : String, parameters : Parameters? = nil, limit : Int? = nil, shouldInsertIfNotFound : Bool = false) -> (url : URL?,error: MongoError?)
    {
        let properties = MongoProperties()
        
        guard let url = properties.url(withCollection: collectionName), var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: false) else {
            
            return (nil, MongoError.urlError("Unable to create base url"))
        }
        
        var queryItems = [properties.apiKeyQueryItem]
        
        if let parameters = parameters
        {
            let jsonConstructionResult = constructJSON(parameters: parameters)
            
            guard let json = jsonConstructionResult.json else {
                
                return (nil, jsonConstructionResult.error)
            }
            
            queryItems.append(URLQueryItem(name: MongoQueryType.query.rawValue, value: json) )
        }
        
        if let limit = limit
        {
            queryItems.append(URLQueryItem(name: MongoQueryType.limit.rawValue, value: String(limit)) )
        }
        
        if shouldInsertIfNotFound
        {
            queryItems.append(URLQueryItem(name: MongoQueryType.insertIfNotFound.rawValue, value: "true") )
        }
        
        urlComponents.queryItems = queryItems
        
        if let url = urlComponents.url {
            return (url, nil)
        } else {
            return (nil, .urlError("URL components cannot be created"))
        }
    }
}
