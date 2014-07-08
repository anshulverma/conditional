node-preconditions
==================

[![Build Status](https://travis-ci.org/anshulverma/node-preconditions.svg?branch=master)](https://travis-ci.org/anshulverma/node-preconditions)
[![Dependency Status](https://gemnasium.com/anshulverma/node-preconditions.svg)](https://gemnasium.com/anshulverma/node-preconditions)

<!-- markdown-toc start - Don't edit this section. Run M-x mardown-toc/generate-toc again -->
**Table of Contents**

- [node-preconditions](#node-preconditions)
    - [Summary](#summary)
    - [Installation](#installation)
    - [Usage](#usage)
        - [Argument check](#argument-check)
    - [Building](#building)
    - [Testing](#testing)
    - [Documentation](#documentation)
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

> checkArgument(condition:boolean, [message:string])

This will throw `IllegalArgumentError` with message equal to the supplied string if `condition` is
`false`. If `message` is not provided, a default value of `"invalid argument"` is assumed.

``` js
var preconditions = require('node-preconditions');

function demo(arg) {
  preconditions.checkArgument(arg === 'test', "argument string must be equal to 'test'");

  continueWithNormalOperation();
}
```

## Building

To get the js source generated form coffee script:

``` bash
$ cake build
```

This will put all js files in `lib` folder.

## Testing

To execute tests:

``` bash
$ cake test
```

## Documentation

This module uses `docco` for document generation. To get the documentation:

``` bash
$ cake docs
```

All documentation files will be placed in `docs` folder.

## Contributing

Feel free to make a change and issue a pull request if you have a patch.

If you have a feature request or if you find a bug, please open a issue.

## Author

[Anshul Verma](http://anshulverma.github.io/) ::
[anshulverma](https://github.com/anshulverma) ::
[@anshulverma](http://twitter.com/anshulverma)
