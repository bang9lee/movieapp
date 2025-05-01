# 🎬 오늘의 영화 (TMDB Movie App)


TMDB API를 활용한 **Flutter 기반 영화 정보 앱**입니다.
<br>
최신 영화, 트레일러, 상세 정보를 세련된 UI와 함께 제공하며,
<br>
**다크 모드**, **반응형 UI**, **부드러운 애니메이션** 등 사용자 경험에 초점을 맞췄습니다.
<br>


# ✨ 주요 기능
### 🎞️ 영화 카테고리 탐색
- 현재 상영중
- 인기 영화 (순위 포함)
- 평점 높은 영화
- 개봉 예정작
- 제목, 배우, 감독 등으로 원하는 영화 검색

### 📋 상세 영화 정보
- 영화 포스터 및 배경 이미지
- 출연인물, 감독정보 제공
- 줄거리, 장르, 러닝타임
- 평점, 인기도, 예산, 수익
- 제작사 정보

### ▶️ 트레일러 재생
- 앱 내 YouTube 플레이어로 재생
- 트레일러 & 티저 영상 지원

### **🌐 다국어 지원**  
- 한국어, 영어, 일본어, 중국어 지원

<br>

## 🛠 기술 스택
| 항목            | 사용 기술                                                  |
|-----------------|-----------------------------------------------------------|
| **아키텍처**     | MVVM + Clean Architecture                                 |
| **상태 관리**    | [Riverpod](https://riverpod.dev)                          |
| **네트워킹**     | [Dio](https://pub.dev/packages/dio) + [Retrofit](https://pub.dev/packages/retrofit) |
| **로컬 캐싱**    | [Hive](https://pub.dev/packages/hive)                    |
| **UI 프레임워크** | Flutter + Custom Material Design                         |

---

## 📱 스크린샷

![iPhone 15 Mockup, Perspective](https://github.com/user-attachments/assets/1c5678c5-3c5b-4340-bc68-bdc8a3958987)


---

## 🚀 시작하기

### 📦 요구사항
- Flutter **3.0.0 이상**
- Dart **2.17.0 이상**
- [TMDB API 키](https://www.themoviedb.org/settings/api) 발급

# ⚙ 설치 및 실행

#### 저장소 클론
git clone https://github.com/yourusername/movieapp.git
<br>
cd movieapp

#### 패키지 설치
flutter pub get

#### 환경 변수 설정
cp .env.template .env
<br>
#### .env 파일에 TMDB API 키 입력

#### 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

#### 앱 실행
flutter run

## 🌟 앱 특징

| 특징                     | 설명                                                                 |
|--------------------------|----------------------------------------------------------------------|
| 📱 **반응형 UI**           | 다양한 화면 크기 및 해상도에 자동으로 적응하여 일관된 사용자 경험 제공       |
| 🔒 **스마트 캐싱**         | Hive 기반 캐싱으로 데이터 사용량 절약 및 오프라인 환경에서도 정보 표시 가능     |
| 🎞 **세련된 애니메이션**     | 화면 전환, 리스트 로딩, 포스터 확대 등 부드럽고 직관적인 시각적 피드백 제공    |
| 🛑 **강력한 오류 처리**     | 네트워크 실패, 데이터 누락 등 다양한 예외에 대한 사용자 친화적 에러 처리       |
| 🌙 **다크 모드 지원**       | 기본 테마로 눈의 피로를 줄여주는 다크 모드 UI 제공                           |


---

🧭 프로젝트 구조

---

lib/

├── core/             # 공통 유틸리티 및 설정

│   ├── localization/ # 다국어 지원

│   ├── theme/        # 테마 설정

│   └── utils/        # 유틸리티 함수

├── data/             # 데이터 계층

│   ├── models/       # 모델 클래스

│   ├── repositories/ # 데이터 접근 로직

│   └── services/     # API 서비스

├── domain/           # 도메인/비즈니스 로직

│   └── entities/     # 엔티티 정의

├── presentation/     # UI 구성

│   ├── providers/    # 상태 관리

│   ├── screens/      # 각 화면 구성

│   └── widgets/      # 공용 위젯

└── main.dart         # 앱 진입점

---

## 🙏 감사의 말

- 🎬 [TMDB](https://www.themoviedb.org/)에서 제공한 방대한 영화 데이터 덕분에 앱이 풍성해졌습니다.

---

CH.LEE

<br/>
© 2025 Today's Studio. All Rights Reserved.


