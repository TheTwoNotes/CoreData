//
//  AppDelegate.swift
//  CoreDataFun
//
//  Created by Gil Estes on 7/23/20.
//  Copyright © 2020 Cal30. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataFun")
		
		guard let description = container.persistentStoreDescriptions.first else {
			fatalError("No descriptions found.")
		}
		description.setOption(true as NSObject, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
		
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
		
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.processUpdate), name: .NSPersistentStoreRemoteChange, object: nil)
		
        return container
    }()
	
    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
	
	@objc func processUpdate(notification: NSNotification) {
		operationQueue.addOperation {
			// get our content
			let context = self.persistentContainer.newBackgroundContext()
			context.performAndWait {
				// get list items out of store
				
				// reorder items
				
				// save if we need to save
			}
		}
	}
	
	// Prevents race conditions
	lazy var operationQueue: OperationQueue = {
		var queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		return queue
	}()
}
