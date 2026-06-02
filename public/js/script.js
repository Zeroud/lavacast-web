window.addEventListener("scroll", function() {
  const parallax = document.querySelectorAll('.parallax');
  parallax.forEach(el => {
    let scrolled = window.pageYOffset;
    el.style.backgroundPositionY = -(scrolled * -0.55) + "px";
  });
});

// Обработчик для кнопок лайка
document.addEventListener('DOMContentLoaded', function() {
  const likeBtns = document.querySelectorAll('.like-btn');
  
  likeBtns.forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      const index = this.getAttribute('data-index');
      const imageName = this.getAttribute('data-image');
      
      // Отправляем запрос для регистрации лайка
      fetch('/like?index=' + index + '&image=' + imageName, {
        method: 'GET'
      }).then(response => {
        if (response.ok) {
          // Переключаем класс liked для визуального эффекта
          this.classList.toggle('liked');
        }
      }).catch(error => console.error('Ошибка:', error));
    });
  });
});
