/*resource "aws_ecr_repository" "test_repo"{
    name = "your-ecs"

    # 1. 이미지 태그 설정 (Mutable vs Immutable)
    # Mutable: 동일한 태그로 덮어쓰기 허용
    # Immutable: 동일한 태그로 덮어쓰기 방지 (보안 및 배포 일관성에 권장)

    # 2. 이미지 스캔 설정 (Push할 때 자동 스캔)
    # 보안 취약점을 자동으로 검사해주는 아주 유용한 옵션입니다.
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration{
        scan_on_push = true
    }

    # 3. 암호화 설정 (AES-256 vs AWS KMS)
    # 기본적으로 AES-256을 사용하지만, 명시적으로 적어줄 수 있습니다.
    encryption_configuration{
        encryption_type = "AES256"
    }
}

output "ecr_url" {
    value = aws_ecr_repository.test_repo.repository_url
}

resource "aws_ecr_repository" "fastapi_repo"{
    name = "your-ecs"

    # 1. 이미지 태그 설정 (Mutable vs Immutable)
    # Mutable: 동일한 태그로 덮어쓰기 허용
    # Immutable: 동일한 태그로 덮어쓰기 방지 (보안 및 배포 일관성에 권장)

    # 2. 이미지 스캔 설정 (Push할 때 자동 스캔)
    # 보안 취약점을 자동으로 검사해주는 아주 유용한 옵션입니다.
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration{
        scan_on_push = true
    }

    # 3. 암호화 설정 (AES-256 vs AWS KMS)
    # 기본적으로 AES-256을 사용하지만, 명시적으로 적어줄 수 있습니다.
    encryption_configuration{
        encryption_type = "AES256"
    }
}

output "ecr_url_fastapi" {
    value = aws_ecr_repository.fastapi_repo.repository_url
}*/