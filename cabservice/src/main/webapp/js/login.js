document.addEventListener("DOMContentLoaded", () => {
  // Form validation
  const form = document.getElementById("loginForm")
  if (form) {
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

// Validate form
function validateForm() {
  let isValid = true

  // Reset all error messages
  const errorElements = document.querySelectorAll(".error-message")
  errorElements.forEach((element) => {
    element.textContent = ""
  })

  // Validate username
  const username = document.getElementById("username")
  if (!username.value.trim()) {
    document.getElementById("usernameError").textContent = "Username is required"
    isValid = false
  }

  // Validate password
  const password = document.getElementById("password")
  if (!password.value) {
    document.getElementById("passwordError").textContent = "Password is required"
    isValid = false
  }

  return isValid
}

