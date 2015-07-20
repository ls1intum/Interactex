//
//  PeakDetection.swift
//  text-it
//
//  Created by Mertcan Yigin on 7/2/15.
//  Copyright (c) 2015 Mertcan Yigin. All rights reserved.
//

import Cocoa

class PeakDetection: NSObject {
    
    //%PEAKDET Detect peaks in a vector
    //      [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
    //       maxima and minima ("peaks") in the vector V.
    //       MAXTAB and MINTAB consists of two columns. Column 1
    //       contains indices in V, and column 2 the found values.
    //        With [MAXTAB, MINTAB] = PEAKDET(V, DELTA, X) the indices
    //       in MAXTAB and MINTAB are replaced with the corresponding
    //        X-values.
    //
    //       A point is considered a maximum peak if it has the maximal
    //       value, and was preceded (to the left) by a value lower by
    //       DELTA.
    //      Eli Billauer, 3.4.05 (Explicitly not copyrighted).
    //      This function is released to the public domain; Any use is allowed.
    
    var maxtab: [CGFloat]
    var mintab: [CGFloat]

    override init() {
        maxtab = []
        mintab = []
        
        super.init()
    }
    
    func detectPeaks(arrayData:[CGFloat], peakThreshold:CGFloat )
    {
        maxtab = []
        mintab = []
        
        if(peakThreshold <= 0)
        {
            return
        }
        var minimum = CGFloat.max
        var maximum = CGFloat.min
        var mnpos = 0
        var mxpos = 0
        var lookformax = true
        
        
        for var index = 0; index < arrayData.count; ++index {
            var current = arrayData[index]
            
            if (current > maximum)
            {
                maximum = current
            }
            
            if (current < minimum)
            {
                minimum = current
            }
            
            
            if (lookformax)
            {
                if(current < maximum - peakThreshold)
                {
                    maxtab.append(maximum)
                    minimum = current
                    lookformax = false
                }
            }
            else
            {
                if(current > minimum + peakThreshold)
                {
                    mintab.append(minimum)
                    minimum = current
                    lookformax = true
                }
            }
        }
        println(maxtab)
    }
}