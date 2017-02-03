//
//  LLCoreDataDataSource.swift
//  TimeSinceLast
//
//  Created by Will Chilcutt on 1/6/17.
//  Copyright © 2017 Laoba Labs. All rights reserved.
//

import UIKit
import CoreData

class LLCoreDataDataSource: NSObject
{
    let persistentContainer : NSPersistentContainer
    
    required init(withPersistentContainer givenPersistentContainer : NSPersistentContainer)
    {
        persistentContainer = givenPersistentContainer
    }
    
    func getObjectsForClass(withName className : String) -> [Any]?
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: className)
        
        var objectsArray : [Any]?
        
        do
        {
            objectsArray = try persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch let error
        {
            print("Error getting objects: \(error)")
        }
        
        return objectsArray
    }
    
    func createNewObject(withClassName className : String) -> NSManagedObject
    {
        return NSEntityDescription.insertNewObject(forEntityName: className,
                                                   into: persistentContainer.viewContext)
    }
    
    //MARK: - Delete objects
    
    func delete(object : NSManagedObject) -> Error?
    {
        persistentContainer.viewContext.delete(object)
        
        return self.saveChanges()
    }
    
    func saveChanges() -> Error?
    {
        do
        {
            try persistentContainer.viewContext.save()
        }
        catch let error
        {
            return error
        }
        
        return nil
    }
}
