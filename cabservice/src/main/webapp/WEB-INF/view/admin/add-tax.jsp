<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Tax/Discount - Cab Service</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="<c:url value='/css/adminAdd.css'/>">
</head>
<body>
    <!-- Include the sidebar -->
    <jsp:include page="Sidebar.jsp" />

    <main class="main-content" id="mainContent">
        <div class="page-header">
            <h1 class="page-title">Add Tax/Discount</h1>
        </div>

        <!-- Form for adding tax and discount -->
        <form class="section-form" id="taxDiscountForm" action="<%= request.getContextPath() %>/system-config?action=add" method="post">
            <div class="form-grid">
                <div class="form-field">
                    <label for="tax_rate">Tax Rate (%) *</label>
                    <input type="number" id="tax_rate" name="tax_rate" step="0.01" min="0" required>
                </div>

                <div class="form-field">
                    <label for="discount_rate">Discount Rate (%) *</label>
                    <input type="number" id="discount_rate" name="discount_rate" step="0.01" min="0" required>
                </div>

                <div class="form-buttons">
                    <button type="submit" class="form-button primary">
                        Save Tax/Discount
                    </button>
                    <button type="button" class="form-button secondary" onclick="window.location.href='<%= request.getContextPath() %>/system-config?action=view'">
                        Cancel
                    </button>
                </div>
            </div>
        </form>
    </main>

    <script>
        // Handle form submission
        function handleSubmit(event) {
            event.preventDefault();
            
            // Get form data
            const formData = {
                taxRate: document.getElementById('tax_rate').value,
                discountRate: document.getElementById('discount_rate').value
            };

            // Here you would typically make an API call to save the tax/discount
            console.log('Saving Tax/Discount:', formData);

            // Redirect back to tax/discount list
            window.location.href = '<%= request.getContextPath() %>/system-config?action=view';
        }

        // Handle sidebar toggle affecting main content
        document.addEventListener('DOMContentLoaded', function() {
            const mainContent = document.getElementById('mainContent');
            const sidebar = document.getElementById('sidebar');
            
            // Listen for sidebar toggle events
            document.getElementById('toggleBtn').addEventListener('click', function() {
                mainContent.classList.toggle('expanded');
            });

            // Handle responsive behavior
            function handleResize() {
                if (window.innerWidth <= 768) {
                    mainContent.classList.add('expanded');
                } else if (!sidebar.classList.contains('collapsed')) {
                    mainContent.classList.remove('expanded');
                }
            }

            handleResize();
            window.addEventListener('resize', handleResize);
        });
    </script>
</body>
</html>
