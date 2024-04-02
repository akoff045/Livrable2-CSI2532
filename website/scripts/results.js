var queryString = window.location.search.substring(1);

var pairs = queryString.split("&");

var results = [];
var startDate, endDate;
pairs.forEach(function (pair) {
  var keyValue = pair.split("=");
  if (keyValue[0].startsWith("result")) {
    results.push(JSON.parse(decodeURIComponent(keyValue[1])));
  } else if (keyValue[0] === "startDate") {
    startDate = decodeURIComponent(keyValue[1]);
  } else if (keyValue[0] === "endDate") {
    endDate = decodeURIComponent(keyValue[1]);
  }
});

function displayResults(results) {
  var resultsContainer = document.getElementById("results");

  resultsContainer.innerHTML = "";

  if (results.length > 0) {
    var selectElement = document.createElement("select");
    selectElement.id = "roomSelect";

    results.forEach(function (result) {
      var resultElement = document.createElement("div");
      resultElement.innerHTML = `
        <h3>Hotel ID: ${result.hotel_id}</h2>
        <p>Room ID: ${result.chambrel_id}</p>
        <p>Capacity: ${result.capacity}</p>
        <p>View: ${result.vue}</p>
        <p>Price: ${result.prix}</p>
      `;
      resultsContainer.appendChild(resultElement);

      var optionElement = document.createElement("option");
      optionElement.value = result.chambrel_id;
      optionElement.textContent = "Room ID: " + result.chambrel_id;
      selectElement.appendChild(optionElement);
    });

    resultsContainer.appendChild(selectElement);

    var buttonElement = document.createElement("button");
    buttonElement.id = "bookButton";
    buttonElement.textContent = "Book Now";
    resultsContainer.appendChild(buttonElement);
  } else {
    resultsContainer.textContent = "There are no results.";
  }
}

var checkButtonInterval = setInterval(function () {
  var bookButton = document.getElementById("bookButton");
  if (bookButton) {
    bookButton.addEventListener("click", function () {
      var chambre_id = document.getElementById("roomSelect").value;

      var params = new URLSearchParams(window.location.search);
      var date_start = params.get("startDate");
      var date_end = params.get("endDate");

      var xhr = new XMLHttpRequest();
      xhr.open("POST", "http://127.0.0.1:3000/reserve", true);
      xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      xhr.onload = function () {
        if (this.status == 200) {
          var response = JSON.parse(this.responseText);
          console.log(response);
        }
      };
      xhr.send(
        `chambre_id=${chambre_id}&date_start=${date_start}&date_end=${date_end}`
      );

      alert("Thank you for booking!");
      window.location.href = "book-loggedin.html";
    });

    clearInterval(checkButtonInterval);
  }
}, 1000);

displayResults(results);
