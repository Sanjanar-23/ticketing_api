// Sidebar Toggle Functionality
function toggleSidebar() {
  const sidebar = document.getElementById('sidebar');
  const mainContent = document.getElementById('main-content');
  const overlay = document.getElementById('sidebar-overlay');

  if (sidebar.classList.contains('active')) {
    // Close sidebar
    sidebar.classList.remove('active');
    mainContent.classList.remove('sidebar-open');
    if (overlay) {
      overlay.classList.remove('active');
    }
  } else {
    // Open sidebar
    sidebar.classList.add('active');
    mainContent.classList.add('sidebar-open');
    if (overlay) {
      overlay.classList.add('active');
    }
  }
}

// Close sidebar when clicking outside (mobile)
function closeSidebarOnOverlayClick() {
  const overlay = document.getElementById('sidebar-overlay');
  if (overlay) {
    overlay.addEventListener('click', function() {
      toggleSidebar();
    });
  }
}

// Close sidebar on escape key
function closeSidebarOnEscape() {
  document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
      const sidebar = document.getElementById('sidebar');
      if (sidebar.classList.contains('active')) {
        toggleSidebar();
      }
    }
  });
}

// Set active navigation link
function setActiveNavLink() {
  const currentPath = window.location.pathname;
  const sidebarLinks = document.querySelectorAll('.sidebar-link');

  sidebarLinks.forEach(link => {
    const href = link.getAttribute('href');
    if (href === currentPath || (currentPath === '/' && href === '/')) {
      link.classList.add('active');
    } else {
      link.classList.remove('active');
    }
  });
}

// Initialize sidebar functionality when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  // Set active navigation link
  setActiveNavLink();

  // Add overlay for mobile
  if (window.innerWidth <= 768) {
    const overlay = document.createElement('div');
    overlay.id = 'sidebar-overlay';
    overlay.className = 'sidebar-overlay';
    document.body.appendChild(overlay);
    closeSidebarOnOverlayClick();
  }

  // Close sidebar on escape key
  closeSidebarOnEscape();

  // Handle window resize
  window.addEventListener('resize', function() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('main-content');
    const overlay = document.getElementById('sidebar-overlay');

    if (window.innerWidth > 768) {
      // Desktop: remove overlay if exists
      if (overlay) {
        overlay.remove();
      }
    } else {
      // Mobile: add overlay if doesn't exist
      if (!overlay && sidebar.classList.contains('active')) {
        const newOverlay = document.createElement('div');
        newOverlay.id = 'sidebar-overlay';
        newOverlay.className = 'sidebar-overlay active';
        document.body.appendChild(newOverlay);
        closeSidebarOnOverlayClick();
      }
    }
  });
});
