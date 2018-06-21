# GO-CLI
An application resembles GO-JEK application but via Command Line Interface (CLI).
This application is being developed as part of COMPFEST X Software Engineering Academy test.

## Classes in GoCli module:


### App

An object that represents the entire application logic of the GoCli application.
It is the sole class that is used by the 'front-end' AppInterface class, providing less coupling.
The front-end application access the App functionality by using many of its service methods.
There are few service method in this class: place_order, display_map, and display_order_history.

To provide these services, each App instance have a single Map instance and information about the present application user.
It also have the (hidden) service to save Map instance as JSON and load them back as Map object.

### Map

Represent the location grid which can be used to store many objects, wrapped in MapObject instances.
This class provides few map centric algorithm such as find by location, find nearest, and routing.
Map can be serialized into JSON file and loaded right back in.

### MapObject 

A container object with held an arbitrary object with their spatial properties.
Composition is being favored over inheritance in regards of the objects spatial properties.

### Route

Represent a sequence of route used to connect starting coordinate and destination coordinates.
It uses strategy pattern to swap between different routing algorithm.
Only one routing algorithm (lurus_lurus_algorithm) is implemented.

### Person

A "bean" object to contain information about the User or the Driver.

### Driver

Subclass of person. It is a person with additional attributes of bike.

### Order

Represent the order in which could user place.

### AppInterface

A stand alone application representing the user / client "UI".
It contains the "front-end" logic of the application.
It use only a single entry point: App instance,
 to connect to the rest of GoCli application, 
 which allow for less coupling.

