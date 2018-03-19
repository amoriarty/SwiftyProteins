//
//  SCNVMatrix4.swift
//  SwiftyProteins
//
//  Created by Émilie Legent on 19/03/2018.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import Foundation
import SceneKit

extension SCNMatrix4 {
    init(x: SCNVector3, y: SCNVector3, z: SCNVector3, w: SCNVector3) {
        self.init(
            m11: x.x,
            m12: x.y,
            m13: x.z,
            m14: 0,
            m21: y.x,
            m22: y.y,
            m23: y.z,
            m24: 0,
            m31: z.x,
            m32: z.y,
            m33: z.z,
            m34: 0,
            m41: w.x,
            m42: w.y,
            m43: w.z,
            m44: 0
        )
    }
    
    static func *(_ left: SCNMatrix4, _ right: SCNMatrix4) -> SCNMatrix4 {
        return SCNMatrix4Mult(left, right)
    }
}
