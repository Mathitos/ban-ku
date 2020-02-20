# Disponible routes
---
## Auth Sign In

  get a jwt to use in authing other routes

  **auth required**
  false

  **request**

  `POST  /api/v1/sign_in`

  **body example**
  ```
    {
      "email": "backoffice@banku.com",
      "password": "password"
    }
  ```

  **response example**
  ```
    {
      "jwt": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJCYW5LdSIsImV4cCI6MTU4NDU2NzgyNCwiaWF0IjoxNTgyMTQ4NjI0LCJpc3MiOiJCYW5LdSIsImp0aSI6ImI2ZWU3ZmNmLTZiOWMtNDgxOS1iNWIwLWJhOWZjOTgxMTgyZiIsIm5iZiI6MTU4MjE0ODYyMywic3ViIjoiMmEyYmUzNDEtYjQ5ZC00ZDY4LWFjN2UtN2M5ZDFlMDRlYTc4IiwidHlwIjoiYWNjZXNzIn0._NPHShJUTvbLmIVBBWFcb8To16tnxHoMjhQa83NwztYel8TAnwx4Ddal7lphvOP1mvI6I9D-tbK9vpmvNP7oxg"
    }
  ```

## List Accounts

  get a list of all accounts

  **auth required**
  true

  **request**

  `GET   /api/v1/accounts`

  **response example**
  ```
    {
      "data": [
          {
              "balance": 99600,
              "email": "matheus.c.anzzulin@hotmail.com",
              "id": "21b04d42-277b-4fe4-8b29-1c25527a2cc8",
              "owner_name": "matheus carvalho"
          },
          {
              "balance": 100000,
              "email": "matheus.c.anzzulin@gmail.com",
              "id": "0f57ed61-8947-4c20-97ab-bbc955a9a5f8",
              "owner_name": "matheus anzzulin"
          }
      ]
  }
  ```

## Get Account

  get a single account by id

  **auth required**
  true

  **request**

  `GET   /api/v1/accounts/:id`

  **response example**
  ```
    {
        "data": {
            "balance": 100000,
            "email": "matheus@oul.com.br",
            "id": "e71a068f-4764-4d99-96da-ff3553f54fff",
            "owner_name": "matheus carvalho"
        }
    }
  ```

## Create Account

  create an account

  **auth required**
  true

  **request**

  `POST  /api/v1/accounts`

  **body example**
  ```
    {
        "owner_name": "matheus carvalho",
        "email": "matheus@oul.com.br"
    }
  ```

  **response example**
  ```
    {
        "data": {
            "balance": 100000,
            "email": "matheus@oul.com.br",
            "id": "e71a068f-4764-4d99-96da-ff3553f54fff",
            "owner_name": "matheus carvalho"
        }
    }
  ```

## Withdraw from Account

  create a withdraw transaction from account

  **auth required**
  true

  **request**

  `POST  /api/v1/withdraw`

  **body example**
  ```
    {
        "account_id": "e71a068f-4764-4d99-96da-ff3553f54fff",
        "amount": 100
    }
  ```

  **response example**
  ```
    {
        "data": {
            "balance": 99900,
            "email": "matheus@oul.com.br",
            "id": "e71a068f-4764-4d99-96da-ff3553f54fff",
            "owner_name": "matheus carvalho"
        }
    }
  ```

## Transfer

  create a transfer transaction between two accounts

  **auth required**
  true

  **request**

  `POST  /api/v1/transfer`

  **body example**
  ```
    {
        "account_origin_id": "0f57ed61-8947-4c20-97ab-bbc955a9a5f8",
        "account_dest_id": "21b04d42-277b-4fe4-8b29-1c25527a2cc8",
        "amount": 200
    }
  ```

  **response example**
  ```
    {
        "data": {
            "account_dest_id": "21b04d42-277b-4fe4-8b29-1c25527a2cc8",
            "account_origin_id": "0f57ed61-8947-4c20-97ab-bbc955a9a5f8",
            "amount": 200,
            "date": "2020-02-20T02:44:04Z",
            "id": "17ed93f4-c0ec-426a-b690-0100e3b0eb0e",
            "operator_id": "2a2be341-b49d-4d68-ac7e-7c9d1e04ea78"
        }
    }
  ```

## List all Transactions

  get

  **auth required**
  true

  **request**

  `GET   /api/v1/transactions`

  **response example**
  ```
    {
        "data": [
            {
                "account_dest_id": null,
                "account_origin_id": "21b04d42-277b-4fe4-8b29-1c25527a2cc8",
                "amount": -100,
                "date": "2020-02-19T23:25:31Z",
                "id": "02483c7e-b7cc-41db-8d99-394e17d1851b",
                "operator_id": "2a2be341-b49d-4d68-ac7e-7c9d1e04ea78"
            }
        ]
    }
  ```

## Get Report

  get backoffice report

  **auth required**
  true

  **request**

  `GET   /api/v1/report`

  **response example**
  ```
    {
        "day_amount": 100,
        "month_amount": 200,
        "total_amount": 200,
        "year_amount": 200
    }
  ```
