"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// myparser.js
var parser2 = /** @class */ (function () {
    function parser2() {
        this.fs = require("fs");
        this.jison = require("jison");
        this.bnf = this.fs.readFileSync("./Lexico.jison", "utf8");
        this.parser2 = new this.jison.Parser(this.bnf);
    }
    return parser2;
}());
exports.parser2 = parser2;
