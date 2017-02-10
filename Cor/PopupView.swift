//
//  PopupView.swift
//  Cor
//
//  Created by Corey Roberts on 2/9/17.
//  Copyright © 2017 SpacePyro Inc. All rights reserved.
//

import Foundation

/// A banner-esque view that pops up near the lower 
/// end of the device.
final class PopupView: UIView {
    
    let payload: Payload
    
    init(payload: Payload) {
        self.payload = payload
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
