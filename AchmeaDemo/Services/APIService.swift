//
//  APIService.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import Foundation
import Combine

protocol APIRequestType {
  associatedtype Response: Codable
  
  var path: String { get }
  var queryItems: [URLQueryItem]? { get }
}

protocol APIServiceType {
  func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: APIRequestType
}

final class APIService: APIServiceType {
  
  private let baseURL: URL
  init(baseURL: URL = URL(string: "https://cba.kooijmans.nl")!) {
    self.baseURL = baseURL
  }
  
  func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: APIRequestType {
    
    let pathURL = URL(string: request.path, relativeTo: baseURL)!
    
    var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
    urlComponents.queryItems = request.queryItems
    var request = URLRequest(url: urlComponents.url!)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let decorder = JSONDecoder()
    decorder.keyDecodingStrategy = .convertFromSnakeCase
    return URLSession.shared.dataTaskPublisher(for: request)
      .map { data, urlResponse in data }
      .mapError { _ in APIServiceError.responseError }
      .decode(type: Request.Response.self, decoder: decorder)
      .mapError(APIServiceError.parseError)
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

enum APIServiceError: Error {
  case responseError
  case parseError(Error)
}

struct SearchEmployerRequest: APIRequestType {
  typealias Response = [Employer]
  
  var path: String { return "/CBAEmployerservice.svc/rest/employers" }
  var queryItems: [URLQueryItem]?
  
  init(query: String, maxRows : String = "100") {
    queryItems =  [
      .init(name: "filter", value: query),
      .init(name: "maxRows", value: maxRows)
    ]
  }
}
