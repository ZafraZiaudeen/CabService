document.addEventListener("DOMContentLoaded", () => {
  // Form validation
  const form = document.getElementById("registrationForm")
  if (form) {
    // Password strength meter
    const passwordInput = document.getElementById("password")
    if (passwordInput) {
      passwordInput.addEventListener("input", function () {
        updatePasswordStrength(this.value)
      })
    }

    // Form submission
    form.addEventListener("submit", (event) => {
      if (!validateForm()) {
        event.preventDefault()
      }
    })
  }
})

// Toggle password visibility
function togglePasswordVisibility() {
  const passwordInput = document.getElementById("password")
  const icon = document.querySelector(".toggle-password .material-icons")

  if (passwordInput.type === "password") {
    passwordInput.type = "text"
    icon.textContent = "visibility"
  } else {
    passwordInput.type = "password"
    icon.textContent = "visibility_off"
  }
}

// Update password strength meter
function updatePasswordStrength(password) {
  const strengthMeter = document.getElementById("passwordStrength")
  const strengthText = document.getElementById("strengthText")

  strengthMeter.classList.remove("strength-weak", "strength-medium", "strength-good", "strength-strong")

  if (!password) {
      strengthText.textContent = "None"; 
      return;
    }

  let strength = 0
  if (password.length >= 8) strength += 1
  if (password.length >= 12) strength += 1
  if (/[0-9]/.test(password)) strength += 1
  if (/[a-z]/.test(password)) strength += 1
  if (/[A-Z]/.test(password)) strength += 1
  if (/[^a-zA-Z0-9]/.test(password)) strength += 1

  if (strength <= 2) {
    strengthText.textContent = "Weak"
    strengthMeter.classList.add("strength-weak")
  } else if (strength <= 4) {
    strengthText.textContent = "Medium"
    strengthMeter.classList.add("strength-medium")
  } else if (strength <= 5) {
    strengthText.textContent = "Good"
    strengthMeter.classList.add("strength-good")
  } else {
    strengthText.textContent = "Strong"
    strengthMeter.classList.add("strength-strong")
  }
}

// Validate form
function validateForm() {
  let isValid = true

  // Reset all error messages
  const errorElements = document.querySelectorAll(".error-message")
  errorElements.forEach((element) => {
    element.textContent = ""
  })

  // Validate name
  const name = document.getElementById("name")
  if (!name.value.trim()) {
    document.getElementById("nameError").textContent = "Name is required"
    isValid = false
  } else if (name.value.trim().length < 3) {
    document.getElementById("nameError").textContent = "Name must be at least 3 characters"
    isValid = false
  }

  // Validate username
  const username = document.getElementById("username")
  if (!username.value.trim()) {
    document.getElementById("usernameError").textContent = "Username is required"
    isValid = false
  } else if (username.value.trim().length < 4) {
    document.getElementById("usernameError").textContent = "Username must be at least 4 characters"
    isValid = false
  }

  // Validate email
  const email = document.getElementById("email")
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!email.value.trim()) {
    document.getElementById("emailError").textContent = "Email is required"
    isValid = false
  } else if (!emailRegex.test(email.value.trim())) {
    document.getElementById("emailError").textContent = "Please enter a valid email address"
    isValid = false
  }

  // Validate phone
  const phone = document.getElementById("phone")
  const phoneRegex = /^\+?[0-9]{10,15}$/
  if (!phone.value.trim()) {
    document.getElementById("phoneError").textContent = "Phone number is required"
    isValid = false
  } else if (!phoneRegex.test(phone.value.replace(/\s+/g, ""))) {
    document.getElementById("phoneError").textContent = "Please enter a valid phone number"
    isValid = false
  }

  // Validate address
  const address = document.getElementById("address")
  if (!address.value.trim()) {
    document.getElementById("addressError").textContent = "Address is required"
    isValid = false
  }

  // Validate NIC
  const nic = document.getElementById("nic")
  if (!nic.value.trim()) {
    document.getElementById("nicError").textContent = "NIC is required"
    isValid = false
  }

  // Validate password
  const password = document.getElementById("password")
  if (!password.value) {
    document.getElementById("passwordError").textContent = "Password is required"
    isValid = false
  } else if (password.value.length < 6) {
    document.getElementById("passwordError").textContent = "Password must be at least 6 characters"
    isValid = false
  }

  return isValid
}

