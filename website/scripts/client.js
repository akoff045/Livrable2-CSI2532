function validateName(name) {
  var regex = /^(?=.*[a-z])[A-Za-z\s'-]+$/;
  return regex.test(name) ? "" : "Please enter a valid name";
}

function validateUsername(username) {
  var regex = /^[a-zA-Z0-9_-]{1,20}$/;
  return regex.test(username)
    ? ""
    : "Username must be at most 20 characters and contain letters, numbers, dashes, and underscores";
}

function validatePassword(password) {
  var regex =
    /^(?=.*[!@#$%^&*()_\-+=\[\]{};:'",<>.\/?\\|])(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
  return regex.test(password)
    ? ""
    : "Password must be at least 8 characters, and contain a lowercase and uppercase letter, a digit, and a symbol";
}

function validateNum(num) {
  var regex = /^\d{1,20}$/;
  return regex.test(num) ? "" : "Please enter a valid number";
}

function validateNas(nas) {
  var regex = /^\d{9}$/;
  return regex.test(nas) ? "" : "Please enter a valid nas";
}

function validateZip(zip) {
  var regex = /^(?=.*[\d])[\d\s]{4,10}$/;
  return regex.test(zip) ? "" : "Please enter a valid zip code";
}

document.getElementById("login").addEventListener("click", function (event) {
  event.preventDefault();

  var data = {
    name: "",
    last: "",
    username: "",
    password: "",
    ssn: "",
    num: "",
    street: "",
    city: "",
    province: "",
    country: "",
    zip: "",
  };

  for (var field in data) {
    data[field] = document.getElementById(field).value;
  }

  var allFieldsFilled = true;
  for (var field in data) {
    if (data[field] === "") {
      document.getElementById(field).style.borderColor = "red";
      document.getElementById(field).title = "This field is required";
      allFieldsFilled = false;
    } else {
      document.getElementById(field).style.borderColor = "";
      document.getElementById(field).title = "";
    }
  }

  if (allFieldsFilled) {
    var allFieldsValid = true;
    for (var field in data) {
      var errorMessage = "";
      switch (field) {
        case "name":
          errorMessage = validateName(data[field]);
          break;
        case "last":
          errorMessage = validateName(data[field]);
          break;
        case "username":
          errorMessage = validateUsername(data[field]);
          break;
        case "password":
          errorMessage = validatePassword(data[field]);
          break;
        case "ssn":
          errorMessage = validateNas(data[field]);
          break;
        case "num":
          errorMessage = validateNum(data[field]);
          break;
        case "zip":
          errorMessage = validateZip(data[field]);
          break;
      }
      if (errorMessage) {
        document.getElementById(field).style.borderColor = "red";
        document.getElementById(field).title = errorMessage;
        allFieldsValid = false;
      } else {
        document.getElementById(field).style.borderColor = "";
        document.getElementById(field).title = "";
      }
    }
  }

  if (allFieldsValid) {
    var xhr = new XMLHttpRequest();
    var url = "http://127.0.0.1:3000/create_client";

    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/json");

    xhr.onreadystatechange = function () {
      if (xhr.readyState === 4) {
        var json = JSON.parse(xhr.responseText);
        console.log(json);

        var usernameInput = document.getElementById("username");

        if (xhr.status === 200) {
          usernameInput.style.borderColor = "";
          usernameInput.title = "";
          window.location.href = "login.html";
        } else if (xhr.status === 400) {
          usernameInput.style.borderColor = "red";
          usernameInput.title = json.message;
        }
      }
    };

    xhr.send(JSON.stringify(data));
  }
});
