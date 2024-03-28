document.getElementById("login").addEventListener("click", function (event) {
  event.preventDefault();
  var name = document.getElementById("name").value;
  var last = document.getElementById("last").value;
  var username = document.getElementById("username").value;
  var password = document.getElementById("password").value;
  var ssn = document.getElementById("ssn").value;
  var num = document.getElementById("num").value;
  var street = document.getElementById("street").value;
  var city = document.getElementById("city").value;
  var province = document.getElementById("province").value;
  var country = document.getElementById("country").value;
  var zip = document.getElementById("zip").value;

  var data = {
    name: name,
    last: last,
    username: username,
    password: password,
    ssn: ssn,
    num: num,
    street: street,
    city: city,
    province: province,
    country: country,
    zip: zip,
  };

  var xhr = new XMLHttpRequest();
  var url = "/create_client";

  xhr.open("POST", url, true);
  xhr.setRequestHeader("Content-Type", "application/json");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      var json = JSON.parse(xhr.responseText);
      console.log(json);
    }
  };

  xhr.send(JSON.stringify(data));
});
