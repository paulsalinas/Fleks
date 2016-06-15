//
//  ExerciseTaskDataManager.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-28.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import CoreData


class ExerciseDataManager: NSObject, NSFetchedResultsControllerDelegate {
    var exercises: [Exercise]
    
    private let coreDataStore = CoreDataStore()
    private var fetchedResultsController: NSFetchedResultsController
    
    var delegate: DataManagerDelegate?
    
    override init() {
        let fetchRequest = NSFetchRequest(entityName: "Exercise")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        // fetchRequest.predicate = NSPredicate(forTasksWithinNumberOfDays: 10, ofDate: NSDate())
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStore.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultsController.performFetch()
        
        let managedExercises = fetchedResultsController.fetchedObjects! as! [NSManagedObject]
        
        // resultsCache = UpcomingTaskResultsCache(initialTasksSortedAscendingByDate: managedTasks.map { Task(managedTask: $0) }, baseDate: NSDate())
        exercises = managedExercises.map { Exercise(managedExercise: $0) }
        
        super.init()
        
        fetchedResultsController.delegate = self
    }
    
    func createExercise(name: String, muscles: [Muscle]) {
        let newExercise = NSManagedObject(entity: coreDataStore.managedObjectContext.persistentStoreCoordinator!.managedObjectModel.entitiesByName["Exercise"]!, insertIntoManagedObjectContext: coreDataStore.managedObjectContext)
        newExercise.setValue(NSUUID().UUIDString, forKey: "id")
        newExercise.setValue(name, forKey: "name")
        newExercise.setValue(muscles.map { managedMuscle($0) }, forKey: "muscles")
        try! coreDataStore.managedObjectContext.save()
    }
    
    
    private func managedMuscle(muscle: Muscle) -> NSManagedObject {
        let fetchRequest = NSFetchRequest(entityName: "Muscle")
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [muscle.id])
        fetchRequest.fetchLimit = 1
        let results = try! coreDataStore.managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        return results.first!
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let exercise = Exercise(managedExercise: anObject as! NSManagedObject)
        switch type {
        case .Insert:
            exercises.append(exercise)
            delegate?.dataManager(self, didInsertRowAtIndexPath: NSIndexPath(index: exercises.count))
//        case :
//            let deletedIndexPath = resultsCache.deleteTask(task)
//            delegate?.dataManager(self, didDeleteRowAtIndexPath: deletedIndexPath)
        case .Move, .Update, .Delete:
            fatalError("Unsupported")
        }
    }
    
}

protocol DataManagerDelegate {
    func dataManagerWillChangeContent(dataManager: ExerciseDataManager)
    func dataManagerDidChangeContent(dataManager: ExerciseDataManager)
    func dataManager(dataManager: ExerciseDataManager, didInsertRowAtIndexPath indexPath: NSIndexPath)
    func dataManager(dataManager: ExerciseDataManager, didDeleteRowAtIndexPath indexPath: NSIndexPath)
}
