
document.addEventListener('DOMContentLoaded', function () {
    const title = document.querySelector('.rainbow-title');
    title.innerHTML = title.textContent.split('').map(letter =>
        `<span>${letter}</span>`
    ).join('');
});