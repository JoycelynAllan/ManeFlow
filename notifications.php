<?php
require_once 'includes/header.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}
?>

<div class="container mt-5 mb-5">
    <div class="row">
        <div class="col-md-8 offset-md-2">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Your Notifications</h2>
                <button id="markAllReadBtn" class="btn btn-outline-primary btn-sm">Mark All as Read</button>
            </div>
            
            <div id="notificationsList" class="list-group">
                <!-- Notifications will be loaded here -->
                <div class="text-center py-4">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
            
            <div id="emptyState" class="text-center py-5 d-none">
                <i class="fas fa-bell-slash fa-3x text-muted mb-3"></i>
                <p class="text-muted">No notifications yet.</p>
            </div>
        </div>
    </div>
</div>

<style>
    .notification-item {
        cursor: pointer;
        transition: background-color 0.2s;
        border-left: 4px solid transparent;
    }
    .notification-item.unread {
        background-color: #f8f9fa;
        border-left-color: #0d6efd;
    }
    .notification-item:hover {
        background-color: #f1f3f5;
    }
    .notification-meta {
        font-size: 0.85rem;
        color: #6c757d;
    }
    .notification-icon {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        margin-right: 15px;
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    loadNotifications();
    
    document.getElementById('markAllReadBtn').addEventListener('click', function() {
        markAsRead(null, true);
    });
});

function loadNotifications() {
    fetch('api/get_notifications.php')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                renderNotifications(data.notifications);
                if (window.updateNotificationBadge) {
                    window.updateNotificationBadge(data.unread_count);
                }
            }
        })
        .catch(error => console.error('Error loading notifications:', error));
}

function renderNotifications(notifications) {
    const list = document.getElementById('notificationsList');
    const emptyState = document.getElementById('emptyState');
    
    list.innerHTML = '';
    
    if (notifications.length === 0) {
        list.classList.add('d-none');
        emptyState.classList.remove('d-none');
        return;
    }
    
    list.classList.remove('d-none');
    emptyState.classList.add('d-none');
    
    notifications.forEach(notification => {
        const item = document.createElement('div');
        item.className = `list-group-item list-group-item-action notification-item ${notification.is_read == 0 ? 'unread' : ''}`;
        item.onclick = (e) => handleNotificationClick(e, notification);
        
        const iconClass = getIconForType(notification.notification_type);
        const iconColor = getColorForType(notification.notification_type);
        
        item.innerHTML = `
            <div class="d-flex w-100 align-items-center">
                <div class="notification-icon" style="background-color: ${iconColor}20; color: ${iconColor};">
                    <i class="${iconClass}"></i>
                </div>
                <div class="flex-grow-1">
                    <div class="d-flex w-100 justify-content-between">
                        <h6 class="mb-1 ${notification.is_read == 0 ? 'fw-bold' : ''}">${escapeHtml(notification.title)}</h6>
                        <small class="notification-meta">${formatDate(notification.created_at)}</small>
                    </div>
                    <p class="mb-1 text-secondary small">${escapeHtml(notification.message)}</p>
                </div>
                ${notification.is_read == 0 ? '<span class="badge bg-primary rounded-pill ms-2" title="Unread">•</span>' : ''}
            </div>
        `;
        
        list.appendChild(item);
    });
}

function handleNotificationClick(event, notification) {
    // If clicking a link/button within the item, let it propagate if needed, 
    // but here we just have the whole item clickable.
    
    if (notification.is_read == 0) {
        markAsRead(notification.notification_id, false, () => {
            if (notification.action_url) {
                window.location.href = notification.action_url;
            } else {
                // Just reload/update UI if no URL
                loadNotifications();
            }
        });
    } else if (notification.action_url) {
        window.location.href = notification.action_url;
    }
}

function markAsRead(id, all = false, callback = null) {
    const payload = all ? { mark_all: true } : { notification_id: id };
    
    fetch('api/mark_notification_read.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            if (callback) callback();
            else loadNotifications();
            
            // Update global badge
            if (window.updateNotificationBadge) {
                window.updateNotificationBadge(data.unread_count);
            }
        }
    })
    .catch(error => console.error('Error marking read:', error));
}

function getIconForType(type) {
    const map = {
        'routine_update': 'fas fa-calendar-check',
        'milestone_achieved': 'fas fa-trophy',
        'growth_forecast': 'fas fa-chart-line',
        'diagnosis_follow_up': 'fas fa-user-md',
        'style_reminder': 'fas fa-cut',
        'product_recommendation': 'fas fa-pump-soap',
        'general': 'fas fa-info-circle'
    };
    return map[type] || 'fas fa-bell';
}

function getColorForType(type) {
    const map = {
        'routine_update': '#0d6efd', // Blue
        'milestone_achieved': '#ffc107', // Yellow
        'growth_forecast': '#198754', // Green
        'diagnosis_follow_up': '#dc3545', // Red
        'style_reminder': '#6610f2', // Purple
        'product_recommendation': '#0dcaf0', // Cyan
        'general': '#6c757d' // Grey
    };
    return map[type] || '#6c757d';
}

function formatDate(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now - date;
    const diffSec = Math.round(diffMs / 1000);
    const diffMin = Math.round(diffSec / 60);
    const diffHr = Math.round(diffMin / 60);
    const diffDay = Math.round(diffHr / 24);
    
    if (diffSec < 60) return 'Just now';
    if (diffMin < 60) return `${diffMin}m ago`;
    if (diffHr < 24) return `${diffHr}h ago`;
    if (diffDay < 7) return `${diffDay}d ago`;
    return date.toLocaleDateString();
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
</script>

<?php require_once 'includes/footer.php'; ?>
