var xhr = new XMLHttpRequest();
xhr.open("GET", "http://127.0.0.1:3000/logout", true);
xhr.onload = function () {
  if (xhr.status === 200) {
    var data = JSON.parse(xhr.responseText);
    if (data.success) {
      window.location.href = "login.html";
    }
  }
};
xhr.send();
