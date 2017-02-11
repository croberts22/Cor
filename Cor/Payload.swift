//
//  Payload.swift
//  Cor
//
//  Created by Corey Roberts on 2/9/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation
import UIKit


/// A protocol that defines the content of a message.
public protocol Payload {
    
    var identifier: String { get }
}


/// A protocol that defines a set of view behaviors.
public protocol Displayable {
    
    func prepare()
    func display()
    func dismiss()
    
}

// A protocol your views should conform to so that they may use your payloads
public protocol Configurable {
    
    func configure(withPayload payload: Payload)
}

public final class CorEasyPayload: Payload {
    
    public let identifier: String
    public let title: String
    public let description: String?
    public let image: UIImage?
    
    init(identifier: String, title: String, description: String?, image: UIImage?) {
        self.identifier = identifier
        self.title = title
        self.description = description
        self.image = image
    }
}
