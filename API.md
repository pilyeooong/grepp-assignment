## API docs

**아래 API들을 실행하기 위해선 [README.md](README.md)에 기재된 순서에 따라 DB 셋업이 완료되어야만 합니다.**

Postman을 사용하신다면 프로젝트 내에 첨부된 `Grepp assignment.postman_collection.json`을 import를 통해 빠르게 API 테스트가 가능합니다.

로그인 API를 통해 토큰을 발급 받으시거나 사전에 발급된 아래 토큰을 활용하여도 테스트 가능합니다.
```bash
어드민
eyJhbGciOiJIUzUxMiJ9.eyJkYXRhIjp7InVzZXJfaWQiOjEsIm5pY2tuYW1lIjoi7Ja065Oc66-8In0sImV4cCI6MTc0Mjc5MzQ1NSwiaWF0IjoxNzM1MDE3NDU1LCJpc3MiOiJncmVwcCJ9.OSWar_qBhzf90KiqWelrToZcrTZu-3JA8SJo5wXkkilATPVdl9aGm9speL6bBwU--Su7kH4y865P-TiBV1oReA

일반 사용자
eyJhbGciOiJIUzUxMiJ9.eyJkYXRhIjp7InVzZXJfaWQiOjYsIm5pY2tuYW1lIjoi7YWM7Iqk7YSwNCJ9LCJleHAiOjE3NDI3OTM2NjcsImlhdCI6MTczNTAxNzY2NywiaXNzIjoiZ3JlcHAifQ.RPP1ZN3S7QGRBJ_MBMqcnX3XFavgySxjTO1Z6KiBRNsfFWidi4y7eGVB-FkRK-hgJS7nGZS7YJCgQOa40Nu12Q
```

### # 회원가입
**Endpoint**: /users

**Method**: POST

**Request Body**
- email (string)
- password (string)
- nickname (string)

**Request example**
```http request
POST http://localhost:3000/users
```

### # 로그인
**Endpoint**: /users/login

**Method**: POST

**Request body**
- email (string)
- password (string)

**Request example**
```http request
POST http://localhost:3000/users/login
```


### # 시험 일정
**Endpoint**: /exam_schedules

**Method**: GET

**Request query parameters**
- page (optional)
    - ex) 1
- limit (optional)
    - ex) 30

**Request example**
```http request
GET http://localhost:3000/exam_schedules?page=1&limit=30
```

### # 시험 일정 디테일
**Endpoint**: /exam_schedules/:id

**Method**: GET

**Request example**
```http request
GET http://localhost:3000/exam_schedules/1
```

### # 전체 유저 예약 조회
해당 동작은 어드민만 가능

**Endpoint**: /exam_reservations

**Method**: GET

**Request query parameters**
- page (optional)
    - ex) 1
- limit (optional)
    - ex) 30

**Request headers**
- `Authorization`
    - `Bearer token`



**Request example**
```http request
GET http://localhost:3000/exam_reservations?page=1&limit=30
```

### # 내 예약 조회
본인의 모든 예약 조회

**Endpoint**: /exam_reservations/my

**Method**: GET

**Request query parameters**
- page (optional)
    - ex) 1
- limit (optional)
    - ex) 30
- is_confirmed (optional)
    - ex) true, false

**Request headers**
- `Authorization`
    - `Bearer token`

**Request example**
```http request
GET http://localhost:3000/exam_reservations/my?page=1&limit=30
```

### # 예약 상세 조회

**Endpoint**: /exam_reservations/:id

**Method**: GET

**Request example**
```http request
GET http://localhost:3000/exam_reservations/1
```

### # 예약 신청

**Endpoint**: /exam_reservations/:id

**Method**: POST

**Request headers**
- `Authorization`
    - `Bearer token`

**Request example**
```http request
POST http://localhost:3000/exam_reservations/1
```


### # 예약 수정

**Endpoint**: /exam_reservations/:id

**Method**: PATCH

**Request headers**
- `Authorization`
    - `Bearer token`
    
**Request body**
- exam_scehdule_id (string)

**Request example**
```http request
PATCH http://localhost:3000/exam_reservations/1
```

### # 예약 삭제

**Endpoint**: /exam_reservations/:id

**Method**: DELETE

**Request headers**
- `Authorization`
    - `Bearer token`

**Request example**
```http request
DELETE http://localhost:3000/exam_reservations/1
```

### # 예약 확정

**Endpoint**: /exam_reservations/:id/confirm

**Method**: POST

**Request headers**
- `Authorization`
    - `Bearer token`

**Request example**
```http request
POST http://localhost:3000/exam_reservations/1/confirm
```
