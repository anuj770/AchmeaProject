//
//  EmployerVM.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import Foundation
import SwiftUI
import Combine

class EmployerVM: ObservableObject {
  
  var cancellables: Set<AnyCancellable> = []
  
  @Published var employers: [Employer] = []
  @Published var errorMessage: String?
  @Published var query = ""
  @Published var isLoading: Bool = false
  
  private let apiService: APIServiceType
  private let employerRepository: CDRepository
  
  init(apiService: APIServiceType, employerRepository: CDRepository) {
    self.apiService = apiService
    self.employerRepository = employerRepository
  }
  
  func searchEmployers(withQuery query: String) {
    
    self.isLoading = true
    self.errorMessage = nil
    let request = SearchEmployerRequest(query: query)
    let sevenDaysLater = Date().addingTimeInterval(-7 * 24 * 60 * 60)
    
    let record = self.employerRepository.fetchEmployers(forQuery: query, time: sevenDaysLater)
    if !record.isEmpty {
      self.employers = record
      self.isLoading = false
    }
    else {
      apiService.response(from: request)
        .sink { completion in
          // Handle completion if needed
          switch completion {
          case .finished:
             break
          case .failure(let error):
            // Handle error here
            self.errorMessage = "Error: \(error.localizedDescription)"
            self.isLoading = false
          }
        } receiveValue: { [weak self] employeeResponse in
          self?.employers = employeeResponse
          let item = EmployersData(time: Date(), query: query, employers: employeeResponse)
          self?.employerRepository.deleteEmployers(withQuery: query)
          self?.employerRepository.createRecords(record: item)
          if employeeResponse.count == 0 {self?.errorMessage = "NO data Found"}
          self?.isLoading = false
        }
        .store(in: &cancellables)
    }
  }
}

