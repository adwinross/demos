import Foundation

class Person: NSObject {
    var firstName: String
    var lastName: String
    var age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        super.init()
    }
}

let person = Person(firstName: "Adwin", lastName: "Ross", age: 30)

// Get superclass
let superclass: AnyClass = class_getSuperclass(type(of: person))!
print("Superclass: \(superclass)")
print("=================================================")

// Get class name
let classNameChar = class_getName(type(of: person))
let className = String(cString: classNameChar)
print("Class Name: \(className)")
print("=================================================")

// Get size of the object in bytes
let instanceSize = class_getInstanceSize(type(of: person))
print("Instance Size: \(instanceSize)")
print("=================================================")

// Get all the property names in an object
var count: UInt32 = 0
var ivars: UnsafeMutablePointer<Ivar> = class_copyIvarList(type(of: person), &count)!
print("Property Names:")
var ivarNames = [NSString]()
for i in 0..<count {
    let ivarName = NSString(cString: ivar_getName(ivars[Int(i)])!, encoding: NSUTF8StringEncoding)!
    ivarNames.append(ivarName)
    print("\(i+1). \(String(describing: ivarName))")
}
print("=================================================")

// Get all the methods in an object
var methodCount: UInt32 = 0
let methodList = class_copyMethodList(type(of: person), &methodCount)!
for i in 0..<count {
    let selector = method_getName(methodList[Int(i)])
    let methodName = NSString(cString: sel_getName(selector), encoding: NSUTF8StringEncoding)
    print("\(i+1). \(String(describing: methodName))")
}
print("=================================================")

// Create a class from scratch
if let allocatedPersonClass: AnyClass = objc_allocateClassPair(NSObject.classForCoder(), UUID().uuidString, 0) {
    let rawEncoding = "i"
    var size: Int = 0
    var alignment: Int = 0
    NSGetSizeAndAlignment(rawEncoding, &size, &alignment)
    if class_addIvar(allocatedPersonClass, "age", size, UInt8(alignment), "i") {
        print("age added")
    } else {
        print("failed")
    }
    if class_addIvar(allocatedPersonClass, "firstName", size, UInt8(alignment), "@") {
        print("firstName added")
    } else {
        print("failed")
    }
    if class_addIvar(allocatedPersonClass, "lastName", size, UInt8(alignment), "@") {
        print("lastName added")
    } else {
        print("failed")
    }
    objc_registerClassPair(allocatedPersonClass)
    let runTimeObject = allocatedPersonClass.alloc()
    runTimeObject.setValue(30, forKey: "age")
    runTimeObject.setValue("Adwin", forKey: "firstName")
    runTimeObject.setValue("Ross", forKey: "lastName")
    print("firstName: ", runTimeObject.value(forKey: "firstName")!)
    print("lastName: ", runTimeObject.value(forKey: "lastName")!)
    print("age: ", runTimeObject.value(forKey: "age")!)
}
print("=================================================")
