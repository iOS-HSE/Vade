//
//  CoreDataStack.swift
//  Vade
//
//  Created by Egor on 19.12.2020.
//

import CoreData

class CoreDataStack {
  
  static let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreModels")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  static var context: NSManagedObjectContext { return persistentContainer.viewContext }
  
  class func saveContext () {
    let context = persistentContainer.viewContext
    
    guard context.hasChanges else {
      return
    }
    
    do {
      try context.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
