# Secret directory

- Store secrets
- File containing password are ignored by git (Check .gitignore)

## Secret files

- backend-jdld.json : Stores credentials for the *Terraform* backend files
  - Content sample ==>

    ```json
        {
            "tenant_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "subscription_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_secret": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        }
    ```

- main-jdld.json : Stores resource credentials
  - Content sample ==>

    ```json
        {
            "tenant_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "subscription_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_id": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_secret": "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        }
    ```
