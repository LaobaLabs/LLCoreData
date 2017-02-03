//
//  LLCoreDataManager.swift
//  TimeSinceLast
//
//  Created by Will Chilcutt on 1/6/17.
//  Copyright © 2017 Laoba Labs. All rights reserved.
//

import UIKit
import CoreData

class LLCoreDataManager: NSObject
{
    static let sharedInstance = LLCoreDataManager()
    var persistentContainer : NSPersistentContainer?

    //Customizable per app
    var persistentContainerName : String?
    var dataSourceClass : LLCoreDataDataSource.Type?
    
    func createDataSource() -> LLCoreDataDataSource?
    {
        if  let dsClass = dataSourceClass,
            let persistentContainer = self.getPeristentContainer()
        {
            let dataSource = dsClass.init(withPersistentContainer:persistentContainer)
            
            return dataSource
        }
        else
        {
            assert(dataSourceClass == nil, "Datasource cass nil!")
            
            assert(self.getPeristentContainer() == nil, "Persistent Container nil!!!")
            
            return nil
        }
    }
    
    private func getPeristentContainer() -> NSPersistentContainer?
    {
        if persistentContainer != nil
        {
            return persistentContainer!
        }
        else
        {
            if let containerName = persistentContainerName
            {
                let semaphore = DispatchSemaphore(value: 0)
                
                let container = NSPersistentContainer(name: containerName)
                container.loadPersistentStores(completionHandler:
                    { (storeDescription, error) in
                        
                        if let error = error as NSError?
                        {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            
                            /*
                             Typical reasons for an error here include:
                             * The parent directory does not exist, cannot be created, or disallows writing.
                             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                             * The device is out of space.
                             * The store could not be migrated to the current model version.
                             Check the error message to determine what the actual problem was.
                             */
                            fatalError("Unresolved error \(error), \(error.userInfo)")
                        }
                        
                        semaphore.signal()
                })
                
                let _ = semaphore.wait(timeout: .distantFuture)
                
                persistentContainer = container
                
                return persistentContainer!
            }
            else
            {
                assert(persistentContainerName == nil, "Persistent Container name nil!!!")

                return nil
            }
        }
    }
    
    // MARK: - Core Data Saving support
    
    func saveChanges ()
    {
        if let context = self.getPeristentContainer()?.viewContext
        {
            if context.hasChanges
            {
                do
                {
                    try context.save()
                }
                catch
                {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
