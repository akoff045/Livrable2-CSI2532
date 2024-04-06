document.getElementById("go-book").addEventListener("click", function (event) {
  event.preventDefault();
  var startDate = document.getElementById("startDate").value;
  var endDate = document.getElementById("endDate").value;
  var hotel = document.getElementById("hotel").value;
  var price = document.getElementById("price").value;
  var capacity = document.getElementById("capacity").value;
  var type = document.getElementById("type").value;
  var size = document.getElementById("size").value;

  var xhr = new XMLHttpRequest();
  xhr.open("POST", "http://127.0.0.1:3000/book", true);
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  xhr.onload = function () {
    if (this.status == 200) {
      var response = JSON.parse(this.responseText);
      console.log(response);

      var queryString =
        "?" +
        response
          .map(function (result, index) {
            return (
              "result" +
              index +
              "=" +
              encodeURIComponent(JSON.stringify(result))
            );
          })
          .join("&") +
        `&startDate=${startDate}&endDate=${endDate}`;

      window.location.href = "results.html" + queryString;
    }
  };

  xhr.send(
    `startDate=${startDate}&endDate=${endDate}&hotel=${hotel}&price=${price}&capacity=${capacity}&type=${type}&size=${size}`
  );
});
