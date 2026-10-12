import pytest
from fastapi.testclient import TestClient

from app import main


@pytest.fixture()
def client() -> TestClient:
    main.users = main.UserStore()
    main.tasks = main.TaskStore()
    with TestClient(main.app) as test_client:
        yield test_client


@pytest.fixture()
def auth_headers(client: TestClient) -> dict:
    client.post("/auth/register", json={"email": "alice@example.com", "password": "password123"})
    response = client.post("/auth/login", json={"email": "alice@example.com", "password": "password123"})
    token = response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}
