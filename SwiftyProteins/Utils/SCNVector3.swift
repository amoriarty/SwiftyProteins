//
//  SCNVector3.swift
//  SwiftyProteins
//
//  Created by Émilie Legent on 19/03/2018.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    var lenght: Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    /* Normalizes vector to lenght 1 */
    var normalized: SCNVector3 {
        return self / lenght
    }
    
    /* Calculate distance between two vector */
    func distance(from vector: SCNVector3) -> CGFloat {
        let left = SCNVector3ToGLKVector3(self)
        let right = SCNVector3ToGLKVector3(vector)
        return CGFloat(GLKVector3Distance(left, right))
    }
    
    func cross(_ vector: SCNVector3) -> SCNVector3 {
        return SCNVector3(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
    }
    
    // MARK:- Operator overloads
    static func +(_ left: SCNVector3, _ right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func -(_ left: SCNVector3, _ right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func /(_ vector: SCNVector3, _ scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
}

