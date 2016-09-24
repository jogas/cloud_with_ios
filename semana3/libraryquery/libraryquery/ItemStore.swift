//
//  ItemStore.swift
//  libraryquery
//
//  Created by José Manuel Gaytán on 24/09/16.
//  Copyright © 2016 José Manuel Gaytán. All rights reserved.
//

import Foundation

class ItemStore {
    
    var allItems: [Item] = []
    
    func moveItemAtIndex(_ fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can re-insert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.remove(at: fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
    
    func createItem() -> Item {
        let newItem = Item(opcDefault: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
}
