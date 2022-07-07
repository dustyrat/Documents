/**************************************************************************************
 * Substitution string			Description
 * %o or %O						Outputs a JavaScript object. Clicking the object name opens more information about it in the inspector.
 * %d or %i						Outputs an integer. Number formatting is supported, for example  console.log("Foo %.2d", 1.1) will output the number as two significant figures with a leading 0: Foo 01
 * %s							Outputs a string.
 * %f							Outputs a floating-point value. Formatting is supported, for example console.log("Foo %.2f", 1.1) will output the number to 2 decimal places: Foo 1.10
 * Note: Precision formatting doesn't work in Chrome
**************************************************************************************/
var obj = { integer: 1, string: 'String', floating: 3.14159265359 };
console.log("Object: %o", obj);
console.log("Integer: %i", obj.integer);
console.log("String: %s", obj.string);
console.log("Floating-Point: %.2f", obj.floating);
