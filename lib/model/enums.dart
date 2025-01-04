enum TokenType { oAuthToken, personalAccessToken }

enum InitialRoute { login, home }

enum WhatWentWrongAtLogin {
  loginFailed,
  unexpectedResponse,
}

enum APIMethod {
  get,
  post,
  put,
  delete,
}

enum AccountType {
  all,
  asset,
  cash,
  expense,
  revenue,
  special,
  hidden,
  liability,
  liabilities,
}
