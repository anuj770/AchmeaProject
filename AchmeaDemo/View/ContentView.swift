//
//  ContentView.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import SwiftUI

struct ContentView: View {
 
  @ObservedObject var viewModel: EmployerVM

  var body: some View {
    VStack {
      HStack{
        TextField("Enter employer name", text: $viewModel.query)
          .padding()
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button("Search") {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          if viewModel.query != "" {
            viewModel.searchEmployers(withQuery: viewModel.query)
          }
        }
      }
      
      if viewModel.isLoading {
        ProgressView("Loading...")
      }
      
      if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
      }
      
      List(viewModel.employers) { employer in
        EmployerRowView(employer: employer)
      }
      .listStyle(.plain)
    }
    .padding()
  }
}

#Preview {
  ContentView(viewModel: .init(apiService: APIService(), employerRepository: CDEmployerRepository()))
}
