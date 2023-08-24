import 'package:googleapis/vision/v1.dart';

import 'package:googleapis_auth/auth_io.dart';

final _credentials = new ServiceAccountCredentials.fromJson(r'''
  {
    "private_key_id": "be797546681d6972eb2e2788568886b1f5e149f1",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDXOL/iqGIp89L4\n5bj+THpFHL8lR28xkMNAfUL0nwrq1sdqOOtrNNkq5epVcOXCrnzxagBTERtuuWT9\nT5RpyTGsZLaEE7WlRpkzNBxz9NpZiReDdjTTjEo1hBCsDdxKMB6s3LKQqNCtAg3K\n262pFs7JCxDx+iaxY+4rvI7S48p6s3ao9OuLXytboL53a062peHlju2n7nvEl233\nKNQA4djmmPTFLvzbMqca7ZzqecqIp/ovOIBfwHCQ1wWSNQlGhz/p6IR57p8vmhiI\nQL0D9ALpq1BDxmM1ueSF1rDOVbowJDPL0fwuqpnyrs+US+WfLSDYFWwh4IZm/kPn\n9MtAQiYVAgMBAAECggEABpUJZqYzB7Nu+AZr56MbzjH4ipb/s0AJKKzBYnfcE/M+\nUA+uQNjHQi+b62xeKoZpndHZxrCW6oZTAghFXWLg2Qk6J8SZNpUifwAQqrSKBQOo\nq3BEYf/quRjxOuyFmI3rh5U3BNjqNjsCLvpppOqPUnNl25tZ7uzueM9LKESn3vlr\nC+62wLcLbwhPDDdpVU5W/9yaHF4845ZSXtn1mfIwKfCdBjx5N6VlrXZCRiizlI1B\nFKFi6rF9Yyq3tcsSEDlOyfBbaUgIkBZ/aMR2l9HggMyRlcvJ+1py4jSYVaamiM+Q\nPJmcEtc8vDAQW7B9jogfTK98LJts5aYlqByUiSpndQKBgQD/bTPjJU0TsPwQw8H7\nNvWc/qcuqda6NLz1Xj67JHSmZ2TWCrz6K0YWq20/pHu+1SDFtq/ONPa/5HCsq5Q+\nrY1o9lDxXOPnj2xCJxfkUwPCSPOJok4wgxW+Fe0s4EEPJY0Q8eaz7wY3oZe+7nfQ\nhLOhN2luz8cxcTxR60Qxy0cspwKBgQDXtHDHE8zY8dFp++TnGQpyAU9KYpEEjchs\nyDcOcUBEZ4SiASP0yuxEdUy2dL4BJy5xEag3X1C51AXukePzFz8xF7gZcHk3wlvM\nAAVg5KYht7LqeXHBTdADnOUPq5+8Lrk7cDn1eA5dBpxLuuEp9kjmbUT6M3Q02XCh\ns4RILBnC4wKBgQCuOy9JoggRhohqZx3K3pJrpMkla3StT4wVU1Q3E4b+e0itOGXv\nv9TvYcADyY8ffQH927/QSRCHlKvHHMLifkAXeO19tn8/VPXjqgcCGB5YSKrXF39+\nV+xc3VgLZGz8iADRrjBQTJtRF0kLVF8mPV7KeaHRlKmrcDJVLsY1sRO7wQKBgQDW\nNRCSAi25e1sVPtrwTEO9N2PAYOXWed6BeMqEAx9pTsu9/hfw7tt2mG4X+xL9HiXW\nj0xXwMXv5IgHhMW0EG/mlsFyMemO3+o9SgANWsNIVJ7Ojs/SwS1DiTlIOI0mWdgF\nGMvV4uWQqBHqeqlD/JokinqnZRWPridVzWoeKf1jNQKBgQCIdmjMZTZScfLpKRnV\ngKqUnyNwhzToAh+oPuJwfE5CXreYOQWrWq8QS+65xp6Ucal2eW6cv6tTA6ooNcMM\nUWt4dv93oVhR4woLq/URzOof0r1pQ2wqBtLXhsNFHp5XtUShzbz2JkkOFUlspvl5\nziEZHRYPWbPYBIbJ5V5Ek9JVLw==\n-----END PRIVATE KEY-----\n",
    "client_email": "teste-elesson@elesson-302819.iam.gserviceaccount.com",
    "client_id": "111096070744001961169",
    "type": "service_account"
  }
''');

Future<String> getGoogleApiToken() async {
  return await clientViaServiceAccount(_credentials, [VisionApi.cloudVisionScope]).then((httpClient) {
    // print(httpClient.credentials.accessToken.data);
    return "Bearer ${httpClient.credentials.accessToken.data}";
  });
}
