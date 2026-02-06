/*# 1. ECS IP 변수 설정 (방금 받은 IP 입력됨)
variable "ecs_ip" {
  description = "ECS Task Public IP"
  type        = string
  default     = "your-ip"
}

# 2. 미국 리전에 있는 ACM 인증서 정보 가져오기
data "aws_acm_certificate" "cert" {
  domain   = "your-domain"
  statuses = ["ISSUED"]
  provider = your-region  # provider.tf의 alias 참조
}

# 3. CloudFront 배포 생성
resource "aws_cloudfront_distribution" "fastapi_dist" {
  
  # --- [핵심] 원본(ECS) 연결 설정 ---
  origin {
    domain_name = var.ecs_ip
    origin_id   = "FastAPI-ECS-Origin"

    custom_origin_config {
      http_port              = 8000        # [중요] FastAPI가 열려있는 포트
      https_port             = 443
      origin_protocol_policy = "http-only" # ECS에는 인증서가 없으므로 HTTP로 통신
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "FastAPI Portfolio Service"
  default_root_object = "" # API 서버이므로 index.html 지정 안 함

  # --- 도메인 설정 ---
  aliases = ["your-domain"]

  # --- 캐시 및 전달 동작 설정 ---
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "FastAPI-ECS-Origin"

    # API 서버 특성상 모든 헤더/쿠키/쿼리를 그대로 통과시킴 (캐시 끄기)
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["*"]
    }

    viewer_protocol_policy = "redirect-to-https" # HTTP로 오면 HTTPS로 강제 전환
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # --- SSL 인증서 설정 ---
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # --- 지역 제한 (없음) ---
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

# 4. Route 53 도메인 연결 (A 레코드 별칭)
# 본인의 도메인 영역 정보를 가져옵니다.
data "aws_route53_zone" "selected" {
  name = "your-domain"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "your-domain"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.fastapi_dist.domain_name
    zone_id                = aws_cloudfront_distribution.fastapi_dist.hosted_zone_id
    evaluate_target_health = false
  }
}*/