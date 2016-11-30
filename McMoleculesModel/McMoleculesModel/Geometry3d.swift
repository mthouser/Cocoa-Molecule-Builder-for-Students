//
//  Geometry3d.swift
//  molecule_model
//
//  Created by Matt Houser on 12/15/15.
//  Copyright © 2015 Matt Houser. All rights reserved.
//

import Foundation
import SceneKit
import GLKit

public typealias ChemVector3 = GLKVector3
public typealias ChemRotationVector = GLKQuaternion

public extension SCNVector3 {
    init (_ v: GLKVector3) {
        self.init(x: CGFloat(v.x), y: CGFloat(v.y), z: CGFloat(v.z))
    }
}

public func ChemVector3Make(_ x: Float, _ y: Float, _ z: Float) -> ChemVector3 {
    return GLKVector3Make(x,y,z)
}

public extension GLKVector3 {
    public func length() -> Float {
        return GLKVector3Length(self)
    }
    public func cross(_ v: GLKVector3) -> GLKVector3 {
        return GLKVector3CrossProduct(self, v)
    }
    public func normalize() -> GLKVector3 {
        if (self.length() == 0) {
            return self
        } else {
            return GLKVector3Normalize(self)
        }
    }
    public func dot(_ v: GLKVector3) -> Float {
        return GLKVector3DotProduct(self, v)
    }

    func toString() -> String {
        return "(\(x), \(y), \(z))"
    }
}
public func - (lhs: GLKVector3, rhs: GLKVector3) -> GLKVector3 {
    return GLKVector3Subtract(lhs, rhs)
}
public func + (lhs: GLKVector3, rhs: GLKVector3) -> GLKVector3 {
    return GLKVector3Add(lhs, rhs)
}
public func / (lhs: GLKVector3, rhs: Float) -> GLKVector3 {
    return GLKVector3DivideScalar(lhs, rhs)
}
public func == (lhs: GLKVector3, rhs: GLKVector3) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

//========================================
//  ChemVector4

public extension ChemRotationVector {
    public static func rotateVector(vectorToRotate v: ChemVector3, vectorToAlign v2: ChemVector3, ontoVector v1: ChemVector3) -> ChemVector3 {
        let q : GLKQuaternion
        if (GLKVector3MultiplyScalar(v1, -1) == v2) {
            //todo : This is a kludge and only correct with v1 and v2 are both along the Y axis
            q = GLKQuaternionMakeWithAngleAndVector3Axis(Float(M_PI), ChemVector3Make(1,0,0))
        } else {
            q = rotationVector(toAlignVector: v2, toVector: v1)
        }
        return GLKQuaternionRotateVector3(q, v)
    }
    
    public static func rotationVector(toAlignVector _v1: ChemVector3, toVector _v2: ChemVector3) -> ChemRotationVector {
        let v1 = _v1.normalize()
        let v2 = _v2.normalize()
        if (v1 == v2) {
            return GLKQuaternionMakeWithAngleAndVector3Axis(Float(0), v2)
        }
        let axisOfRotation = _v1.cross(_v2).normalize()
        let angleOfRotation : Float = acos(v1.dot(v2))
        return GLKQuaternionMakeWithAngleAndVector3Axis(angleOfRotation, axisOfRotation)
    }
}

public func ChemRotationVectorMake(_ x: Float, _ y: Float, _ z: Float, _ w: Float) -> ChemRotationVector {
    return GLKQuaternionMake(x, y, z, w)
}

public extension SCNVector4 {
    init (_ q: GLKQuaternion) {
        let qVector = GLKQuaternionAxis(q)
        let qAngle = GLKQuaternionAngle(q)
        self.init(x: CGFloat(qVector.x), y: CGFloat(qVector.y), z: CGFloat(qVector.z), w: CGFloat(qAngle))
    }
}
