const carouselImages = document.querySelector('.carousel-images');
const totalImages = document.querySelectorAll('.carousel-images img').length;
const leftButton = document.querySelector('.nav-button.left');
const rightButton = document.querySelector('.nav-button.right');

let currentIndex = 0;
let startX = 0;
let isDragging = false;

function updateCarousel() {
    const offset = -currentIndex * 300; // 300px is the width of each image
    carouselImages.style.transform = `translateX(${offset}px)`;
}

// Button click listeners
rightButton.addEventListener('click', () => {
    if (currentIndex < totalImages - 1) {
        currentIndex++;
        updateCarousel();
    }
});

leftButton.addEventListener('click', () => {
    if (currentIndex > 0) {
        currentIndex--;
        updateCarousel();
    }
});

// Add touch support for mobile devices
carouselImages.addEventListener('touchstart', touchStart);
carouselImages.addEventListener('touchend', touchEnd);
carouselImages.addEventListener('touchmove', touchMove);

function touchStart(event) {
    startX = event.touches[0].clientX;
    isDragging = true;
}

function touchMove(event) {
    if (!isDragging) return;
    const currentX = event.touches[0].clientX;
    const diffX = startX - currentX;

    const translateX = -currentIndex * 300 - diffX;
    carouselImages.style.transform = `translateX(${translateX}px)`;
}

function touchEnd(event) {
  isDragging = false;
  const endX = event.changedTouches[0].clientX;
  const diffX = startX - endX;

  if (diffX > 50 && currentIndex < totalImages - 1) {
      currentIndex++;
      console.log('Swiped left to image index:', currentIndex); // Log when swiping left
  } else if (diffX < -50 && currentIndex > 0) {
      currentIndex--;
      console.log('Swiped right to image index:', currentIndex); // Log when swiping right
  }
  updateCarousel();
}
