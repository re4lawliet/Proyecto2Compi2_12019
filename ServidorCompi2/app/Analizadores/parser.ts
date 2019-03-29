// myparser.js
export class parser2 {
    fs = require("fs");
    jison = require("jison");
    bnf = this.fs.readFileSync("./Lexico.jison", "utf8");
    parser2: Object = new this.jison.Parser(this.bnf);
}