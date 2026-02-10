📌 프로젝트 개요
사용자가 이미지를 업로드하면 AWS의 서버레스 아키텍처를 통해 실시간으로 딥러닝 모델(CNN)이 분석 결과를 반환하는 엔드 투 엔드 이미지 분류 서비스입니다.

🛠 Tech Stack

Framework: FastAPI, PyTorch (CNN)

Infrastructure: Terraform (IaC)

AWS Services: ECS Fargate, Lambda, S3, ECR, CloudFront

DevOps: Docker


🏗 System Architecture

이 프로젝트는 높은 확장성과 비용 효율성을 위해 다음과 같은 구조로 설계되었습니다.

Frontend/API Layer: FastAPI가 ECS Fargate 위에서 실행되며, 사용자로부터 이미지를 전달받습니다.

Storage Layer: 업로드된 이미지는 S3 버킷에 안전하게 저장됩니다.

Compute Layer (Inference): 이미지가 S3에 저장되면 Lambda 함수가 트리거되어, S3에 저장된 CNN_model.pt 모델을 로드하고 추론을 수행합니다.

Delivery Layer: CloudFront를 통해 전 세계 어디서든 빠른 API 접근 및 보안(HTTPS)을 제공합니다.


📂 주요 파일 설명

main.py: FastAPI를 활용한 메인 API 서버 로직. S3 업로드 및 Lambda 호출을 관리합니다.

lambda_function.py: PyTorch 모델을 로드하여 실제 이미지 분류(Blood Cell Classification)를 수행하는 서버리스 로직입니다.

terraform (*.tf):

  ecs.tf: Fargate를 이용한 컨테이너 기반 API 서버 구축.

  s3.tf: 이미지 저장용 버킷 및 이벤트 트리거 설정.

  cloudfront.tf: CDN 및 SSL 인증서 적용을 통한 보안 강화.

Dockerfile: 애플리케이션 환경을 컨테이너화하여 일관된 배포 환경을 보장합니다.


✨ 핵심 경험 
IaC(Infrastructure as Code) 도입: Terraform을 사용하여 복잡한 AWS 리소스를 코드로 관리하고 재사용성을 높였습니다.

서버리스 아키텍처 설계: Lambda를 활용해 추론 시에만 비용이 발생하도록 설계하여 운영 비용을 최적화했습니다.

딥러닝 모델 배포: PyTorch로 학습된 .pt 모델을 클라우드 환경에 최적화하여 배포하는 파이프라인을 구축했습니다.


