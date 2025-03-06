<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<div class="card booking-status-card">
    <div class="card-content">
        <h3>Booking Status</h3>
        <p>All time bookings</p>
        <div class="filter-container">
            <!-- Add filter options here if needed -->
        </div>
        <canvas id="bookingStatusChart" class="booking-status-canvas" width="200" height="200"></canvas>
        <div class="booking-status-legend" id="chartLegend"></div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Pie Chart Data (initial load with "All Time" data)
        const allTimeData = {
            pending: <%= request.getAttribute("pendingBookings") != null ? request.getAttribute("pendingBookings") : 0 %>,
            ongoing: <%= request.getAttribute("ongoingBookings") != null ? request.getAttribute("ongoingBookings") : 0 %>,
            completed: <%= request.getAttribute("completedBookings") != null ? request.getAttribute("completedBookings") : 0 %>,
            cancelled: <%= request.getAttribute("cancelledBookings") != null ? request.getAttribute("cancelledBookings") : 0 %>
        };

        // Placeholder for filtered data (to be fetched dynamically)
        let filteredData = {
            all: allTimeData,
            today: { pending: 0, ongoing: 0, completed: 0, cancelled: 0 },
            week: { pending: 0, ongoing: 0, completed: 0, cancelled: 0 },
            month: { pending: 0, ongoing: 0, completed: 0, cancelled: 0 }
        };

        // Pie Chart Drawing Function
        function drawPieChart(data) {
            const canvas = document.getElementById('bookingStatusChart');
            const ctx = canvas.getContext('2d');
            const legendContainer = document.getElementById('chartLegend');

            // Clear canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            const chartData = [data.pending, data.ongoing, data.completed, data.cancelled];
            const labels = ['Pending', 'Ongoing', 'Completed', 'Cancelled'];
            const colors = ['#fbd38d', '#63b3ed', '#68d391', '#f687b3'];

            const total = chartData.reduce((sum, value) => sum + value, 0) || 1;
            let startAngle = 0;
            const radius = 80;
            const centerX = canvas.width / 2;
            const centerY = canvas.height / 2;

            chartData.forEach((value, index) => {
                const sliceAngle = (value / total) * 2 * Math.PI;
                ctx.beginPath();
                ctx.arc(centerX, centerY, radius, startAngle, startAngle + sliceAngle);
                ctx.lineTo(centerX, centerY);
                ctx.fillStyle = colors[index];
                ctx.fill();
                ctx.lineWidth = 1;
                ctx.strokeStyle = '#ffffff';
                ctx.stroke();
                startAngle += sliceAngle;
            });

            // Generate legend
            legendContainer.innerHTML = '';
            labels.forEach((label, index) => {
                const legendItem = document.createElement('div');
                legendItem.className = 'legend-item';
                legendItem.innerHTML = `
                    <span class="legend-color" style="background-color: ${colors[index]};"></span>
                    ${label}: ${chartData[index]}
                `;
                legendContainer.appendChild(legendItem);
            });
        }

        // Initial Pie Chart Render
        drawPieChart(allTimeData);

        // Update Pie Chart on Filter Change
        window.updatePieChart = function() {
            const period = document.getElementById('timeFilter')?.value || 'all';
            if (filteredData[period].pending === 0 && filteredData[period].ongoing === 0 && 
                filteredData[period].completed === 0 && filteredData[period].cancelled === 0) {
              
                drawPieChart(filteredData[period]);
            } else {
                drawPieChart(filteredData[period]);
            }
        };
    });
</script>