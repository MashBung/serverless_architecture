# AWS Serverless Architecture

## 프로젝트 개요
혈액세포 이미지를 업로드하면 AI가 자동으로 세포 유형을 분류해주는 서버리스 웹 애플리케이션입니다. 

AWS의 다양한 관리형 서비스를 활용하여 확장 가능하고 비용 효율적인 인프라를 구축했습니다.

## architecture structure

<img width="614" height="428" alt="image" src="https://github.com/user-attachments/assets/16677577-b529-490e-9f3f-34d849befe1b" />

흐름: 사용자 → CloudFront → ECS(FastAPI) → S3 업로드 → Lambda 호출 → 결과 반환 → CloudFront → 사용자

## 기술 스택

### Frontend
- HTML5
- CSS3
- JavaScript (Vanilla JS)

### Backend
- Python 3.x
- FastAPI
- Jinja2 Templates

### AI/ML
- PyTorch
- torchvision
- PIL (Pillow)
- Custom CNN 모델 (Blood Cell Classification)

### AWS Services
- **Amazon ECS Fargate**: 컨테이너 실행 환경
- **Amazon ECR**: Docker 이미지 저장소
- **Amazon CloudFront**: CDN 및 전역 배포
- **Amazon S3**: 이미지 파일 저장소
- **AWS Lambda**: AI 모델 추론 서버리스 실행

### DevOps & Tools
- Docker
- Boto3 (AWS SDK for Python)
- python-dotenv

<img width="1629" height="926" alt="스크린샷 2026-02-06 004832" src="https://github.com/user-attachments/assets/6db705c2-bc08-4e8e-be67-c40a9c3d3b84" />

<img width="1618" height="928" alt="스크린샷 2026-02-06 005119" src="https://github.com/user-attachments/assets/3699cb02-0df0-4d77-8b9d-d0d129af6932" />
