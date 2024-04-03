document.getElementById("go-book").addEventListener("click", function (event) {
  event.preventDefault();
  var startDate = document.getElementById("startDate").value;
  var endDate = document.getElementById("endDate").value;
  var userNas = document.getElementById("userNas").value;

  var xhr = new XMLHttpRequest();
  xhr.open("POST", "http://127.0.0.1:3000/book_employee", true);
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
        `&startDate=${startDate}&endDate=${endDate}&userNas=${userNas}`;

      window.location.href = "results-employee.html" + queryString;
    } else if (this.status == 400) {
      document.getElementById("userNas").style.borderColor = "red";
      document.getElementById("userNas").title = "Invalid NAS";
    }
  };

  xhr.send(
    `startDate=${startDate}&endDate=${endDate}&userNas=${userNas}`
  );
});
