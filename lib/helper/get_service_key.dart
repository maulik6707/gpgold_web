// import 'package:googleapis_auth/auth_io.dart';
//
// class GetServerKey {
//
//   Future<String> getServerKeyToken() async {
//
//     final scopes = [
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging"
//     ];
//
//     final client = await clientViaServiceAccount(
//         ServiceAccountCredentials.fromJson({
//           "type": "service_account",
//           "project_id": "gpgold-91ad9",
//           "private_key_id": "8c2abe29cbcce24d8fbb7e1f2dea5ca885b6c606",
//           "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC3frMSnbGr+Gwm\nKKf/LbiC7by1tiVnZqB//LUgab3LzIXHW1voUlu0ZZTaReYD9conbnYz11qx5bsh\n2vWifrdLXKizG5jnsITCc1Av9bEin300V8miD8F8wTM44bd3tgpLMPm0NCZMDFzB\nNuj0EXENrKGwJ0z78q3WzftKRd1mVjPJtXsKSlBiVCb0NVaty4UlQiR2u5Acw8t2\nSNfquj68eho+9hJhW9/fSl1y471PjDagYSAtEoQo1O8tVVAh0PzJWgmAWBWIBP0b\nmiESeUqYdhPxUO/Yb5vBYLsnr+1PvxJ1kkchaKgdPOkyRc1ZTZ62i88OAB/SJqkN\nJwPLR0XfAgMBAAECggEAP79UlvMR9pynddpKAuzvXQ0askZFWFbfC5fPlSMnPNYg\n49FpbJywH0vrGqmN73JEeM53Yis+5u7YxDo9e+Zp51SZhx/fTx6UALnu8bp5f33J\nEZYuBo9SuPSlxu0jwAMOMHEjTuePJnxk/PsGk0Q78nQ29+uvYxg8LJQC6Rq8gAB8\nBEAnYHmNm1dmA6D3e+++TdwrBVRLrdpCCh0RLvU+J62D76atXIrgrGop0p3/P085\n+u1k90hAKZVaFcTPQ+2MMFfhWxroWZ4c6k0jrg1P/uSK5s3hnoxZqSoDX2YOw/Fa\nvSpX5l9zHMPYc2PW1dbszsigt0m8AWQDuWScx+f1gQKBgQDaa1fFf8aIlrtwYVeF\nkY26JLW0iVWNkzVypttZAkg4hC9P2KbhKOYBM59srS9HdzCY3MvjiR7xjC9LZCko\nFj6m62D5pZj+LzFANbm5ZBP78HfmYcpaOEKBUzaAu3bOUQXNmLVdolg1eaJus4PA\nVGa+Qyql0vqSw2WYlyrg6k+Q1QKBgQDXEQ0pkg9n2krM7/odyIGAMKT737vPx+pH\nIXkP9BEW/EDyAoZGl7c0lODXQzA2MLTsRE9BoAZg8D1BbzvuYOF9pihbYSzK1oFz\nCy7dZBXQDFOzdbN3FSKTnzyd+3+pxEEcCq5CuDC5M/x3Wv/ScTpSQ6T9VeOxRc3H\noT9Zm6b14wKBgF7RLn8cIvF0jdYRS88+Cop+GStQWwVknFUzPhF7viJar7c30+n2\nuTJYWKLy441gnoYdg505D2fIdVeDGaK/VV9c2vJFAw+FKRo4uHFUkqBSGZq3ZQKZ\nXbWKjCSCPOb/oUdJPaJyMVy1euAXqeA6Q4fg3Iiz9/byQA5nwUN2NCgpAoGAQqBe\nsoU0Tpka2ThzBO0L6XmocvtSBMHLO3QMPDwBW1yUhiTwEkiIEjsZGLcQ5YjbU+Kp\npwv7Tea/I1lheKz8zl8+W2jUZpZjjg9l2mJaO5TGDW+mRHsAtjj7n3m9iAtrnFNW\nvwau2YFYcmV3oWtAhSG9qFoGavHUGUdEB++nnr8CgYEAlqAQqIbEOKE9R2dNuXjN\nwE34iWKqPl0bIPHRpgEq72aIXo2iEK+quPO+o5WFHlda3ZmRjkdSZkaA0s0bq6ii\n+ESMinePltdkU5cXMhiWY6dkavp0vFqi4AcaR5q8nDX2VY7n98++6Wn7mHfGYyOt\nfIYW8/E9drHnuPHHiB1HtLY=\n-----END PRIVATE KEY-----\n",
//           "client_email": "firebase-adminsdk-fbsvc@gpgold-91ad9.iam.gserviceaccount.com",
//           "client_id": "107660863239250720122",
//           "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//           "token_uri": "https://oauth2.googleapis.com/token",
//           "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//           "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40gpgold-91ad9.iam.gserviceaccount.com",
//           "universe_domain": "googleapis.com"
//         }),
//         scopes);
//
//     final accessServerKey = client.credentials.accessToken.data;
//
//
//     return accessServerKey;
//   }
// }