Rails.configuration.stripe = {
  publishable_key: ENV["pk_test_51OGeANIx2teejUQGb9AZbKIXvsMXN0TGZyQERRhzYQAhBL284p6gcB8o6nkN45BmNsXnjnb6kbqmOLXT5iB23zK400YWSoY1O7"],
  secret_key:      ENV["sk_test_51OGeANIx2teejUQGJ222hO3mEKcNw1zTOEoKAYnnsUr1omNHIzuWrTyyDv2h5PibRLBLC1XO12pe7kgNiWIayaOd002gx4iZCI"]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
