// Artisan'IA - Main JavaScript file
// Modern, performant, and accessible interactions

document.addEventListener('DOMContentLoaded', function() {
  
  // ===== MOBILE MENU =====
  const mobileMenuBtn = document.getElementById('mobile-menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  
  if (mobileMenuBtn && mobileMenu) {
    mobileMenuBtn.addEventListener('click', function() {
      mobileMenu.classList.toggle('hidden');
      
      // Animate hamburger icon
      const icon = mobileMenuBtn.querySelector('svg');
      if (mobileMenu.classList.contains('hidden')) {
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>';
      } else {
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>';
      }
    });
    
    // Close mobile menu when clicking on links
    mobileMenu.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        mobileMenu.classList.add('hidden');
        const icon = mobileMenuBtn.querySelector('svg');
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>';
      });
    });
  }
  
  // ===== SMOOTH SCROLLING =====
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        const headerHeight = document.querySelector('header').offsetHeight;
        const targetPosition = target.offsetTop - headerHeight - 20;
        
        window.scrollTo({
          top: targetPosition,
          behavior: 'smooth'
        });
      }
    });
  });
  
  // ===== HEADER SCROLL EFFECT =====
  const header = document.getElementById('header');
  let lastScrollY = window.scrollY;
  
  function updateHeader() {
    const currentScrollY = window.scrollY;
    
    if (currentScrollY > 100) {
      header.classList.add('bg-white/95', 'shadow-lg', 'backdrop-blur-xl');
      header.classList.remove('bg-white/80');
    } else {
      header.classList.add('bg-white/80');
      header.classList.remove('bg-white/95', 'shadow-lg', 'backdrop-blur-xl');
    }
    
    // Hide/show header on scroll with smooth animation
    if (currentScrollY > lastScrollY && currentScrollY > 200) {
      header.style.transform = 'translateY(-100%)';
      header.style.transition = 'transform 0.3s ease-in-out';
    } else {
      header.style.transform = 'translateY(0)';
      header.style.transition = 'transform 0.3s ease-in-out';
    }
    
    lastScrollY = currentScrollY;
  }
  
  window.addEventListener('scroll', throttle(updateHeader, 10));
  
  // ===== INTERSECTION OBSERVER FOR ANIMATIONS =====
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        
        // Staggered animation for feature cards
        if (entry.target.classList.contains('feature-card')) {
          const cards = entry.target.parentElement.querySelectorAll('.feature-card');
          cards.forEach((card, index) => {
            setTimeout(() => {
              card.classList.add('visible');
            }, index * 100);
          });
        }
      }
    });
  }, observerOptions);
  
  // Observe elements for animations
  document.querySelectorAll('.fade-in, .slide-in-left, .slide-in-right, .scale-in, .feature-card').forEach(el => {
    observer.observe(el);
  });
  
  // ===== PARALLAX EFFECT =====
  function updateParallax() {
    const scrolled = window.pageYOffset;
    const parallaxElements = document.querySelectorAll('.parallax');
    
    parallaxElements.forEach(element => {
      const speed = element.dataset.speed || 0.5;
      const yPos = -(scrolled * speed);
      element.style.transform = `translateY(${yPos}px)`;
    });
  }
  
  window.addEventListener('scroll', throttle(updateParallax, 10));
  
  // ===== FORM HANDLING =====
  const contactForm = document.querySelector('form[action*="formspree"]');
  if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const submitBtn = this.querySelector('button[type="submit"]');
      const originalText = submitBtn.textContent;
      
      // Show loading state
      submitBtn.textContent = 'Envoi en cours...';
      submitBtn.disabled = true;
      submitBtn.classList.add('loading');
      
      // Simulate form submission (replace with actual Formspree handling)
      setTimeout(() => {
        // Reset button
        submitBtn.textContent = originalText;
        submitBtn.disabled = false;
        submitBtn.classList.remove('loading');
        
        // Show success message
        showNotification('Message envoyé avec succès !', 'success');
        
        // Reset form
        this.reset();
      }, 2000);
    });
  }
  
  // ===== NOTIFICATION SYSTEM =====
  function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transition-all duration-300 transform translate-x-full ${
      type === 'success' ? 'bg-green-500 text-white' : 
      type === 'error' ? 'bg-red-500 text-white' : 
      'bg-blue-500 text-white'
    }`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Animate in
    setTimeout(() => {
      notification.classList.remove('translate-x-full');
    }, 100);
    
    // Auto remove
    setTimeout(() => {
      notification.classList.add('translate-x-full');
      setTimeout(() => {
        document.body.removeChild(notification);
      }, 300);
    }, 3000);
  }
  
  // ===== LAZY LOADING IMAGES =====
  const imageObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.classList.remove('lazy');
        imageObserver.unobserve(img);
      }
    });
  });
  
  document.querySelectorAll('img[data-src]').forEach(img => {
    imageObserver.observe(img);
  });
  
  // ===== TYPING ANIMATION =====
  function typeWriter(element, text, speed = 50) {
    let i = 0;
    element.innerHTML = '';
    
    function type() {
      if (i < text.length) {
        element.innerHTML += text.charAt(i);
        i++;
        setTimeout(type, speed);
      }
    }
    
    type();
  }
  
  // ===== COUNTER ANIMATION =====
  function animateCounter(element, target, duration = 2000) {
    let start = 0;
    const increment = target / (duration / 16);
    
    function updateCounter() {
      start += increment;
      if (start < target) {
        element.textContent = Math.floor(start);
        requestAnimationFrame(updateCounter);
      } else {
        element.textContent = target;
      }
    }
    
    updateCounter();
  }
  
  // ===== SCROLL TO TOP BUTTON (DISABLED) =====
  // Scroll to top button removed to avoid UI conflicts
  
  // ===== PERFORMANCE OPTIMIZATIONS =====
  
  // Throttle function for scroll events
  function throttle(func, limit) {
    let inThrottle;
    return function() {
      const args = arguments;
      const context = this;
      if (!inThrottle) {
        func.apply(context, args);
        inThrottle = true;
        setTimeout(() => inThrottle = false, limit);
      }
    }
  }
  
  // Debounce function for resize events
  function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }
  
  // ===== ACCESSIBILITY ENHANCEMENTS =====
  
  // Skip link functionality
  const skipLink = document.createElement('a');
  skipLink.href = '#main-content';
  skipLink.textContent = 'Aller au contenu principal';
  skipLink.className = 'skip-link';
  document.body.insertBefore(skipLink, document.body.firstChild);
  
  // Keyboard navigation for custom elements
  document.querySelectorAll('[role="button"]').forEach(element => {
    element.addEventListener('keydown', function(e) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        this.click();
      }
    });
  });
  
  // Focus management for modals and dropdowns
  function trapFocus(element) {
    const focusableElements = element.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
    const firstElement = focusableElements[0];
    const lastElement = focusableElements[focusableElements.length - 1];
    
    element.addEventListener('keydown', function(e) {
      if (e.key === 'Tab') {
        if (e.shiftKey) {
          if (document.activeElement === firstElement) {
            lastElement.focus();
            e.preventDefault();
          }
        } else {
          if (document.activeElement === lastElement) {
            firstElement.focus();
            e.preventDefault();
          }
        }
      }
    });
  }
  
  // ===== PRELOAD CRITICAL RESOURCES =====
  function preloadCriticalResources() {
    const criticalImages = [
      'assets/images/Logo Artisan\'IA4.svg',
      'assets/images/mockup-dashboard.png'
    ];
    
    criticalImages.forEach(src => {
      const link = document.createElement('link');
      link.rel = 'preload';
      link.as = 'image';
      link.href = src;
      document.head.appendChild(link);
    });
  }
  
  preloadCriticalResources();
  
  // ===== ANALYTICS AND TRACKING =====
  function trackEvent(eventName, properties = {}) {
    // Placeholder for analytics tracking
    console.log('Event tracked:', eventName, properties);
    
    // Example: Google Analytics 4
    // gtag('event', eventName, properties);
  }
  
  // Track button clicks
  document.querySelectorAll('a[href^="#"], button').forEach(element => {
    element.addEventListener('click', function() {
      const eventName = this.textContent.trim() || this.getAttribute('aria-label') || 'button_click';
      trackEvent(eventName, {
        element: this.tagName,
        href: this.href || null
      });
    });
  });
  
  // ===== ERROR HANDLING =====
  window.addEventListener('error', function(e) {
    console.error('JavaScript error:', e.error);
    // In production, you might want to send this to an error tracking service
  });
  
  // ===== SERVICE WORKER REGISTRATION =====
  if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
      navigator.serviceWorker.register('/sw.js')
        .then(function(registration) {
          console.log('ServiceWorker registration successful');
        })
        .catch(function(err) {
          console.log('ServiceWorker registration failed');
        });
    });
  }
  
  // ===== ENHANCED UX FEATURES =====
  
  // Add loading animation
  window.addEventListener('load', function() {
    document.body.classList.add('loaded');
    
    // Add entrance animations
    const heroElements = document.querySelectorAll('#hero > *');
    heroElements.forEach((element, index) => {
      element.style.opacity = '0';
      element.style.transform = 'translateY(30px)';
      setTimeout(() => {
        element.style.transition = 'all 0.8s ease-out';
        element.style.opacity = '1';
        element.style.transform = 'translateY(0)';
      }, index * 200);
    });
  });
  
  // Enhanced button interactions
  document.querySelectorAll('a[href^="#"], button').forEach(element => {
    element.addEventListener('mouseenter', function() {
      this.style.transform = 'scale(1.05)';
    });
    
    element.addEventListener('mouseleave', function() {
      this.style.transform = 'scale(1)';
    });
  });
  
  // Add ripple effect to buttons
  function createRipple(event) {
    const button = event.currentTarget;
    const circle = document.createElement('span');
    const diameter = Math.max(button.clientWidth, button.clientHeight);
    const radius = diameter / 2;
    
    circle.style.width = circle.style.height = `${diameter}px`;
    circle.style.left = `${event.clientX - button.offsetLeft - radius}px`;
    circle.style.top = `${event.clientY - button.offsetTop - radius}px`;
    circle.classList.add('ripple');
    
    const ripple = button.getElementsByClassName('ripple')[0];
    if (ripple) {
      ripple.remove();
    }
    
    button.appendChild(circle);
  }
  
  document.querySelectorAll('button, a[href^="#"]').forEach(button => {
    button.addEventListener('click', createRipple);
  });
  
  // ===== INITIALIZATION COMPLETE =====
  console.log('Artisan\'IA website initialized successfully');
  
});

// ===== UTILITY FUNCTIONS =====

// Check if element is in viewport
function isInViewport(element) {
  const rect = element.getBoundingClientRect();
  return (
    rect.top >= 0 &&
    rect.left >= 0 &&
    rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
    rect.right <= (window.innerWidth || document.documentElement.clientWidth)
  );
}

// Get element's position relative to viewport
function getElementPosition(element) {
  const rect = element.getBoundingClientRect();
  return {
    top: rect.top + window.scrollY,
    left: rect.left + window.scrollX,
    bottom: rect.bottom + window.scrollY,
    right: rect.right + window.scrollX
  };
}

// Format number with commas
function formatNumber(num) {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// Generate random ID
function generateId() {
  return Math.random().toString(36).substr(2, 9);
}

// Check if device is mobile
function isMobile() {
  return window.innerWidth <= 768;
}

// Check if user prefers reduced motion
function prefersReducedMotion() {
  return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
}

// Export functions for use in other scripts
window.ArtisanIA = {
  showNotification: showNotification,
  trackEvent: trackEvent,
  isInViewport: isInViewport,
  formatNumber: formatNumber,
  generateId: generateId,
  isMobile: isMobile,
  prefersReducedMotion: prefersReducedMotion
};