node-preconditions
==================

[![Build Status](https://travis-ci.org/anshulverma/node-preconditions.svg?branch=master)](https://travis-ci.org/anshulverma/node-preconditions)
[![Dependency Status](https://gemnasium.com/anshulverma/node-preconditions.svg)](https://gemnasium.com/anshulverma/node-preconditions)
[![Coverage Status](https://img.shields.io/coveralls/anshulverma/node-preconditions.svg)](https://coveralls.io/r/anshulverma/node-preconditions?branch=master)
[![NPM version](https://badge.fury.io/js/node-preconditions.svg)](http://badge.fury.io/js/node-preconditions)

[![NPM](https://nodei.co/npm/node-preconditions.png?stars=true&downloads=true)](https://nodei.co/npm/node-preconditions/)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc/generate-toc again -->
**Table of Contents**

- [node-preconditions](#node-preconditions)
    - [Summary](#summary)
    - [Installation](#installation)
    - [Usage](#usage)
        - [Argument check](#argument-check)
        - [Number type check](#number-type-check)
        - [Contains check](#contains-check)
        - [Equals check](#equals-check)
        - [Defined check](#defined-check)
    - [Building](#building)
    - [Testing](#testing)
    - [Documentation](#documentation)
    - [Build + Test + Document](#build--test--document)
    - [Contributing](#contributing)
    - [Author](#author)

<!-- markdown-toc end -->

## Summary

This is a preconditions package for node modules based on Google's Preconditions library. We all
make certain assumptions when writing code. These can be of the form of method arguments. Consider
a method called `findMax`:

``` js
function findMax(arr) {
  return Math.max.apply(Math, arr);
}
```

There is nothing wrong with this method, but, this will misbehave if you pass an empty array:

``` js
findMax([4, 2, 1]);  // returns 4
findMax([]);         // returns -Infinity
```

This is just how `Math.max` works as described [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max).
So, to avoid this scenario lets assert our assumption that the caller is not going to supply an
empty array:

``` js
function findMax(arr) {
  preconditions.checkArgument(arr.length > 0, 'array must not be empty');

  return Math.max.apply(Math, arr);
}
```
Now, whenever a user sends in an empty array, a nice and meaningful message can be printed:

``` js
findMax([]);  // throws "IllegalArgumentError: array must not be empty"
```

## Installation

``` bash
$ npm install node-preconditions
```

## Usage

The usage of various checks differs slightly as explained.

One important thing to note for all types of checks is that the error stack trace do not include
frames that point to methods of this module.

### Argument check

Checks whether argument satisfies certain condition.

> `checkArgument(condition:boolean|object, [message:string]) throws IllegalArgumentError`

This will throw `IllegalArgumentError` with message equal to the supplied string if `condition` is
`false` or `undefined`. If `message` is not provided, a default value of `"invalid argument"` is
assumed.

``` js
var checkArgument = require('node-preconditions').checkArgument;

function demo(arg) {
  checkArgument(arg === 'test', "argument string must be equal to 'test'");

  continueWithNormalOperation();
}
```

### Number type check

Check for making sure that a variable contains numerical value.

> `checkNumberType(value:*, [message:string]) throws InvalidTypeError`

In some cases you want to make sure that only numerical value are sent to a method. For example, a
method called `square(x)` which takes a numerical value x and returns its squared value. This method
expects that the user will be sending a numerical value only. As we already know by now, it is
always better to put our assumptions in code:

``` js
var checkNumberType = require('node-preconditions').checkNumberType;

function square(x) {
  checkNumberType(x, 'only numerical values can be squared');

  return Math.pow(x, 2);
}
```

### Contains check

Check if a value is contained in another.

> `checkContains(value:*, object:*, [message:string]) throws UnknownValueError`

This is a very flexible check since it can allow contains check with numbers, strings, arrays or
regular objects. Here are some of the rules it follows:

- empty strings are equal
- `null` is not same as 0 (zero) or empty string
- 'number' can contain 'string' and vice versa (except for array objects as explained below)
- array objects (second parameter) enforce strict types (for example numbers and string are
considered different in this case).

``` js
var checkContains = require('node-preconditions').checkContains;

function installPackage(userInput) {
  checkContains(userInput, ['yes', 'y', 'no', 'n'], 'invalid user input (must be y/n)');

  if (userInput.indexOf('y') === 0) {
    // do install package
  }
}
```

### Equals check

Check if two values are equal.

> `checkContains(actual:*, expected:*, [message:string]) throws UnknownValueError`

Similar to contains check, this check also allows you to check against any data type. It follows
these rules:

- empty strings are equal
- `null` values are equal
- `string` and `number` types are not equal in any condition
- `undefined` values can not be checked against (will throw a `IllegalArgumentError`)
- order of key/value pair in a `map` is not relevant. This means `{val1 : 1, val2: 2}` is same as
`{val2: 2, val1: 1}`

``` js
var checkEquals = require('node-preconditions').checkEquals;

function login(password) {
  checkEquals(password, 'expected-password', 'invalid password');

  // password successfully validated
}
```

### Defined check

Check if a value is defined (or in other words, not undefined).

> `checkDefined(value:*, [message:string]) throws UndefinedValueError`

This check follows these rules:
- an empty string is not undefined
- 0 (zero) is not undefined
- an empty array is not undefined
- an empty object is not undefined

``` js
var checkDefined = require('node-preconditions').checkDefined;

function sendMessage(message) {
  checkDefined(message, 'a valid message required')

  // proceed to send the message
}
```

## Building

To get the js source generated form coffee script:

``` bash
$ grunt coffee
```

This will put all js files in `lib` folder.

## Testing

To execute tests, make sure [grunt](https://github.com/gruntjs/grunt-cli) is installed. Then run:

``` bash
$ grunt test
```

Before testing, this task will perform a lint check using [coffeelint](http://www.coffeelint.org/).
Tests will be executed if and only if linting succeeds.

The `default` task of `grunt` will run this command as well. So, just typing `grunt` and pressing
RET is also sufficient to run tests.

## Documentation

Documentation is generated using [docco](https://github.com/jashkenas/docco) and placed in `docs`
folder. To build documentation:

``` bash
$ grunt docs
```

## Build + Test + Document

The `build` task of `grunt` will check linting, test everything, generate docs and build javascript
source. So, to execute:

``` bash
$ grunt build
```

## Contributing

Feel free to make a change and issue a pull request if you have a patch.

If you have a feature request or if you find a bug, please open a issue.

## Author

[Anshul Verma](http://anshulverma.github.io/) ::
[anshulverma](https://github.com/anshulverma) ::
[@anshulverma](http://twitter.com/anshulverma)
