import torch
import torch.nn as nn
import torchvision.transforms.v2 as tf
import boto3
from PIL import Image
import io
import json


class Blood_CNN(nn.Module):
    def __init__(self, num_classes):
        super().__init__()

        self.stage1 = nn.Sequential(
            nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3, padding="same"),
            nn.BatchNorm2d(32),
            nn.SiLU(),
            nn.Conv2d(in_channels=32, out_channels=32, kernel_size=3, padding="same"),
            nn.BatchNorm2d(32),
            nn.SiLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
        )
        self.stage2 = nn.Sequential(
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=3, padding="same"),
            nn.BatchNorm2d(64),
            nn.SiLU(),
            nn.Conv2d(in_channels=64, out_channels=64, kernel_size=3, padding="same"),
            nn.BatchNorm2d(64),
            nn.SiLU(),
            nn.Conv2d(in_channels=64, out_channels=64, kernel_size=3, padding="same"),
            nn.BatchNorm2d(64),
            nn.SiLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Dropout(0.2),
        )
        self.stage3 = nn.Sequential(
            nn.Conv2d(in_channels=64, out_channels=128, kernel_size=3, padding="same"),
            nn.BatchNorm2d(128),
            nn.SiLU(),
            nn.Conv2d(in_channels=128, out_channels=128, kernel_size=3, padding="same"),
            nn.BatchNorm2d(128),
            nn.SiLU(),
            nn.Conv2d(in_channels=128, out_channels=128, kernel_size=3, padding="same"),
            nn.BatchNorm2d(128),
            nn.SiLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Dropout(0.3),
        )
        # Stage4 16
        self.stage4 = nn.Sequential(
            nn.Conv2d(in_channels=128, out_channels=256, kernel_size=3, padding="same"),
            nn.BatchNorm2d(256),
            nn.SiLU(),
            nn.Conv2d(in_channels=256, out_channels=256, kernel_size=3, padding="same"),
            nn.BatchNorm2d(256),
            nn.SiLU(),
            nn.Conv2d(in_channels=256, out_channels=256, kernel_size=3, padding="same"),
            nn.BatchNorm2d(256),
            nn.SiLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
            nn.Dropout(0.4),
        )
        # Stage5 8
        self.stage5 = nn.Sequential(
            nn.Conv2d(in_channels=256, out_channels=512, kernel_size=3, padding="same"),
            nn.BatchNorm2d(512),
            nn.SiLU(),
            nn.Conv2d(in_channels=512, out_channels=512, kernel_size=3, padding="same"),
            nn.BatchNorm2d(512),
            nn.SiLU(),
            nn.Conv2d(in_channels=512, out_channels=512, kernel_size=3, padding="same"),
            nn.BatchNorm2d(512),
            nn.SiLU(),
            nn.MaxPool2d(kernel_size=2, stride=2),
        )

        self.global_pool = nn.AdaptiveAvgPool2d(1)
        self.classifier = nn.Sequential(nn.Dropout(0.5), nn.Linear(512, num_classes))

    def forward(self, x):
        x = self.stage1(x)
        x = self.stage2(x)
        x = self.stage3(x)
        x = self.stage4(x)
        x = self.stage5(x)
        x = self.global_pool(x)
        x = torch.flatten(x, 1)
        x = self.classifier(x)
        return x


transform = tf.Compose(
    [
        tf.ToImage(),
        tf.Resize((224, 224)),
        tf.ToDtype(torch.float32, scale=True),
        tf.Normalize(mean=[0.8737, 0.7485, 0.7215], std=[0.1520, 0.1789, 0.07538]),
    ]
)

CLASSES = [
    "basophil",
    "eosinophil",
    "erythroblast",
    "ig",
    "lymphocyte",
    "monocyte",
    "neutrophil",
    "platelet",
]

model = None


def lambda_handler(event, context):
    global model
    s3 = boto3.client("s3")

    try:
        bucket = event["Records"][0]["s3"]["bucket"]["name"]
        key = event["Records"][0]["s3"]["object"]["key"]

        if model is None:
            print("Loading model...")
            model = Blood_CNN(num_classes=len(CLASSES))
            model.load_state_dict(
                torch.load("CNN_model.pt", map_location="cpu", weights_only=True)
            )
            model.eval()

        response = s3.get_object(Bucket=bucket, Key=key)
        image = Image.open(io.BytesIO(response["Body"].read())).convert("RGB")

        input_tensor = transform(image).unsqueeze(0)

        with torch.no_grad():
            output = model(input_tensor)
            _, predicted = torch.max(output, 1)
            result = CLASSES[predicted.item()]

        print(f"Prediction for {key}: {result}")

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"prediction": result, "file": key}),
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": str(e)}),
        }
