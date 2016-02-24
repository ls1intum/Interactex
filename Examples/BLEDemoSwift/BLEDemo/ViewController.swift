//
//  ViewController.swift
//  BLEDemo
//
//  Created by Juan Haladjian on 19/02/16.
//  Copyright © 2016 TUM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLEDiscoveryDelegate, BLEServiceDataDelegate, BLEServiceDelegate {

    var discovery: BLEDiscovery = BLEDiscovery()
    var service : BLEService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        discovery.discoveryDelegate = self;
        discovery.peripheralDelegate = self;
        
        //discovery.startScanningForAnyUUID() //1. scan for devices nearby. alternative: startScanningForSupportedUUIDs(). List of supported UUIDs is found at top of BLEService.m file. Variabl: kSupportedServiceUUIDs
        discovery.startScanningForSupportedUUIDs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func peripheralDiscovered(peripheral: CBPeripheral) { //2. a device narby is found
        print(peripheral)
        
        if(discovery.connectedService == nil){
            discovery.connectPeripheral(peripheral) //3. we try to connect to it
        }
    }
    
    func discoveryDidRefresh(){
        
    }
    
    func discoveryStatePoweredOff(){
        
    }
    
    func didReceiveData(buffer: UnsafeMutablePointer<UInt8>, length : NSInteger){ //6. we can receive data from the device
        
        var text = ""
        for var i = 0 ; i < length; i++ {
            let value = buffer[i];
            text = text.stringByAppendingFormat("%d ",value);
        }
        print("%@",text);
        
    }
    
    func  sendData(){
        let data: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.alloc(3)
        data[0] = 0xF0
        data[1] = 0x79
        data[2] = 0xF7
        service?.sendData(data, count: 3);
    }
    
    func bleServiceDidConnect(service: BLEService){//4. we connected to the device
        service.delegate = self;
        service.dataDelegate = self;
        self.service = service
    }
    
    func bleServiceDidDisconnect(service: BLEService){

    }
    
    func bleServiceIsReady(service: BLEService){
    
    }
    
    func bleServiceDidReset(){
    }
    
    func reportMessage(message: String){
    }
    
    @IBAction func sendDataTapped(sender: AnyObject) {
        self.sendData()
    }
    
    @IBAction func connectTapped(sender: AnyObject) {
          discovery.startScanningForSupportedUUIDs()
    }
}

