//
//  CollisionCategory.swift
//  BubbleStrike
//
//  Created by David Rynn on 2/15/24.
//

struct CollisionCategory : OptionSet {
    let rawValue: UInt32

    static let bubbleA  = CollisionCategory(rawValue: 1 << 0)
    static let bubbleB = CollisionCategory(rawValue: 1 << 1)
    static let ground = CollisionCategory(rawValue: 1 << 3)
    static let side = CollisionCategory(rawValue: 1 << 4)
    static let ceiling = CollisionCategory(rawValue: 1 << 5)
}
