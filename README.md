# PackJS

Command-line interface and folder watcher for [Snockets](https://github.com/TrevorBurnham/snockets).

## Installation

    $ npm install packjs -g

This will add `packjs` executable to your command line.

## Usage

Add Sprockets-style require directives to your `.coffee` and `.js` files to include their dependencies:

```coffee
# App.coffee
#= require dependency
```

or `//= require dependency` in JavaScript. See [Snockets' readme](https://github.com/TrevorBurnham) for more information.

## Compilation

Use `packjs` command from your terminal to compile (and minify) your scripts. Type in `packjs --help` to get the list of available options.

```

  Usage: packjs [options]

  Options:

    -w, --watch <directory>   Directory to watch file changes within
    -o, --output <directory>  Directory to output changed files
    -i, --input <file>        Input file
    -m, --minify              Minify the JavaScript output
    -V, --version             output the version number
    -h, --help                output usage information

  Examples:

    Compile with dependencies and minify a single file,
    then output it to STDOUT:
    > packjs --minify --input coffee/main.coffee

    Output the compiled JavaScript into a particular file:
    > packjs --input coffee/main.coffee > ../public/js/main.js

    Watch a folder recursively and recompile on each change,
    note that -o (output) option is required:
    > packjs --minify --watch coffee/ --output ../public/js/

```

## License

(The MIT License)

Copyright (c) 2012 Aziz Yuldoshev &lt;aziz@flatora.ru&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.