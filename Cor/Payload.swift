//
//  Payload.swift
//  Cor
//
//  Created by Corey Roberts on 2/9/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation


/// A protocol that defines the content of a message.
protocol Payload {
    
    var title: String { get }
    var description: String? { get }
    var image: UIImage? { get }
    
}


/// A protocol that defines a set of view behaviors.
protocol Displayable {
    
    func prepare()
    func display()
    func dismiss()
    
}


/// A struct that contains the content of a message.
struct Item: Payload {
    
    let title: String
    var description: String?
    var image: UIImage?
    
    init(title: String, description: String?, image: UIImage?) {
        self.title = title
        self.description = description
        self.image = image
    }
    
}
