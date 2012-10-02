# JSONdiff.js

JSONdiff.js is a port of [JSONdiff](https://github.com/algesten/jsondiff) from Java to JavaScript (actually CoffeeScript),
also extended to support [JSON pointer](https://github.com/andreineculau/node-jsonpointer).


# Usage

```coffee
jsonDiff = require 'jsondiff'
instance =
  a: 1
  b: 2
diff =
  '/a': 2
  '-/b': 0
instance2 = jsonDiff.parse instances, diff
instance2.a is 2
instance2.b is undefined
```


# License

[MIT](http://opensource.org/licenses/MIT)
