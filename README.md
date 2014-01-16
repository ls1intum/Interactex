Interactex
==========

Interactex is a toolset to create iPhone and iPod applications that interact with hardware components such as sensors and actuators. Figure below shoes the Architecture of the toolset. 

<p align="center">
  <img src="Documentation/images/1 - interactex.png" alt="Architecture of the Interactex Environment"/>
</p>


The Interactex Designer is initially used in order to visually create a Program. 

<p align="center">
  <img src="Documentation/images/2 - editionMode.png" alt="Main interface Interactex Designer"/>
</p>

The Program is then transferred to the Interactex Client over Bluetooth or WiFi, which runs the program.

<p align="center">
  <img src="Documentation/images/3 - presets.png" height=650 alt="Interactex Client presets screen"/>
</p>

The Interactex Client then communicates with the microcontroller integrated into an eTextile using Bluetooth Low Energy.


<p align="center">
  <img src="Documentation/images/4 - tshirt.png" alt="eTextile"/>
</p>


# Interactex Designer

 Programs in the Interactex Designer are created by Drag and Dropping elements and by drawing connections between them. A Rule Based System built into the Interactex Designer enables users to define behavior: Events of an object are linked to methods of another object. The “Pressed” event of a button can be connected to the “TurnOn” event of an LED. Programs can be simulated on the Designer before uploading them to the Client. More complex programming elements such as conditions and operators make it possible to define more complex behaviors. A Comparator Object can be used together with a Number Value and a Temperature Sensor in order to take an action whenever the temperature reaches a certain value. Such an action can be starting a phone call, playing or stopping music, etc.  The Interactex Designer offers two modes, the Edition mode and the Simulation mode. During the Edition mode, users create an application by drag and dropping elements from a Palette into the Project View. During the simulation mode, users can test and debug the created applications. Both modes are described next with an example. 
 

# Tutorial

This example application will turn on a LED using buttons on the iPhone. In the image below, a button has been added to the iPhone object, a T-Shirt and a LED have been added to the project.

<p align="center">
  <img src="Documentation/images/5 - Demo1.png" alt="eTextile"/>
</p>


In order to make a program that turns on the LED when the button is pressed, both objects need to be connected. In order to connect objects, the connection switch should be activated. The connection switch is found on the bottom-right side of the screen and looks like this: 

<p align="center">
  <img src="Documentation/images/6 - Demo2.png" alt="connection button"/>
</p>


Drawing a line from one object to the other creates a connection between them. When drawing a connection between the button and the LED, a popup will appear. This popup displays events from the source object (the Button) on the left side and matching methods or actions from the target object (the LED) on the right side. 

<p align="center">
  <img src="Documentation/images/7 - Demo3.png" alt="event methods"/>
</p>
 

Selecting the touchDown event to the turnOn method will cause the LED to turn on when the button is pressed.

In order to test this simple application, the Simulation mode can be started by pressing the Play button on the top right side of the screen. While simulating, pressing the button on the iPhone should turn on the LED’s light, as depicted below.

 <p align="center">
  <img src="Documentation/images/8 - Demo4.png" alt="simulation mode"/>
</p>

In order to switch back to Edition mode, the cross on the top-right side of the screen has to be pressed.

Before this can work on the hardware side, the application has to know what board’s pins the LED will be connected to. This can be done on the Hardware View. To enter the hardware view, the button that looks like a Lilypad on the top-right side of the screen has to be pressed.

 <p align="center">
  <img src="Documentation/images/9 - Demo5.png" alt="hardware button"/>
</p>


The – pin of the LED is automatically wired. The + pin can be connected to any valid board’s pin by drawing a line with the finger while the connection switch is activated (in the same way as connections between objects are created).

<p align="center">
  <img src="Documentation/images/10 - Demo6.png" alt="hardware wiring"/>
</p>


After hardware components are wired, if the application still needs to be debugged, the Pins Controller feature can be used. This feature is available during Simulation Mode and can be opened using the button next to the stop button that looks like this:

<p align="center">
  <img src="Documentation/images/11 - Demo7.png" alt="controlling pins"/>
</p>

The Pins Controller displays pin values and allows users to change them in order to observe hardware’s behavior.
 
<p align="center">
  <img src="Documentation/images/12 - Demo8.png" alt="controlling pins 2"/>
</p>

In order to transfer the application to the iPhone (or iPod):
1.	Both devices (iPad and iPhone) need to either be connected to the same network, or have Bluetooth activated. 
2.	In the Interactex Client, choose a + icon to go to the Download mode: 

<p align="center">
  <img src="Documentation/images/13 - Client.png" height=650 alt="Interactex Client download screen"/>
</p>
 

3.	The push button (the last icon in the Designer’s toolbar – an arrow pointing up) becomes enabled in the Designer. After pressing it, the application is transferred to the Client Application.

<p align="center">
  <img src="Documentation/images/14 - editorTools.png" alt="editor tools"/>
</p>

4.	By tapping the Scan button at the top-right side of the screen, the Client Application will scan for nearby Bluetooth 4.0 devices. Once a device is found which implements one of the supported Services (see section Supported Devices), the text “Start” will replace the previous “Scan” text. By pressing the “Start” Button on the top-right side of the screen a connection with the hardware is established and the application starts running. After that, the “Stop” text will replace the “Start” text. When the “Stop” button is pressed, the device disconnects from the hardware. By going back to the projects screen at any time, the device disconnects from the hardware.
 
<p align="center">
  <img src="Documentation/images/15 - Client.png" height=650 alt="controlling pins 2"/>
</p>


# Event – Method Mechanism

Events are the cause (or triggers) of the methods. Not every event can be connected to every method. The parameters a method expects need to match the values an event delivers. For example, a method such as setIntensity of the LED expects an integer number (as can be seen below - parameters appear between brackets).

 
<p align="center">
  <img src="Documentation/images/16 - Methods.png" alt="methods"/>
</p>

An event such as the valueChanged event of the slider delivers the value property, which is another number (float in this case). Because both parameters are compatible, it is possible to connect valueChanged to setIntensity. This will cause the intensity of the LED to be modified with a slider.


<p align="center">
  <img src="Documentation/images/17 - Events.png" alt="events"/>
</p>

