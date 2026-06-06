window.addEventListener("scroll", function() {
  const parallax = document.querySelectorAll('.parallax');
  parallax.forEach(el => {
    let scrolled = window.pageYOffset;
    el.style.backgroundPositionY = -(scrolled * -0.55) + "px";
  });
});