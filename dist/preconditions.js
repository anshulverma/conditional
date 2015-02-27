// CommonJS export for browser - please do not edit directly
!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var n;"undefined"!=typeof window?n=window:"undefined"!=typeof global?n=global:"undefined"!=typeof self&&(n=self),n.preconditions=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  var debug, e;

  try {
    debug = require('debug')('conditional');
  } catch (_error) {
    e = _error;
    debug = function(message) {
      return console.log("" + name + " :: " + message);
    };
  }

  module.exports = debug;

}).call(this);

},{"debug":"debug"}],2:[function(require,module,exports){
(function() {
  var overrideStack, unwanted,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  unwanted = [];

  overrideStack = function() {
    var prepareStackTrace;
    if (typeof window !== "undefined" && window !== null) {
      return;
    }
    prepareStackTrace = Error.prepareStackTrace;
    return Error.prepareStackTrace = function(err, stack) {
      var _ref;
      while (_ref = stack[0].getFileName(), __indexOf.call(unwanted, _ref) >= 0) {
        stack.splice(0, 1);
      }
      return prepareStackTrace(err, stack);
    };
  };

  overrideStack();

  module.exports.trimStackTrace = function(file) {
    return unwanted.push(file);
  };

  module.exports.overrideStack = function() {
    return overrideStack();
  };

}).call(this);

},{}],3:[function(require,module,exports){
(function (__filename){
(function() {
  var AbstractError, ArgumentChecker, Checker, ContainsChecker, DEFAULT_CALLBACK, DEFAULT_MESSAGES, DefinedChecker, EmptyChecker, EqualsChecker, IllegalArgumentError, IllegalStateError, IllegalValueError, InvalidTypeError, NullChecker, NumberTypeChecker, StateChecker, UndefinedValueError, UnknownValueError, argumentChecker, debug, isArray, isEmptyString, isEqual, isNotArray, isNotPrimitive, isNotUndefined, isNumeric, isObject, isPrimitive, isString, isUndefined, trimStackTrace, xor, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  _ref = require('./util'), isObject = _ref.isObject, isArray = _ref.isArray, isNotArray = _ref.isNotArray, isNumeric = _ref.isNumeric, isString = _ref.isString, isEmptyString = _ref.isEmptyString, isNotUndefined = _ref.isNotUndefined, isUndefined = _ref.isUndefined, isEqual = _ref.isEqual, isNotPrimitive = _ref.isNotPrimitive, isPrimitive = _ref.isPrimitive, xor = _ref.xor;

  debug = require('./debug_wrapper');

  DEFAULT_CALLBACK = function(err) {
    if (err != null) {
      throw err;
    }
  };

  Checker = (function() {
    function Checker(name, defaultMessage, negate, argc) {
      this.name = name;
      this.defaultMessage = defaultMessage;
      this.negate = negate != null ? negate : false;
      this.argc = argc != null ? argc : 1;
      module.exports[this.name] = (function(_this) {
        return function() {
          return _this.check.apply(_this, arguments);
        };
      })(this);
      debug("registered checker '" + this.name + "'");
    }

    Checker.prototype.check = function() {
      var arg, args, callback, e, message, _i, _len, _ref1;
      message = arguments[this.argc];
      callback = arguments[this.argc + 1] || DEFAULT_CALLBACK;
      if (typeof message === 'function') {
        callback = message;
        message = null;
      }
      args = [];
      _ref1 = Array.prototype.splice.call(arguments, 0, this.argc);
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        arg = _ref1[_i];
        Array.prototype.push.call(args, arg);
      }
      if (message == null) {
        message = this.getErrorMessage.apply(this, args);
      }
      try {
        if (!xor(this.doCheck.apply(this, args), this.negate)) {
          this.invokeError(message);
        }
        return callback(null);
      } catch (_error) {
        e = _error;
        return callback(e);
      }
    };

    Checker.prototype.invokeError = function() {
      throw new Error('something went wrong');
    };

    Checker.prototype.doCheck = function() {
      return false;
    };

    Checker.prototype.getErrorMessage = function() {
      if (typeof this.defaultMessage === 'function') {
        return this.defaultMessage.apply(this, arguments);
      } else {
        return this.defaultMessage;
      }
    };

    return Checker;

  })();

  ArgumentChecker = (function(_super) {
    __extends(ArgumentChecker, _super);

    function ArgumentChecker(name, negate, message) {
      if (message == null) {
        message = DEFAULT_MESSAGES.INVALID_ARGUMENT;
      }
      ArgumentChecker.__super__.constructor.call(this, name, message, negate);
    }

    ArgumentChecker.prototype.doCheck = function(condition) {
      return isString(condition) || isNumeric(condition) || condition;
    };

    ArgumentChecker.prototype.invokeError = function(message) {
      throw new IllegalArgumentError(message);
    };

    return ArgumentChecker;

  })(Checker);

  NumberTypeChecker = (function(_super) {
    __extends(NumberTypeChecker, _super);

    function NumberTypeChecker(name, negate, message) {
      if (message == null) {
        message = DEFAULT_MESSAGES.INVALID_TYPE;
      }
      NumberTypeChecker.__super__.constructor.call(this, name, message, negate);
    }

    NumberTypeChecker.prototype.doCheck = function(value) {
      return isNumeric(value);
    };

    NumberTypeChecker.prototype.invokeError = function(message) {
      throw new InvalidTypeError(message);
    };

    return NumberTypeChecker;

  })(Checker);

  ContainsChecker = (function(_super) {
    __extends(ContainsChecker, _super);

    function ContainsChecker(name, negate, message) {
      ContainsChecker.__super__.constructor.call(this, name, message, negate, 2);
    }

    ContainsChecker.prototype.doCheck = function(value, object) {
      argumentChecker.check(object, 'invalid collection value');
      switch (false) {
        case !isString(object):
          return !((!isString(value)) || (value.length > object.length) || (isEmptyString(object) ^ isEmptyString(value)) || (!(isEmptyString(object) || __indexOf.call(object, value) >= 0)));
        case !isArray(object):
          return __indexOf.call(object, value) >= 0;
        case !isNumeric(object):
          return ~object.toString().indexOf(value);
        default:
          return value in object;
      }
    };

    ContainsChecker.prototype.invokeError = function(message) {
      throw new UnknownValueError(message);
    };

    return ContainsChecker;

  })(Checker);

  EqualsChecker = (function(_super) {
    __extends(EqualsChecker, _super);

    function EqualsChecker(name, negate, message) {
      EqualsChecker.__super__.constructor.call(this, name, message, negate, 2);
    }

    EqualsChecker.prototype.doCheck = function(actual, expected) {
      argumentChecker.check(isNotUndefined(expected), 'invalid value expected');
      return isEqual(actual, expected);
    };

    EqualsChecker.prototype.invokeError = function(message) {
      throw new UnknownValueError(message);
    };

    return EqualsChecker;

  })(Checker);

  DefinedChecker = (function(_super) {
    __extends(DefinedChecker, _super);

    function DefinedChecker(name, negate, message) {
      if (message == null) {
        message = DEFAULT_MESSAGES.UNDEFINED_VALUE;
      }
      DefinedChecker.__super__.constructor.call(this, name, message, negate);
    }

    DefinedChecker.prototype.doCheck = function(value) {
      return isNotUndefined(value);
    };

    DefinedChecker.prototype.invokeError = function(message) {
      throw new UndefinedValueError(message);
    };

    return DefinedChecker;

  })(Checker);

  EmptyChecker = (function(_super) {
    __extends(EmptyChecker, _super);

    function EmptyChecker(name, negate, message) {
      if (message == null) {
        message = DEFAULT_MESSAGES.ILLEGAL_VALUE;
      }
      EmptyChecker.__super__.constructor.call(this, name, message, negate);
    }

    EmptyChecker.prototype.doCheck = function(value) {
      return value === null || isUndefined(value) || (isNotPrimitive(value) && ((hasOwnProperty.call(value, 'length') && value.length === 0) || (typeof value === 'object' && Object.keys(value).length === 0)));
    };

    EmptyChecker.prototype.invokeError = function(message) {
      throw new IllegalValueError(message);
    };

    return EmptyChecker;

  })(Checker);

  StateChecker = (function(_super) {
    __extends(StateChecker, _super);

    function StateChecker(name) {
      StateChecker.__super__.constructor.call(this, name, false, DEFAULT_MESSAGES.ILLEGAL_STATE);
    }

    StateChecker.prototype.invokeError = function(message) {
      throw new IllegalStateError(message);
    };

    return StateChecker;

  })(ArgumentChecker);

  NullChecker = (function(_super) {
    __extends(NullChecker, _super);

    function NullChecker(name, negate, message) {
      if (message == null) {
        message = DEFAULT_MESSAGES.NULL_VALUE;
      }
      NullChecker.__super__.constructor.call(this, name, message, negate);
    }

    NullChecker.prototype.doCheck = function(value) {
      return isUndefined(value) || value === null;
    };

    NullChecker.prototype.invokeError = function(message) {
      throw new IllegalValueError(message);
    };

    return NullChecker;

  })(Checker);

  DEFAULT_MESSAGES = {
    INVALID_ARGUMENT: 'invalid argument',
    INVALID_TYPE: 'invalid type',
    UNKNOWN_VALUE: 'unknown value',
    UNDEFINED_VALUE: 'undefined value',
    ILLEGAL_VALUE: 'illegal value',
    ILLEGAL_STATE: 'illegal state',
    NULL_VALUE: 'value is null'
  };

  AbstractError = function(message) {
    var _ref1, _ref2;
    this.message = message;
    Error.call(this);
    Error.captureStackTrace(this, arguments.callee);
    return this.name = ((_ref1 = arguments.callee) != null ? (_ref2 = _ref1.caller) != null ? _ref2.name : void 0 : void 0) || 'Error';
  };

  AbstractError.prototype.__proto__ = Error.prototype;

  IllegalArgumentError = (function(_super) {
    __extends(IllegalArgumentError, _super);

    function IllegalArgumentError() {
      return IllegalArgumentError.__super__.constructor.apply(this, arguments);
    }

    return IllegalArgumentError;

  })(AbstractError);

  InvalidTypeError = (function(_super) {
    __extends(InvalidTypeError, _super);

    function InvalidTypeError() {
      return InvalidTypeError.__super__.constructor.apply(this, arguments);
    }

    return InvalidTypeError;

  })(AbstractError);

  UnknownValueError = (function(_super) {
    __extends(UnknownValueError, _super);

    function UnknownValueError() {
      return UnknownValueError.__super__.constructor.apply(this, arguments);
    }

    return UnknownValueError;

  })(AbstractError);

  UndefinedValueError = (function(_super) {
    __extends(UndefinedValueError, _super);

    function UndefinedValueError() {
      return UndefinedValueError.__super__.constructor.apply(this, arguments);
    }

    return UndefinedValueError;

  })(AbstractError);

  IllegalValueError = (function(_super) {
    __extends(IllegalValueError, _super);

    function IllegalValueError() {
      return IllegalValueError.__super__.constructor.apply(this, arguments);
    }

    return IllegalValueError;

  })(AbstractError);

  IllegalStateError = (function(_super) {
    __extends(IllegalStateError, _super);

    function IllegalStateError() {
      return IllegalStateError.__super__.constructor.apply(this, arguments);
    }

    return IllegalStateError;

  })(AbstractError);

  trimStackTrace = require('./error_handler').trimStackTrace;

  trimStackTrace(__filename);

  argumentChecker = new ArgumentChecker('checkArgument');

  new NumberTypeChecker('checkNumberType');

  new NumberTypeChecker('checkNotNumberType', true);

  new ContainsChecker('checkContains', false, function(value, object) {
    return "unknown value '" + value + "'";
  });

  new ContainsChecker('checkDoesNotContain', true, function(value, object) {
    return "'" + value + "' is a known value";
  });

  new EqualsChecker('checkEquals', false, function(actual, expected) {
    return "expected '" + expected + "' but got '" + actual + "'";
  });

  new EqualsChecker('checkDoesNotEqual', true, function(actual) {
    return "did not expect value '" + actual + "'";
  });

  new DefinedChecker('checkDefined');

  new DefinedChecker('checkUndefined', true, function(value) {
    return "'" + value + "' is a defined value";
  });

  new EmptyChecker('checkEmpty', false, function(value) {
    return "'" + value + "' is not empty";
  });

  new EmptyChecker('checkNotEmpty', true);

  new StateChecker('checkState');

  new NullChecker('checkNull', false, function(value) {
    return "'" + value + "' is not null";
  });

  new NullChecker('checkNotNull', true);

  module.exports.IllegalArgumentError = IllegalArgumentError;

  module.exports.InvalidTypeError = InvalidTypeError;

  module.exports.UnknownValueError = UnknownValueError;

  module.exports.UndefinedValueError = UndefinedValueError;

  module.exports.IllegalValueError = IllegalValueError;

  module.exports.IllegalStateError = IllegalStateError;

}).call(this);

}).call(this,"/lib/src/main.js")
},{"./debug_wrapper":1,"./error_handler":2,"./util":4}],4:[function(require,module,exports){
(function (__filename){
(function() {
  var isArray, isBoolean, isEmptyString, isEqual, isNotArray, isNotUndefined, isNumeric, isObject, isPrimitive, isString, isUndefined, negate, toString, trimStackTrace, xor;

  negate = function(fn) {
    return function(value) {
      return !fn(value);
    };
  };

  isObject = function(value) {
    return (value != null) && typeof value === 'object';
  };

  isArray = Array.isArray;

  isNotArray = negate(isArray);

  isNumeric = function(value) {
    return !isArray(value) && (value - parseFloat(value) + 1) >= 0;
  };

  isBoolean = function(value) {
    return typeof value === 'boolean';
  };

  toString = Object.prototype.toString;

  isString = function(value) {
    return toString.call(value) === '[object String]';
  };

  isEmptyString = function(value) {
    return isString(value) && !value;
  };

  isUndefined = function(value) {
    return typeof value === 'undefined';
  };

  isNotUndefined = negate(isUndefined);

  isEqual = function(actual, expected) {
    var i, key, value, _i, _ref;
    switch (false) {
      case !isArray(expected):
        if (isNotArray(actual) || actual.length !== expected.length) {
          return false;
        }
        for (i = _i = 0, _ref = expected.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          if (!(isEqual(actual[i], expected[i]) && isNotUndefined(actual[i]))) {
            return false;
          }
        }
        break;
      case !isObject(expected):
        for (key in expected) {
          value = expected[key];
          if (!isEqual(actual[key], value)) {
            return false;
          }
        }
        break;
      case actual === expected:
        return false;
    }
    return true;
  };

  isPrimitive = function(value) {
    return isNumeric(value) || isBoolean(value);
  };

  trimStackTrace = require('./error_handler').trimStackTrace;

  trimStackTrace(__filename);

  xor = function(operand1, operand2) {
    return !operand1 !== !operand2;
  };

  module.exports.negate = negate;

  module.exports.isObject = isObject;

  module.exports.isArray = isArray;

  module.exports.isNotArray = isNotArray;

  module.exports.isNumeric = isNumeric;

  module.exports.isString = isString;

  module.exports.isEmptyString = isEmptyString;

  module.exports.isUndefined = isUndefined;

  module.exports.isNotUndefined = isNotUndefined;

  module.exports.isEqual = isEqual;

  module.exports.isPrimitive = isPrimitive;

  module.exports.isNotPrimitive = negate(isPrimitive);

  module.exports.xor = xor;

}).call(this);

}).call(this,"/lib/src/util.js")
},{"./error_handler":2}]},{},[3])(3)
});