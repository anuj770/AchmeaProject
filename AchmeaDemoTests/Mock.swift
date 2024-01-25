//
//  Mock.swift
//  AchmeaDemoTests
//
//  Created by Anuj Goel on 25/01/2024.
//

import Foundation
import Combine
@testable import AchmeaDemo

let mockEmployers: [Employer] = [
  Employer(
    discountPercentage: 5,
    employerID: 12,
    name: "Test Employer 1",
    place: "ZWOLLE"
  ),
  Employer(
    discountPercentage: 6,
    employerID: 13,
    name: "Test Employer 2",
    place: "AMSTERDAM"
  )
]

//class MockAPIService: APIServiceType {
//  var responsePublisher: AnyPublisher<[Employer], Error>?
//  
//  func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: APIRequestType {
//    return responsePublisher! as! AnyPublisher<Request.Response, Error>
//  }
//}

final class MockAPIService: APIServiceType {
    var stubs: [Any] = []
    
    func stub<Request>(for type: Request.Type, response: @escaping ((Request) -> AnyPublisher<Request.Response, Error>)) where Request: APIRequestType {
        stubs.append(response)
    }
    
  func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: AchmeaDemo.APIRequestType {
        
        let response = stubs.compactMap { stub -> AnyPublisher<Request.Response, Error>? in
            let stub = stub as? ((Request) -> AnyPublisher<Request.Response, Error>)
            return stub?(request)
        }.last
        
        return response ?? Empty<Request.Response, Error>()
            .eraseToAnyPublisher()
    }
}

class MockCDRepository: CDRepository {
  var fetchEmployersResult: [AchmeaDemo.Employer] = []
  var createRecordsCalled = false
  var deleteEmployersCalled = false
  
  func fetchEmployers(forQuery query: String, time: Date?) -> [AchmeaDemo.Employer] {
    return fetchEmployersResult
  }
  
  func createRecords(record: EmployersData) {
    createRecordsCalled = true
  }
  
  func deleteEmployers(withQuery query: String) {
    deleteEmployersCalled = true
  }
}
