//
//  THJavascriptRunner.swift
//  TangoHapps
//
//  Created by Juan Haladjian on 30/06/15.
//  Copyright (c) 2015 Technische Universität München. All rights reserved.
//

import UIKit
import JavaScriptCore

protocol Debugger{
    
    func addDebugInfo(code: String );
}

class THJavascriptRunner: NSObject {
    var context: JSContext!
    var debugDelegate : Debugger?
    static let sharedInstance = THJavascriptRunner()
    
    override init(){
        super.init()
        self.context = JSContext()
        self.addFunctionsToJSContext()
    }
    
    func execute(code: String ) -> JSValue?{
        
        
        var result = self.context.evaluateScript(code)
        
        /*
        var codeWithoutWhitespaceAndNewline = code.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if codeWithoutWhitespaceAndNewline.hasSuffix(";")
        {
            var fullCode: String = codeWithoutWhitespaceAndNewline
            
            let lastCodeArray = fullCode.componentsSeparatedByString(";")
            println(lastCodeArray)
            
            if(lastCodeArray.count > 1) {
                var lastCode: String = lastCodeArray[lastCodeArray.count - 2]
                
                var result = self.context.evaluateScript(lastCode)
                
                println(result)//remove
                
                if(!result.toString().hasPrefix("undefined")) {
                    var debugText = result.toString() + "\n";
                    self.debugDelegate!.addDebugInfo(debugText);
                }
                
                return result;
            }
        }
        return nil;*/
        return result
    }
    
    func addFunctionsToJSContext()
    {
        self.context.exceptionHandler = { context, exception in
            println("JS Error: \(exception)")
        }
        
        // export JS class
        self.context.setObject(LowPassFilter.self, forKeyedSubscript: "LowPassFilter")
        self.context.setObject(RCFilter.self, forKeyedSubscript: "RCFilter")
        self.context.setObject(PeakDetection.self, forKeyedSubscript: "PeakDetection")
    }

}
