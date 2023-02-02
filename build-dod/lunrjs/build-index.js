/* Usage:
 
     node build-index.js <path>

   All html files in <path> will be indexed and the index is serialized into <path>/search.js

*/
var path = require("path");
var fs = require("fs");
var lunr = require("lunr");
require("lunr-languages/lunr.stemmer.support")(lunr);
require("lunr-languages/lunr.da")(lunr);
require("lunr-languages/lunr.de")(lunr);
require("lunr-languages/lunr.es")(lunr);
require("lunr-languages/lunr.fi")(lunr);
require("lunr-languages/lunr.fr")(lunr);
require("lunr-languages/lunr.hu")(lunr);
require("lunr-languages/lunr.it")(lunr);
require("lunr-languages/lunr.nl")(lunr);
require("lunr-languages/lunr.no")(lunr);
require("lunr-languages/lunr.pt")(lunr);
require("lunr-languages/lunr.ro")(lunr);
require("lunr-languages/lunr.ru")(lunr);
require("lunr-languages/lunr.sv")(lunr);
require("lunr-languages/lunr.th")(lunr);
require("lunr-languages/lunr.tr")(lunr);
require("lunr-languages/lunr.zh")(lunr);
var cheerio = require("cheerio");
var crypto = require("crypto");


// Change these constants to suit your needs
// Valid search fields: "title", "description", "keywords", "body"
const SEARCH_FIELDS = ["title", "description", "keywords", "body"];
const EXCLUDE_FILES = ["search.html", "index.html"];
const MAX_PREVIEW_CHARS = 275;  // Number of characters to show for a given search result
var SEARCH_FIELD_BOOSTS = {title: 2, description: 1.3};


function isHtml(filename) {
    lower = filename.toLowerCase();
    return (lower.endsWith(".htm") || lower.endsWith(".html"));
}


function findHtml(folder) {
    if (!fs.existsSync(folder)) {
        console.log("build-index.js: Could not find folder: ", folder);
        return;
    }

    var files = fs.readdirSync(folder);
    var htmls = [];
    for (var i = 0; i < files.length; i++) {
        var filename = path.join(folder, files[i]);
        var stat = fs.lstatSync(filename);
        if (stat.isDirectory()) {
            var recursed = findHtml(filename);
            for (var j = 0; j < recursed.length; j++) {
                recursed[j] = path.join(files[i], recursed[j]).replace(/\\/g, "/");
            }
            htmls.push.apply(htmls, recursed);
        }
        else if (isHtml(filename) && !EXCLUDE_FILES.includes(files[i])) {
            htmls.push(files[i]);
        };
    };
    return htmls;
};


function readHtml(root, file, fileId) {
    var filename = path.join(root, file);
    var txt = fs.readFileSync(filename).toString();
    var $ = cheerio.load(txt);
    /* remove blog title from title field */
    var title = $("title").text();

    if (typeof title == 'undefined') title = file;
    var description = $("meta[name=description]").attr("content");
    if (typeof description == 'undefined') description = "";
    var keywords = $("meta[name=keywords]").attr("content");
    if (typeof keywords == 'undefined') keywords = "";
    var body = $("div.body").text()
    if (typeof body == 'undefined') body = "";
    var data = {
        "id": fileId,
        "link": file,  // this will need a prefix, see RELATIVE_LINK_FROM_SEARCH_HTML
        "t": title,
        "d": description,
        "k": keywords,
        "b": body
    }
    return data;
}


function readTitleFromIndexHtml(root) {
    var filename = path.join(root,"index.html");
    var txt = fs.readFileSync(filename).toString();
    var $ = cheerio.load(txt);
    var title = $("div#document-title").text().trim();
    var type = $("div#document-type").text().trim();
    return title + (type?" ":"") + type
}


function buildIndex(docs, language) {
    var idx = lunr(function () {
        switch(language) {
          case 'DA':
            console.log("build-index.js: Building index for Danish language");
            this.use(lunr.da);
            break;
          case 'DE':
            console.log("build-index.js: Building index for German language");
            this.use(lunr.de);
            break;
          case 'ES':
            console.log("build-index.js: Building index for Spanish language");
            this.use(lunr.es);
            break;
          case 'FI':
            console.log("build-index.js: Building index for Finnish language");
            this.use(lunr.fi);
            break;
          case 'FR':
            console.log("build-index.js: Building index for French language");
            this.use(lunr.fr);
            break;
          case 'HU':
            console.log("build-index.js: Building index for Hungarian language");
            this.use(lunr.hu);
            break;
          case 'IT':
            console.log("build-index.js: Building index for Italian language");
            this.use(lunr.it);
            break;
          case 'NL':
            console.log("build-index.js: Building index for Dutch language");
            this.use(lunr.nl);
            break;
          case 'NO':
            console.log("build-index.js: Building index for Norwegian language");
            this.use(lunr.no);
            break;
          case 'PT':
            console.log("build-index.js: Building index for Portuguese language");
            this.use(lunr.pt);
            break;
          case 'RO':
            console.log("build-index.js: Building index for Romanian language");
            this.use(lunr.ro);
            break;
          case 'RU':
            console.log("build-index.js: Building index for Russian language");
            this.use(lunr.ru);
            break;
          case 'SV':
            console.log("build-index.js: Building index for Swedish language");
            this.use(lunr.sv);
            break;
          case 'TH':
            console.log("build-index.js: Building index for Thai language");
            this.use(lunr.th);
            break;
          case 'TR':
            console.log("build-index.js: Building index for Turkish language");
            this.use(lunr.tr);
            break;
          case 'ZH-CN':
            console.log("build-index.js: Building index for Simplified Chinese language");
            this.use(lunr.zh);
            break;
          case 'ZH-TW':
            console.log("build-index.js: Building index for Traditional Chinese language");
            this.use(lunr.zh);
            break;
        }
        this.ref('id');
        for (var i = 0; i < SEARCH_FIELDS.length; i++) {
            var boost = SEARCH_FIELD_BOOSTS[SEARCH_FIELDS[i]] || 1;
            this.field(SEARCH_FIELDS[i].slice(0, 1), { boost });
        }
        docs.forEach(function (doc) {
                this.add(doc);
            }, this);
        });
    return idx;
}


function buildPreviews(docs) {
    var result = {};
    for (var i = 0; i < docs.length; i++) {
        var doc = docs[i];
        var preview = doc["d"];
        if (preview == "") preview = doc["b"];
        if (preview.length > MAX_PREVIEW_CHARS)
            preview = preview.slice(0, MAX_PREVIEW_CHARS) + " ...";
        result[doc["id"]] = {
            "t": doc["t"],
            "p": preview,
            "l": doc["link"]
        }
    }
    return result;
}


function main() {
    const html_folder = process.argv[2];
    const relative_link_from_search_html = process.argv[3];
    const language = process.argv[4];
    console.log("build-index.js: Creating search index.");
    console.log("build-index.js: html_folder = " + html_folder);
    console.log("build-index.js: relative_link_from_search_html = " + relative_link_from_search_html);
    console.log("build-index.js: language = " + language);
    const id = crypto.randomUUID(); 
    files = findHtml(html_folder);
    var docs = [];
    console.log("build-index.js: Building index for these files:");
    for (var i = 0; i < files.length; i++) {
        console.log("build-index.js:     " + files[i]);
        docs.push(readHtml(html_folder, files[i], i));
    }
    var idx = buildIndex(docs, language);
    var previews = buildPreviews(docs);
    var js = "var LUNR_DATA = typeof LUNR_DATA == 'undefined' ? [] : LUNR_DATA;" + 
             "var PREVIEW_LOOKUP = typeof PREVIEW_LOOKUP == 'undefined' ? [] : PREVIEW_LOOKUP;" + 
             "var TITLES = typeof TITLES == 'undefined' ? [] : TITLES;" + 
             "var RELATIVE_LINK_FROM_SEARCH_HTML = typeof RELATIVE_LINK_FROM_SEARCH_HTML == 'undefined' ? [] : RELATIVE_LINK_FROM_SEARCH_HTML;" + 
             "LUNR_DATA['" + id + "'] = " + JSON.stringify(idx) + ";\n" +
             "PREVIEW_LOOKUP['" + id + "'] = " + JSON.stringify(previews) + ";\n" +
             "TITLES['" + id + "'] = '" + readTitleFromIndexHtml(html_folder) + "';\n" +
             "RELATIVE_LINK_FROM_SEARCH_HTML['" + id + "'] = '" + relative_link_from_search_html + "';\n";
    const output_index = html_folder + "\\search.js";
    fs.writeFile(output_index, js, function(err) {
        if(err) {
            return console.log("build-index.js: " + err);
        }
        console.log("build-index.js: Index saved as " + output_index);
    });
}

main();
