Map<String, String> defaultAuthenticatedHeader(String token) {
  return {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${token}',
  };
}

const String baseCvaultUrl = 'https://cvault-backend.herokuapp.com';

