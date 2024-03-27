let myImage = document.querySelector("img");

myImage.onclick = function () {
  let mySrc = myImage.getAttribute("src");
  if (mySrc === "images/hotel1.jpg") {
    myImage.setAttribute("src", "images/hotel2.jpg");
  } else if (mySrc === "images/hotel2.jpg") {
    myImage.setAttribute("src", "images/hotel1.jpg");
  }
};
