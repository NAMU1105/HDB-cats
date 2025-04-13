# 🐱 HDB Cats Project

이 프로젝트는 HDB (싱가포르의 공공 아파트, HDB flat)에 주기적으로 나타나는 지역 고양이들의 사진을  
주민들이 자유롭게 공유할 수 있도록 만든 커뮤니티 기반 웹 애플리케이션입니다.  
사진은 아파트 블록(HDB block)별로 업로드되며,  
다른 사용자들도 우리 동네 고양이들을 확인할 수 있습니다.

---

This project is a community-driven web app that allows residents to share and browse photos  
of local cats that frequently appear in Singapore's HDB (public housing) flats.  
Photos are uploaded and grouped by HDB block, making it easy to explore cats from your neighborhood.

---

## 📁 프로젝트 구조 / Project Structure

<pre>
hdb-cats-project/
├── backend/               # Lambda 함수 코드 (사진 업로드 및 조회)
│   └── lambda/
│       ├── uploadPhoto.ts
│       └── getPhotos.ts
├── frontend/              # React 기반 사용자 인터페이스
│   ├── App.tsx
│   ├── index.html
│   ├── components/
│   │   └── CatCard.tsx
│   └── pages/
│       └── Home.tsx
├── infra/                 # Terraform 기반 AWS 인프라 정의
│   ├── provider.tf
│   ├── s3.tf
│   ├── dynamodb.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── main.tf (작성 필요)
└── README.md
</pre>

---

## 🧪 로컬 테스트 방법 / How to Run Locally

### ✅ 프론트엔드 실행 (Run React locally)

```bash
cd frontend
npm install
npm run dev
```

브라우저에서 열기 / Open in the browser: http://localhost:5173

### ✅ 백엔드 Lambda 함수 로컬 테스트 (Run Backend Lambda functions - Express simulation)

bash
Copy
Edit

### 🚀 배포 방법 / How to Deploy to AWS

이 프로젝트는 AWS 기반 인프라를 Terraform으로 정의합니다.
This project defines its AWS infrastructure using Terraform.

📦 포함된 리소스 / Included Resources

S3: 고양이 사진 저장소 / Stores cat photo files

DynamoDB: 사진 메타데이터 저장 / Stores photo metadata

Lambda: 업로드 및 조회 API / Handles upload and retrieval APIs

API Gateway: 외부 요청을 Lambda로 라우팅 / Routes external requests to Lambda functions

CloudFront: 정적 프론트엔드 배포 및 이미지 CDN / Distributes static frontend content and serves cat images via CDN

### Terraform 배포 순서 / Terraform Deploy sequence

```
cd infra
terraform init
terraform apply
```
