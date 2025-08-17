📱 Pill Check App

Flutter 기반 알약 인식 애플리케이션
카메라로 알약을 촬영하면 Flask 서버와 YOLOv5 모델이 성분을 인식하고, MariaDB에서 정보를 조회해 결과를 표시합니다.

📖 Overview

Client: Flutter (Dart) – Android/iOS/Web 대응

Server: Flask (Python) – REST API 제공

Model: YOLOv5 – 알약 이미지 인식

DB: MariaDB – 알약 메타데이터 관리

사진 촬영 → 서버 전송 → AI 추론 → DB 검색 → 결과 표시

✨ Features

📷 카메라로 알약 촬영

🤖 YOLOv5 기반 알약 인식 (색상, 모양, 성분 구분)

🗂️ MariaDB와 연동하여 알약 상세 정보 제공

📱 Flutter UI로 멀티플랫폼 지원 (Android/iOS/Web)

🔐 HTTPS 전송 및 사용자 데이터 최소화

🏗️ Architecture
flowchart LR
    A[Flutter App] -->|사진 전송| B[Flask API]
    B -->|이미지 처리| C[YOLOv5 모델]
    C -->|식별 결과| D[MariaDB]
    D -->|JSON 응답| A

🛠️ Tech Stack

Frontend: Flutter, Dart

Backend: Python, Flask, REST API

AI: PyTorch, YOLOv5

Database: MariaDB

DevOps: Docker, GitHub

🚀 How to Run
Client (Flutter)
git clone https://github.com/LJH032/pill_check_app.git
cd pill_check_app
flutter pub get
flutter run

Server (Flask)
git clone https://github.com/LJH032/pill_check_server.git
cd pill_check_server
pip install -r requirements.txt
python app.py

Database (MariaDB Docker)
docker run --name pill-db -e MYSQL_ROOT_PASSWORD=your_pw -p 3306:3306 -d mariadb

🎥 Demo

(여기에 앱 실행 GIF / 스크린샷 삽입)
예:


📊 Results

YOLOv5 mAP@0.5 : xx%

평균 응답 시간 : x.x 초

샘플 데이터 : 1,000+장

📌 Roadmap

 알약 데이터셋 확장

 다국어 지원 (한/영)

 오프라인 추론 기능 추가 (ONNX, TensorRT)

 UI/UX 개선
