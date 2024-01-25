//
//  EmployerVMTestCase.swift
//  AchmeaDemoTests
//
//  Created by Anuj Goel on 25/01/2024.
//

import XCTest

import XCTest
import Combine
import SwiftUI
@testable import AchmeaDemo

final class EmployerVMTestCase: XCTestCase {
  
  private var employerVM: EmployerVM!
  private var apiServiceMock: MockAPIService!
  private var employerRepositoryMock: MockCDRepository!
  
  override func setUp() {
    super.setUp()
    apiServiceMock = MockAPIService()
    employerRepositoryMock = MockCDRepository()
    employerVM = EmployerVM(apiService: apiServiceMock, employerRepository: employerRepositoryMock)
  }
  
  override func tearDown() {
    employerVM = nil
    apiServiceMock = nil
    employerRepositoryMock = nil
    super.tearDown()
  }
  
  
  func test_getEmployer() {
    
    // Create a stub for SearchEmployerRequest
    let searchEmployerStub: (SearchEmployerRequest) -> AnyPublisher<[Employer], Error> = { request in
      // You can customize the stubbed response based on your test scenario
      return Just(mockEmployers)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    apiServiceMock.stub(for: SearchEmployerRequest.self, response: searchEmployerStub)
    
    employerVM.searchEmployers(withQuery: "Test Employer 1")
    XCTAssertTrue(!employerVM.employers.isEmpty)
  }
  
  
  func test_ErrorMessage() {
    
    // Create a stub for SearchEmployerRequest
    
    let searchEmployerFailedStub: (SearchEmployerRequest) -> AnyPublisher<[Employer], Error> = { request in
      // You can customize the stubbed failure based on your test scenario
      let error = NSError(domain: "com.example", code: 42, userInfo: nil)
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
    
    // Add the failed stub to the mock service
    apiServiceMock.stub(for: SearchEmployerRequest.self, response: searchEmployerFailedStub)
    
    employerVM.searchEmployers(withQuery: "Test Employer 1")
    XCTAssertTrue(employerVM.errorMessage != nil)
  }
  
  func testGetEmployerFromRepository() {
    // Stub the repository to return some data
    employerRepositoryMock.fetchEmployersResult = mockEmployers
    
    employerVM.searchEmployers(withQuery: "Test Employer 1")
    XCTAssertEqual(employerVM.employers, mockEmployers)
     XCTAssertNil(employerVM.errorMessage)
  }
  
  
}


