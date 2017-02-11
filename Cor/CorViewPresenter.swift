//
//  CorViewPresenter.swift
//  Cor
//
//  Created by Whittlesey, Skyler on 2/10/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation


// Conform to this protocol if you want to be the presenter of the CorView subclass instead of Cor
// Useful if you wish to do custom animations and other things that are not included out of the box
// Register this using the interface provided in Cor
// You will be passed the relevant data after cor(shouldShowCorView view: CorView, withPayload payload: Payload) -> Bool is called
// You will be passed the delegate registered on Cor
// You are responsible for calling the delegate methods for the view lifecycle if you need them
// Cor will not continue until you call back letting it know you are finished

public protocol CorViewPresenter {
    
    func should(presentCorView view: CorView, withPayload payload: Payload, coreDelegate delegate: CorDelegate?)
}
