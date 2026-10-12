from fastapi.testclient import TestClient


def test_register_returns_created(client: TestClient) -> None:
    response = client.post("/auth/register", json={"email": "bob@example.com", "password": "password123"})
    assert response.status_code == 201
    assert response.json() == {"email": "bob@example.com"}


def test_register_rejects_duplicate_email(client: TestClient) -> None:
    payload = {"email": "bob@example.com", "password": "password123"}
    client.post("/auth/register", json=payload)
    response = client.post("/auth/register", json=payload)
    assert response.status_code == 409


def test_register_rejects_short_password(client: TestClient) -> None:
    response = client.post("/auth/register", json={"email": "bob@example.com", "password": "short"})
    assert response.status_code == 422


def test_login_returns_token(client: TestClient) -> None:
    client.post("/auth/register", json={"email": "bob@example.com", "password": "password123"})
    response = client.post("/auth/login", json={"email": "bob@example.com", "password": "password123"})
    assert response.status_code == 200
    assert response.json()["token_type"] == "bearer"
    assert response.json()["access_token"]


def test_login_rejects_wrong_password(client: TestClient) -> None:
    client.post("/auth/register", json={"email": "bob@example.com", "password": "password123"})
    response = client.post("/auth/login", json={"email": "bob@example.com", "password": "wrongpassword"})
    assert response.status_code == 401


def test_tasks_require_a_token(client: TestClient) -> None:
    response = client.get("/tasks")
    assert response.status_code == 401


def test_tasks_reject_invalid_token(client: TestClient) -> None:
    response = client.get("/tasks", headers={"Authorization": "Bearer not-a-token"})
    assert response.status_code == 401
