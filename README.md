# AWS Serverless Architecture

## 프로젝트 개요
혈액세포 이미지를 업로드하면 AI가 자동으로 세포 유형을 분류해주는 서버리스 웹 애플리케이션입니다. 

AWS의 다양한 관리형 서비스를 활용하여 확장 가능하고 비용 효율적인 인프라를 구축했습니다.

## architecture structure

<img width="614" height="428" alt="image" src="https://github.com/user-attachments/assets/16677577-b529-490e-9f3f-34d849befe1b" />

흐름: 사용자 → CloudFront → ECS(FastAPI) → S3 업로드 → Lambda 호출 → 결과 반환 → CloudFront → 사용자

## 
