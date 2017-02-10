//
//  Cor.swift
//  Cor
//
//  Created by Corey Roberts on 2/9/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation


/// A class that manages a list of items to display.
/// You should retain an instance of this in order to keep state
/// of the messages you want to display. A singleton is deliberately
/// not provided.
final class Cor {
    
    private var queue: [Payload] = [Payload]()
    
    init() {
        
    }
    
    func add(item: Payload) {
        queue.append(item)
    }
    
}
