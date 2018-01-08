function setColorById(id,color) {
  var elem;
  if (document.getElementById) {
    if (elem=document.getElementById(id)) {
      if (elem.style) {
        if(color == "darkgreen") {
          elem.style.color=color;
          elem.textContent="Status: SHAInet running";
        }
        else {
          elem.style.color=color;
          elem.textContent="Status: SHAInet stopped";
        }
      }
    }
  }
}

function setTextById(id, text) {
  if (document.getElementById) {
    if (elem = document.getElementById(id)) {
      elem.textContent=text;
    }
  }
}

function update(retries) {
  $.ajax({
    type: "GET",
    url: "/isready",
    success: function (data, status, jqXHR) {
      console.log("success: " + data);
      if(data.includes("Epoch")) {
        var split = data.split(",");
        setTextById("time", split[0]);
        setTextById("epoch", split[1]);
        setTextById("totalError", split[2]);
        setTextById("mse", split[3]);
        console.log(data);
        setColorById("status", "darkgreen");
        var myImageElement = document.getElementById('svg');
        myImageElement.src = 'svg/graph.svg?rand=' + Math.random();
      }
      else if(data == "busy") {
        console.log("busy");
        retries += 1;
        if(retries < 3) {
          setTimeout(function() {
            console.log("retrying");
            update(retries);
          }, 100);
        };
      };
    },
    error: function (jqXHR, status) {
      setColorById("status", "darkred");
      console.log("aborted");
    }
  });
}
setInterval(function() {
  update(0);
}, 1000);
