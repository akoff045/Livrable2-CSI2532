document.getElementById("login").addEventListener("click", function (event) {
  event.preventDefault();
  var username = document.getElementById("username").value;
  var password = document.getElementById("password").value;

  var xhr = new XMLHttpRequest();
  xhr.open("POST", "http://127.0.0.1:3000/login", true);
  xhr.setRequestHeader("Content-Type", "application/json");
  xhr.send(JSON.stringify({ username, password }));

  xhr.onload = function () {
    if (xhr.status === 200) {
      var data = JSON.parse(xhr.responseText);
      if (data.success) {
        window.location.href = "book-loggedin.html";
        checkLoginStatus();
      } else {
        document.getElementById("username").style.borderColor = "red";
        document.getElementById("username").title =
          "Invalid username or password";
        document.getElementById("password").style.borderColor = "red";
        document.getElementById("password").title =
          "Invalid username or password";
      }
    } else if (xhr.status === 400) {
      document.getElementById("username").style.borderColor = "red";
      document.getElementById("username").title =
        "Invalid username or password";
      document.getElementById("password").style.borderColor = "red";
      document.getElementById("password").title =
        "Invalid username or password";
    }
  };
});

function checkLoginStatus() {
  var xhr = new XMLHttpRequest();
  xhr.open("GET", "http://127.0.0.1:3000/check-login", true);
  xhr.onload = function () {
    var data = JSON.parse(xhr.responseText);
    if (data.loggedIn) {
      console.log("User is logged in");
    } else {
      console.log("User is not logged in");
    }
  };
  xhr.send();
}

checkLoginStatus()
