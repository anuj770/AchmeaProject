//
//  Persistence.swift
//  AchmeaDemo
//
//  Created by Anuj Goel on 16/01/2024.
//

import CoreData
import Combine

class Persistence{
  
  static let shared = Persistence()
  
  public static let modelName = "AchmeaDemo"
  
  public static let model: NSManagedObjectModel = {
    // swiftlint:disable force_unwrapping
    let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  // swiftlint:enable force_unwrapping
  
  public init() {
  }
  
  public lazy var mainContext: NSManagedObjectContext = {
    return persistentContainer.viewContext
  }()
  
  public lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: Persistence.modelName, managedObjectModel: Persistence.model)
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext(context:NSManagedObjectContext){
    context.performAndWait{
      do{
        try context.save()
        print("Records saved in local DB")
        
      }catch{
        print(error.localizedDescription)
      }
    }
  }
}

extension Persistence {
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
