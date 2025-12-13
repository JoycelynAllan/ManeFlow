// Main JavaScript for ManeFlow

document.addEventListener('DOMContentLoaded', function () {
    // Mobile menu toggle
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');

    if (hamburger && navMenu) {
        hamburger.addEventListener('click', function () {
            navMenu.classList.toggle('active');
            hamburger.classList.toggle('active');
        });

        // Close menu when clicking outside
        document.addEventListener('click', function (e) {
            if (!hamburger.contains(e.target) && !navMenu.contains(e.target)) {
                navMenu.classList.remove('active');
                hamburger.classList.remove('active');
            }
        });

        // Handle dropdown toggles on mobile
        const dropdownToggles = document.querySelectorAll('.dropdown-toggle');
        dropdownToggles.forEach(toggle => {
            toggle.addEventListener('click', function (e) {
                if (window.innerWidth <= 768) {
                    e.preventDefault();
                    e.stopPropagation();
                    const dropdown = this.closest('.nav-dropdown');
                    const isActive = dropdown.classList.contains('active');

                    // Close all other dropdowns
                    document.querySelectorAll('.nav-dropdown').forEach(d => {
                        if (d !== dropdown) {
                            d.classList.remove('active');
                        }
                    });

                    // Toggle current dropdown
                    dropdown.classList.toggle('active', !isActive);
                }
            });
        });

        // Close dropdowns when clicking outside on desktop
        if (window.innerWidth > 768) {
            document.addEventListener('click', function (e) {
                if (!e.target.closest('.nav-dropdown')) {
                    document.querySelectorAll('.nav-dropdown').forEach(dropdown => {
                        dropdown.classList.remove('active');
                    });
                }
            });
        }
    }

    // Form validation
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function (e) {
            // Basic validation
            const requiredFields = form.querySelectorAll('[required]');
            let isValid = true;

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = '#DC3545';
                } else {
                    field.style.borderColor = '';
                }
            });

            // Password confirmation check
            const password = form.querySelector('#password');
            const confirmPassword = form.querySelector('#confirm_password');

            if (password && confirmPassword) {
                if (password.value !== confirmPassword.value) {
                    isValid = false;
                    confirmPassword.style.borderColor = '#DC3545';
                    alert('Passwords do not match!');
                }
            }

            if (!isValid) {
                e.preventDefault();
            }
        });
    });

    // Concern checkboxes with severity selection
    const concernCheckboxes = document.querySelectorAll('.concern-checkbox');
    concernCheckboxes.forEach(checkbox => {
        const concernItem = checkbox.closest('.concern-item');
        const severitySelect = concernItem.querySelector('.severity-select');

        checkbox.addEventListener('change', function () {
            if (this.checked) {
                severitySelect.style.display = 'block';
                this.value = severitySelect.value;
            } else {
                severitySelect.style.display = 'none';
                severitySelect.value = 'mild';
            }
        });

        // Update checkbox value when severity changes
        if (severitySelect) {
            severitySelect.addEventListener('change', function () {
                if (checkbox.checked) {
                    checkbox.value = this.value;
                }
            });
        }

        // Initialize visibility
        if (!checkbox.checked && severitySelect) {
            severitySelect.style.display = 'none';
        }
    });

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        if (alert.classList.contains('alert-success') || alert.classList.contains('alert-error')) {
            setTimeout(() => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s';
                setTimeout(() => {
                    alert.remove();
                }, 500);
            }, 5000);
        }
    });

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href !== '#' && href.length > 1) {
                const target = document.querySelector(href);
                if (target) {
                    e.preventDefault();
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });

    // Loading states for buttons
    const submitButtons = document.querySelectorAll('form button[type="submit"]');
    submitButtons.forEach(button => {
        button.closest('form').addEventListener('submit', function () {
            button.disabled = true;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
        });
    });
    // Notification badge logic
    window.updateNotificationBadge = function (count) {
        const badge = document.getElementById('nav-notification-badge');
        if (!badge) return;

        if (count > 0) {
            badge.textContent = count > 99 ? '99+' : count;
            badge.style.display = 'block'; // Make sure this matches the inline style override
        } else {
            badge.style.display = 'none';
        }
    };

    function fetchNotificationCount() {
        if (!document.getElementById('nav-notification-badge')) return;

        fetch('api/get_notifications.php?limit=1')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.updateNotificationBadge(data.unread_count);
                }
            })
            .catch(e => console.log('Notification check failed', e));
    }

    // Check on load and every 60 seconds
    fetchNotificationCount();
    setInterval(fetchNotificationCount, 60000);
});

// AJAX helper function
function makeAjaxRequest(url, method = 'GET', data = null) {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open(method, url, true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

        xhr.onload = function () {
            if (xhr.status >= 200 && xhr.status < 300) {
                try {
                    const response = JSON.parse(xhr.responseText);
                    resolve(response);
                } catch (e) {
                    resolve(xhr.responseText);
                }
            } else {
                reject(new Error('Request failed with status: ' + xhr.status));
            }
        };

        xhr.onerror = function () {
            reject(new Error('Network error'));
        };

        if (data) {
            const formData = new URLSearchParams(data).toString();
            xhr.send(formData);
        } else {
            xhr.send();
        }
    });
}

// Export for use in other scripts
window.ManeFlow = {
    makeAjaxRequest: makeAjaxRequest
};

