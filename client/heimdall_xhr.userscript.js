// ==UserScript==
// @name         Heimdall
// @namespace    http://minasmazar.github.io/heimdall
// @version      0.2
// @description  Heimdall is a userscript to bridge your Browser and an Elixir app.
// @author       MinasMazar
// @include      http*://*
// @match        http*://*
// @grant        GM_xmlhttpRequest
// @connect      localhost
// ==/UserScript==
/* jshint ignore:start */

//'use strict';
class HeimdallJS {

  constructor() {
    console.log("Initializing Heimdall");
    this.useWS = true;

    if (this.useWS) {
      this.setupSocket();
    }
  }

  handleResponseXHR(response) {
    //console.log(response);
    eval(response.responseText);
  }

  handleResponseWS(response) {
   //console.log(response);
   eval(response.data);
  }

  dispatchEvent(event) {
    //console.log(event);
    this.heimdallSend({
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

  heimdallSend(message) {
    if (this.useWS) {
      this.heimdallSendWS(message);
    } else {
      this.heimdallSendXHR(message);
    }
  }

  heimdallSendXHR(message) {
    GM_xmlhttpRequest({
      method: "POST",
      url: "http://localhost:9069/heimdall",
      headers: { "Content-type" : "application/json" },
      data: JSON.stringify(message),
      onerror:    function (e) { console.error ('**** error ', e); },
      onabort:    function (e) { console.error ('**** abort ', e); },
      ontimeout:  function (e) { console.error ('**** timeout ', e); },
      onload: function (message) {
        //console.log(message);
        eval(message.responseText);
      }
    });
  }

  heimdallSendWS(message) {
    const payload = { "url": window.location.href, payload: message };
    this.socket.send(JSON.stringify(payload));
  }

  setupSocket() {
    this.socket = new WebSocket("ws://localhost:9069/heimdall/ws");
    const handler = this;
    this.socket.onmessage = function (message) {
      //console.log(message);
      eval(message.data);
    };
  }
}

const heimdall = new HeimdallJS();
window.addEventListener("click", (event) => { heimdall.dispatchEvent(event) });
window.addEventListener("change", (event) => { heimdall.dispatchEvent(event) });
window.addEventListener("input", (event) => { heimdall.dispatchEvent(event) });

setTimeout(function() {
  heimdall.heimdallSend({ "location": window.location, "message": "setup" });
}, 2000);
