"use strict";
exports.__esModule = true;
// myparser.js
var parser = /** @class */ (function () {
    function parser() {
        this.fs = require("fs");
        this.jison = require("jison");
        this.bnf = this.fs.readFileSync("./Lexico.jison", "utf8");
        this.parser = new this.jison.Parser(this.bnf);
    }
    return parser;
}());
exports.parser = parser;
