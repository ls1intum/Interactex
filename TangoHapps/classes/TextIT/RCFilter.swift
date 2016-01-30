//
//  RCFilter.swift
//  text-it
//
//  Created by Mertcan Yigin on 6/9/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import JavaScriptCore

// Custom protocol must be declared with `@objc`
@objc
protocol RCFilterJSExports : JSExport {
    func filter(accData:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    func test(acc:[CGFloat],_ asd:Int) -> [CGFloat]
    static func new() -> RCFilter
}

// Custom class must inherit from `NSObject`
@objc(RCFilter)
class RCFilter: Component,RCFilterJSExports  {
    
    override static func new() -> RCFilter {
        return RCFilter()
    }
    
    func test(acc:[CGFloat],_ asd:Int) -> [CGFloat]
    {
        print("success!")
        return acc
    }
    
    func filter(accData:[CGFloat],_ kFilteringFactor:CGFloat,_ frequency: CGFloat) -> [CGFloat]
    {
        var cgFloatArray: [CGFloat] = []

        var index: Int
        for index = 1; index < accData.count-1; ++index {
            cgFloatArray.append((accData[index-1] / 4) + (accData[index] / 2) + (accData[index+1] / 4))
        }
        return cgFloatArray
    }
}