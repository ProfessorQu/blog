document.addEventListener('DOMContentLoaded', () => {
  const links = document.getElementsByClassName('card-link');

  for (let link of links) {
    const image = link.querySelector('img');
    if (!image) {
      continue;
    }

    link.addEventListener('mousemove', (event) => {
      const rect = link.getBoundingClientRect();
      const x = event.clientX - rect.left;
      const y = event.clientY - rect.top;

      image.style.left = `${x}px`;
      image.style.top = `${y}px`;
    });
  }
});
