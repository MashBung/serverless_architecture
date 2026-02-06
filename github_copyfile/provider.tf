provider "aws" {
  region = "your-region" # 당신 리전
}

provider "aws"{
  alias = "your-region"
  region = "your-region"
}