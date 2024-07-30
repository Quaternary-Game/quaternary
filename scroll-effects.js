function handleIntersection(entries, observer) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('fade-in');
            clearTimeout(entry.target.fadeOutTimeout);
        } else {
            entry.target.fadeOutTimeout = setTimeout(() => {
                entry.target.classList.remove('fade-in');
            }, 300); // 300ms delay, adjust as needed
        }
    });
}
function setupFadeInOnScroll() {
    const sections = document.querySelectorAll('section');

    const observer = new IntersectionObserver(handleIntersection, {
        threshold: 0.1,  // Trigger when 10% of the section is visible
        rootMargin: '-10% 0px -10% 0px'  // Slightly shrink the effective viewport
    });

    sections.forEach(section => {
        observer.observe(section);
    });
}

// Run the function when the page loads
window.addEventListener('load', setupFadeInOnScroll);
