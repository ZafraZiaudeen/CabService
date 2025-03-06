<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        .floating-help-icon {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: #FFC107;
            color: white;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .floating-help-icon:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
            background: #FFA000
        }

        .floating-help-icon:active {
            transform: translateY(-2px);
        }

        .floating-help-icon .material-icons {
            font-size: 24px;
        }

        /* Tooltip styles */
        .floating-help-icon::before {
            content: "Help Center";
            position: absolute;
            right: 70px;
            padding: 8px 12px;
            background: #333;
            color: white;
            font-size: 14px;
            border-radius: 4px;
            white-space: nowrap;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .floating-help-icon::after {
            content: "";
            position: absolute;
            right: 64px;
            width: 0;
            height: 0;
            border-top: 6px solid transparent;
            border-bottom: 6px solid transparent;
            border-left: 6px solid #333;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .floating-help-icon:hover::before,
        .floating-help-icon:hover::after {
            opacity: 1;
            visibility: visible;
        }

        @media (max-width: 768px) {
            .floating-help-icon {
                bottom: 20px;
                right: 20px;
                width: 48px;
                height: 48px;
            }

            .floating-help-icon .material-icons {
                font-size: 20px;
            }

            /* Hide tooltip on mobile */
            .floating-help-icon::before,
            .floating-help-icon::after {
                display: none;
            }
        }

        /* Animation for icon appearance */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .floating-help-icon {
            animation: fadeInUp 0.5s ease-out;
        }
    </style>
</head>
<body>
    <button class="floating-help-icon" id="helpIcon" onclick="navigateToHelp()">
        <span class="material-icons">help_outline</span>
    </button>

    <script>
        function navigateToHelp() {
            // Navigate to help section
          window.location.href = '<%= request.getContextPath() %>/help';
        }

        // Optional: Add scroll-based visibility
        window.addEventListener('scroll', function() {
            const helpIcon = document.getElementById('helpIcon');
            
            // Show icon after scrolling 100px
            if (window.scrollY > 100) {
                helpIcon.style.opacity = '1';
                helpIcon.style.pointerEvents = 'auto';
            } else {
                helpIcon.style.opacity = '0.7';
            }
        });

       
        document.addEventListener('keydown', function(event) {
            if (event.key === '?' && event.shiftKey) {
                navigateToHelp();
            }
        });
    </script>
</body>
</html>