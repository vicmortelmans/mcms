"use strict";

var LUNR_CONFIG = {
    "resultsElementId": "searchResults",  // Element to contain results
    "noResultsElementId": "noSearchResults"  // Element displayed when search returns no results
};


// Get URL arguments
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return "";
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}


// Parse search results into HTML
function parseLunrResults(results_by_document) {
    var html = [];
    for (var d = 0; d < results_by_document.length; d++) {
      let document_key = results_by_document[d].document_key;
      let header = ('<div class="grid gridwide"><div class="manual">'
                  + TITLES[document_key] + '</div>');
      html.push(header)
      let results = results_by_document[d].results;
      for (var i = 0; i < results.length; i++) {
          let relative_link_from_search_html = RELATIVE_LINK_FROM_SEARCH_HTML[document_key];
          let id = results[i]["ref"];
          let item = PREVIEW_LOOKUP[document_key][id];
          let title = item["t"];
          let preview = item["p"];
          let link = relative_link_from_search_html + '/' + item["l"];
          let result = ('<div class="textframe"><p><a href="' + link + '">'
                      + title + '</a></p><p>'
                      + preview + '</p></div>');
          html.push(result);
      }
      let footer = ('</div>');
      html.push(footer);
    }
    if (html.length) {
        return html.join("");
    } else {
        return '';
    }
}


function escapeHtml(unsafe) {
    return unsafe
         .replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&#039;");
}


function showResultCount(query, total, domElementId) {
    if (total == 0) {
        return;
    }

    var s = "";
    if (total > 1) {
        s = "s";
    }
    var found = "<p>Found " + total + " result" + s;
    if (query != "" && query != null) {
        query = escapeHtml(query);
        var forQuery = ' for <span class="result-query">' + query + '</span>';
    }
    else {
        var forQuery = "";
    }
    var element = document.getElementById(domElementId);
    element.innerHTML = found + forQuery + "</p>";
}


function searchLunr(query) {
    searchLunrRoutine(query);
    updateQueryString('q',query);
}


function searchLunrRoutine(query) {
    // indexes are loaded as attributes to these objects:
    // LUNR_DATA = the actual index
    // PREVIEW_LOOKUP = preview extracts
    // TITLES = the title of the manual
    // RELATIVE_LINK_FROM_SEARCH_HTML = relative path that has to be prefixed 
    //   to the filename in the result
    // Reset the GUI
    var noResultsElementId = LUNR_CONFIG["noResultsElementId"];
    var resultsElementId = LUNR_CONFIG["resultsElementId"];
    document.getElementById(noResultsElementId).style.display = "none";  // hide
    document.getElementById(resultsElementId).innerHTML = "";
    // Search all indexes and collect the results
    var results_by_document = [];
    for (const document_key in LUNR_DATA) {
      let idx = lunr.Index.load(LUNR_DATA[document_key]);
      let results = idx.search(query);
      if (results.length) {
        // Sort results by score (highest score first)
        results.sort((r1, r2) => r2.score - r1.score);
        results_by_document.push({
          results: results,
          document_key: document_key
        });
      }
    }
    // Sort documents by highest score (looking at first result in list)
    results_by_document.sort((d1, d2) => d2.results[0].score - d1.results[0].score);
    // Write results to page
    var resultHtml = parseLunrResults(results_by_document);
    if (resultHtml.length) {
      document.getElementById(resultsElementId).innerHTML = resultHtml;
    } else {
      document.getElementById(noResultsElementId).style.display = "block";  // show
    }
}


function updateQueryString(key, value) {
    if (history.pushState) {
        let searchParams = new URLSearchParams(window.location.search);
        searchParams.set(key, value);
        let newurl = window.location.protocol + "//" 
                     + window.location.host 
                     + window.location.pathname + '?' 
                     + searchParams.toString();
        window.history.pushState({path: newurl}, '', newurl);
    }
} 

// When the window loads, read query parameters and perform search
window.onload = function() {
    var query = getParameterByName("q");
    if (query != "" && query != null) {
        document.forms.lunrSearchForm.q.value = query;
        searchLunrRoutine(query);
    }
}; 
window.onpopstate = window.onload;
