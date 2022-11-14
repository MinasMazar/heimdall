// ==UserScript==
// @name         Heimdall (XHR)
// @namespace    http://minasmazar.github.io/heimdall
// @version      0.1
// @description  Heimdall is a userscript to bridge your Browser and an Elixir app.
// @author       MinasMazar
// @include      http*://*
// @match        http*://*
// @grant        GM_xmlhttpRequest
// @connect      localhost
// ==/UserScript==
/* jshint ignore:start */

(function() {
    'use strict';
    console.log("Initializing Heimdall (XHR)");

    function handleResponse(response) {
        // console.log(response);
        eval(response.responseText);
    };

    function dispatchEvent(event) {
        //console.log(event);
        heimdallSend({
            "location": window.location,
            "event": {
                "type": event.type,
                "tag": event.target.tagName,
                "class": event.target.className,
                "id": event.target.id,
                "text": event.target.innerText,
                "value": event.target.value
            }
        });
    }

    function heimdallSend(params) {
        GM_xmlhttpRequest({
            method: "POST",
            url: "http://localhost:9069/heimdall",
            headers: { "Content-type" : "application/json" },
            data: JSON.stringify(params),
            onload: handleResponse,
            onerror:    function (e) { console.error ('**** error ', e); },
            onabort:    function (e) { console.error ('**** abort ', e); },
            ontimeout:  function (e) { console.error ('**** timeout ', e); }
        });
    };

    window.addEventListener("click", dispatchEvent);
    window.addEventListener("change", dispatchEvent);
    window.addEventListener("input", dispatchEvent);

    heimdallSend({ "location": window.location, "message": "setup" });
})();
