document.addEventListener("DOMContentLoaded", () => {
  // Initialize map
  const map = L.map("map").setView([20.5937, 78.9629], 5); // India center
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: "© OpenStreetMap contributors",
  }).addTo(map);

  // Variables
  let pickupMarker = null;
  let dropoffMarker = null;
  let routeLine = null;
  let currentVehicleRate = 0;

  // DOM Elements
  const pickupInput = document.getElementById("pickup");
  const dropoffInput = document.getElementById("dropoff");
  const distanceValue = document.getElementById("distance-value");
  const fareValue = document.getElementById("fare-value");
  const distanceField = document.getElementById("distance");
  const vehicleSelect = document.getElementById("vehicle");
  const useLocationBtn = document.getElementById("useMyLocation");

  // Initialize Select2
  $(vehicleSelect).select2({
    placeholder: "Select a vehicle",
    allowClear: true,
    width: "100%",
  });

  // Vehicle selection change handler
  vehicleSelect.addEventListener("change", function () {
    const selectedOption = this.options[this.selectedIndex];
    if (selectedOption) {
      const rateMatch = selectedOption.text.match(/₹(\d+(\.\d+)?)/);
      if (rateMatch) {
        currentVehicleRate = Number.parseFloat(rateMatch[1]);
        updateFareEstimate();
      }
    }
  });

  // Use current location
  useLocationBtn.addEventListener("click", () => {
    if (!navigator.geolocation) {
      alert("Geolocation is not supported by your browser");
      return;
    }

    useLocationBtn.disabled = true;
    useLocationBtn.innerHTML = '<span class="material-icons">sync</span> Getting location...';

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords;
        reverseGeocode(latitude, longitude, true);
        useLocationBtn.disabled = false;
        useLocationBtn.innerHTML = '<span class="material-icons">my_location</span> Use my location';
      },
      (error) => {
        alert("Unable to retrieve your location");
        useLocationBtn.disabled = false;
        useLocationBtn.innerHTML = '<span class="material-icons">my_location</span> Use my location';
      }
    );
  });

  // Map click handler
  map.on("click", (e) => {
    const { lat, lng } = e.latlng;
    if (!pickupMarker) {
      reverseGeocode(lat, lng, true);
    } else if (!dropoffMarker) {
      reverseGeocode(lat, lng, false);
    }
  });

  // Search location on input
  function setupLocationSearch(input, isPickup) {
    let timeout = null;
    input.addEventListener("input", function () {
      clearTimeout(timeout);
      timeout = setTimeout(() => {
        const query = this.value;
        if (query.length > 3) {
          searchLocation(query, isPickup);
        }
      }, 500);
    });
  }

  setupLocationSearch(pickupInput, true);
  setupLocationSearch(dropoffInput, false);

  // Search location using Nominatim
  function searchLocation(query, isPickup) {
    fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}`)
      .then((response) => response.json())
      .then((data) => {
        if (data.length > 0) {
          const { lat, lon } = data[0];
          placeMarker(Number.parseFloat(lat), Number.parseFloat(lon), isPickup);
          map.setView([lat, lon], 15);
        }
      })
      .catch((error) => console.error("Error searching location:", error));
  }

  // Reverse geocoding
  function reverseGeocode(lat, lng, isPickup) {
    fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}`)
      .then((response) => response.json())
      .then((data) => {
        const address = data.display_name;
        if (isPickup) {
          pickupInput.value = address;
          placeMarker(lat, lng, true);
        } else {
          dropoffInput.value = address;
          placeMarker(lat, lng, false);
        }
      })
      .catch((error) => console.error("Error reverse geocoding:", error));
  }

  // Place marker on map
  function placeMarker(lat, lng, isPickup) {
    const markerOptions = {
      draggable: true,
      icon: isPickup
        ? L.icon({ iconUrl: "/images/pickup-marker.png", iconSize: [25, 41], iconAnchor: [12, 41] })
        : L.icon({ iconUrl: "/images/dropoff-marker.png", iconSize: [25, 41], iconAnchor: [12, 41] }),
    };

    if (isPickup) {
      if (pickupMarker) map.removeLayer(pickupMarker);
      pickupMarker = L.marker([lat, lng], markerOptions).addTo(map);
      pickupMarker.on("dragend", (e) => {
        const { lat, lng } = e.target.getLatLng();
        reverseGeocode(lat, lng, true);
      });
    } else {
      if (dropoffMarker) map.removeLayer(dropoffMarker);
      dropoffMarker = L.marker([lat, lng], markerOptions).addTo(map);
      dropoffMarker.on("dragend", (e) => {
        const { lat, lng } = e.target.getLatLng();
        reverseGeocode(lat, lng, false);
      });
    }

    updateRoute();
  }

  // Update route line and calculations
  function updateRoute() {
    if (pickupMarker && dropoffMarker) {
      const pickup = pickupMarker.getLatLng();
      const dropoff = dropoffMarker.getLatLng();

      // Update route line
      if (routeLine) map.removeLayer(routeLine);
      routeLine = L.polyline([pickup, dropoff], {
        color: "#FFC107",
        weight: 4,
        opacity: 0.8,
      }).addTo(map);

      // Fit bounds
      const bounds = L.latLngBounds([pickup, dropoff]);
      map.fitBounds(bounds, { padding: [50, 50] });

      // Update distance
      const distance = pickup.distanceTo(dropoff) / 1000; // Convert to kilometers
      distanceValue.textContent = `${distance.toFixed(1)} km`;
      distanceField.value = distance.toFixed(1);

      updateFareEstimate();
    }
  }

  // Update fare estimate
  function updateFareEstimate() {
    const distance = Number.parseFloat(distanceField.value);
    if (distance > 0 && currentVehicleRate > 0) {
      const fare = distance * currentVehicleRate;
      fareValue.textContent = `Rs. ${fare.toFixed(2)}`;
    }
  }

  // Form validation
  document.getElementById("booking-form").addEventListener("submit", (e) => {
    if (!pickupMarker || !dropoffMarker) {
      e.preventDefault();
      alert("Please select both pickup and drop-off locations");
      return;
    }

    if (!vehicleSelect.value) {
      e.preventDefault();
      alert("Please select a vehicle");
      return;
    }

    const distance = Number.parseFloat(distanceField.value);
    if (distance === 0) {
      e.preventDefault();
      alert("Invalid route distance");
      return;
    }
  });

  // Force map to resize after a short delay
  setTimeout(() => {
    map.invalidateSize();
  }, 500);
});