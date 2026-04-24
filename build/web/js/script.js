/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


let current = 0;
const images = document.querySelectorAll(".carousel img");

function showImage(index) {
  images.forEach((img, i) => img.classList.remove("active"));
  images[index].classList.add("active");
}

function nextImage() {
  current = (current + 1) % images.length;
  showImage(current);
}

setInterval(nextImage, 3000);
window.onload = () => showImage(current);
