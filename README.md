conditional
==================

[![Build Status](http://goo.gl/syDtQQ)](https://travis-ci.org/anshulverma/conditional)
[![Dependency Status](https://gemnasium.com/anshulverma/conditional.svg)](https://gemnasium.com/anshulverma/conditional)
[![Coverage Status](https://img.shields.io/coveralls/anshulverma/conditional.svg)](https://coveralls.io/r/anshulverma/conditional?branch=master)
[![NPM version](https://badge.fury.io/js/conditional.svg)](http://badge.fury.io/js/conditional)

[![NPM](https://nodei.co/npm/conditional.png?stars=true&downloads=true)](https://nodei.co/npm/conditional/)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc/generate-toc again -->
**Table of Contents**

- [conditional](#conditional)
    - [Summary](#summary)
    - [Installation](#installation)
        - [NPM](#npm)
        - [Bower](#bower)
    - [Browser version](#browser-version)
    - [Usage](#usage)
        - [Argument check](#argument-check)
        - [State check](#state-check)
        - [Number type check](#number-type-check)
        - [Contains check](#contains-check)
        - [Equals check](#equals-check)
        - [Defined check](#defined-check)
        - [Empty check](#empty-check)
        - [Null check](#null-check)
    - [Building](#building)
    - [Testing](#testing)
    - [Documentation](#documentation)
    - [Build + Test + Document](#build--test--document)
    - [Contributing](#contributing)
    - [Author](#author)
    - [License](#license)

<!-- markdown-toc end -->

## Summary

This is a preconditions package for node modules based on Google's
Preconditions library. We all make certain assumptions when writing
code. Won't it be nice to assert that your assumptions about data is
correct? And to gracefully fail with a meaningful error message in case
the data is bad or assumption was not valid in the first place?

Consider a method called `findMax`:

``` js
function findMax(arr) {
  return Math.max.apply(Math, arr);
}
```

There is nothing wrong with this method, but, this will misbehave if you
pass an empty array:

``` js
findMax([4, 2, 1]);  // returns 4
findMax([]);         // returns -Infinity
```

This is just how `Math.max` works as described
[here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max).
So, to avoid this scenario lets assert our assumption that the caller is
not going to supply an empty array:

``` js
function findMax(arr) {
  preconditions.checkArgument(arr.length > 0, 'array is empty');

  return Math.max.apply(Math, arr);
}
```

Now, whenever a user sends in an empty array, a nice and meaningful
message can be printed:

``` js
findMax([]);  // throws "IllegalArgumentError: array is empty"
```

## Installation

### NPM

``` bash
$ npm install conditional
```

### Bower

This will install the bower component without the `debug`
dependency. You must to add this yourself if it is needed in your app.

``` bash
$ bower install preconditions
```

## Browser version

This library can be used in the browser. You can either copy the file
you need from `dist` folder, or, you can get it from cdnjs called
`preconditions`. This will export a global variable called
`preconditions` which will work exactly as defined in following usage
examples.

## Usage

The usage of various checks differs slightly as explained.

One important thing to note for all types of checks is that the error
stack trace do not include frames that point to methods of this module.

Each check accepts a callback function as the last parameter. If passed,
and if the check fails, the callback will be invoked with the
error. This means that message and callback parameters are optional for
each precondition check. For example, `checkArgument` can be invoked in
any of these ways:

- no message or callback

``` js
checkArgument(typeof myVar === 'string')
```

If this check fails, a error will be thrown with the default message.

- a custom message but no callback

``` js
checkArgument(typeof myVar === 'string', 'expecting string value')
```

Upon failure, the above check will throw a error with the message
`'expecting string value'`.

- a custom callback but no message

``` js
checkArgument(typeof myVar === 'string', function(err) {
  if (err != null) {
    console.error('Something went wrong: ' + err.message);
  }
});
```

So, if a callback is passed to a check, it will be invoked with the
error argument. Please note that the callback is invoked even if there
was no error (in which case the error is `null`).

- a custom message and a custom callback

``` js
checkArgument(arg > 0, 'expecting positive value', function(err) {
  if (err != null) {
    console.error('I was expecting a positive number');
  }
});
```

This works in a similar fashion as the one above except that the error's
message will be the one we specified.

With this in mind, lets look at all the available precondition checks
below.

### Argument check

Checks whether argument satisfies certain condition.

``` js
checkArgument(condition:*, [message:string], [callback:function])
    throws IllegalArgumentError
```

This will throw `IllegalArgumentError` with message equal to the
supplied string if `condition` is `false` or `undefined`. If `message`
is not provided, a default value of `"invalid argument"` is assumed.

``` js
var checkArgument = require('conditional').checkArgument;

function demo(arg) {
  checkArgument(arg === 'test', "argument must be equal to 'test'");

  continueWithNormalOperation();
}
```

### State check

This has a similar signature and usage as argument check defined
above. The only difference is in the error type and default error
message.

``` js
checkState(condition:*, [message:string], [callback:function])
    throws IllegalStateError
```

The default value for error message is `"illegal state"`.

### Number type check

Check for making sure that a variable contains numerical value.

``` js
checkNumberType(value:*, [message:string], [callback:function])
    throws InvalidTypeError
```

``` js
checkNotNumberType(value:*, [message:string], [callback:function])
    throws InvalidTypeError
```

In some cases you want to make sure that only numerical value are sent
to a method. For example, a method called `square(x)` which takes a
numerical value x and returns its squared value. This method expects
that the user will be sending a numerical value only. As we already know
by now, it is always better to put our assumptions in code:

``` js
var checkNumberType = require('conditional').checkNumberType;

function square(x) {
  checkNumberType(x, 'only numerical values can be squared');

  return Math.pow(x, 2);
}
```

### Contains check

Check if a value is contained in another.

``` js
checkContains(value:*, object:*, [message:string], [callback:function])
    throws UnknownValueError
```

``` js
checkDoesNotContain(value:*, object:*, [message:string], [callback:function])
    throws UnknownValueError
```

As expected `checkDoesNotContain` behave exactly opposite as its
counterpart `checkContains`.

This is a very flexible check since it can allow contains check with
numbers, strings, arrays or regular objects. Here are some of the rules
it follows:

- empty strings are equal
- `null` is not same as 0 (zero) or empty string
- 'number' can contain 'string' and vice versa (except for array objects
  as explained below)
- array objects (second parameter) enforce strict types (for example
numbers and string are considered different in this case).

``` js
var checkContains = require('conditional').checkContains;

function installPackage(userInput) {
  checkContains(userInput, ['yes', 'y', 'no', 'n'], 'invalid input');

  if (userInput.indexOf('y') === 0) {
    // do install package
  }
}
```

### Equals check

Check if two values are equal.

``` js
checkEquals(actual:*, expected:*, [message:string], [callback:function])
    throws UnknownValueError
```

``` js
checkDoesNotEqual(actual:*, expected:*, [message:string], [callback:function])
    throws UnknownValueError
```

Similar to contains check, this check also allows you to check against
any data type. It follows these rules:

- empty strings are equal
- `null` values are equal
- `string` and `number` types are not equal in any condition
- `undefined` values can not be checked against (will throw a
  `IllegalArgumentError`)
- order of key/value pair in a `map` is not relevant. This means
`{val1 : 1, val2: 2}` is same as `{val2: 2, val1: 1}`

``` js
var checkEquals = require('conditional').checkEquals;

function login(password) {
  checkEquals(password, 'expected-password', 'invalid password');

  // password successfully validated
}
```

### Defined check

Check if a value is defined (or in other words, not undefined).

``` js
checkDefined(value:*, [message:string], [callback:function])
    throws UndefinedValueError
```

``` js
checkUndefined(value:*, [message:string], [callback:function])
    throws UndefinedValueError
```

This check follows these rules:
- `null` is a defined value
- an empty string is not undefined
- 0 (zero) is not undefined
- an empty array is not undefined
- an empty object is not undefined

``` js
var checkDefined = require('conditional').checkDefined;

function sendMessage(message) {
  checkDefined(message, 'a valid message required')

  // proceed to send the message
}
```

### Empty check

Check if a value is empty or not.

``` js
checkEmpty(value:*, [message:string], [callback:function])
    throws IllegalValueError
```

``` js
checkNotEmpty(value:*, [message:string], [callback:function])
    throws IllegalValueError
```

`notEmpty` check follows these rules:
- `null` value is empty
- empty array or object (i.e. `{}`) is also considered empty
- empty string is obviously considered empty
- value 0 (zero) or `false` are not considered empty

``` js
var checkNotEmpty = require('conditional').checkNotEmpty

function sendMessage(message) {
  checkNotEmpty(message, 'message must not be empty');

  // proceed to send the message
}
```

### Null check

Check if value is `null` or `undefined`.

``` js
checkNull(value:*, [message:string], [callback:function])
    throws IllegalValueError
```

``` js
checkNotNull(value:*, [message:string], [callback:function])
    throws IllegalValueError
```


In most cases, you'd be more interested in the `checkNotNull`
precondition than the other. This `checkDefined` precondition is
slightly different than this one as it does not check for `null`s. Here
is an example:

``` js
var checkNotNull = require('conditional').checkNotNull;

function parse(str) {
  // do some string manipulation
}

function getUserInput(callback) {
  readFromInput(function(err, str) {
    if(err != null) {
      callback(err);
    } else {
      checkNotNull(str, function (err) {
        if(err != null) {
          callback(null, null);
        } else {
          callback(null, parse(str));
        }
      });
    }
  });
}
```

## Building

To get the js source generated form coffee script:

``` bash
$ grunt coffee
```

This will put all js files in `lib` folder.

## Testing

To execute tests, make sure
[grunt](https://github.com/gruntjs/grunt-cli) is installed. Then run:

``` bash
$ grunt test
```

Before testing, this task will perform a lint check using
[coffeelint](http://www.coffeelint.org/).  Tests will be executed if and
only if linting succeeds.

The `default` task of `grunt` will run this command as well. So, just
typing `grunt` and pressing RET is also sufficient to run tests.

## Debugging

The debug module is integrated into this library. To enable it, run your
app like this:

``` bash
$ DEBUG=conditional npm start
```

## Documentation

Documentation is generated using
[docco](https://github.com/jashkenas/docco) and placed in `docs`
folder. To build documentation:

``` bash
$ grunt docs
```

## Build + Test + Document

The `build` task of `grunt` will check linting, test everything,
generate docs and build javascript source. So, to execute:

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

## License

The MIT License (MIT)

Copyright (c) 2014 Anshul Verma

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
