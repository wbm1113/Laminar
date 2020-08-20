/*
    classes derived from protoClass will throw exceptions when attempting
    to access methods or properties that are not defined.

    built-in object methods are implicitly disabled by this class.
*/

class protoClass
{
    __call(method = "", params*) {
        if (method != "setCapacity")
            if (method != "getAddress")
        throw exception("Method not found", -1, method)
    }

    __get(prop = "") {
        throw exception("Property not found", -1, prop)
    }
}