//
//  Item.swift
//  libraryquery
//
//  Created by José Manuel Gaytán on 24/09/16.
//  Copyright © 2016 José Manuel Gaytán. All rights reserved.
//

import Foundation

class Item: NSObject {
    
    var isbn: String
    var titulo: String?
    let dateCreated: Date
    
    init(isbn: String, titulo: String) {
        self.isbn = isbn
        self.titulo = titulo
        self.dateCreated = Date()
    }
    
    convenience init(opcDefault: Bool = false) {
        if opcDefault {
        
            let defaultIsbn = ""
            let defaultTitulo = "Sin datos"
            
            self.init(isbn: defaultIsbn, titulo: defaultTitulo)
        }
        else {
            self.init(isbn: "", titulo: "")
        }
    }
    
}
