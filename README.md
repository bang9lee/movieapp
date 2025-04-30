# 🎬 영화 정보 앱 (TMDB Movie App)
<img src="https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png" width="120" align="right" />
TMDB API를 활용한 Flutter 기반 영화 정보 앱입니다. 최신 영화, 트레일러, 상세 정보를 세련된 UI와 함께 제공합니다. 다크 모드와 반응형 디자인으로 몰입감 있는 영화 탐색 경험을 제공합니다.

✨ 주요 기능
🔍 카테고리별 영화 탐색
🎞️ 현재 상영중인 영화

📈 인기 영화 (순위 표시)

🌟 평점 높은 영화

🗓️ 개봉 예정 영화

📋 상세 영화 정보
포스터 및 배경 이미지

줄거리, 장르, 러닝타임

평점, 인기도, 예산, 수익

제작사 정보

▶️ 트레일러 재생
앱 내 YouTube 플레이어 연동

트레일러 및 티저 영상 재생 지원

🛠️ 기술 스택

항목	사용 기술
아키텍처	MVVM + Clean Architecture
상태 관리	Riverpod
API 연동	Retrofit + Dio
데이터 캐싱	Hive
UI 프레임워크	Flutter + Custom Material Design
📱 스크린샷
<table> <tr> <td><img src="https://via.placeholder.com/250x500?text=홈+화면" alt="홈 화면"/></td> <td><img src="https://via.placeholder.com/250x500?text=영화+상세+정보" alt="영화 상세 정보"/></td> <td><img src="https://via.placeholder.com/250x500?text=트레일러+재생" alt="트레일러 재생"/></td> </tr> </table>
🚀 시작하기
📋 요구사항
Flutter 3.0.0 이상

Dart 2.17.0 이상

TMDB API 키 발급

⚙️ 설치 방법
bash
복사
편집
# 저장소 복제
git clone https://github.com/yourusername/movie_info_app.git
cd movie_info_app

# 의존성 설치
flutter pub get

# 환경 설정
cp .env.template .env
# .env 파일에 TMDB API 키와 토큰 입력

# 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 앱 실행
flutter run
🌟 특징
✅ 반응형 UI: 다양한 기기 해상도 대응

🔒 스마트 캐싱: 오프라인 지원 및 데이터 절약

🧩 세련된 애니메이션: 부드러운 전환 효과

🚫 강력한 오류 처리: 예외 감지 및 사용자 피드백

🌙 다크 모드: 기본 테마로 눈의 피로 감소

📝 TODO
🔍 영화 검색 기능

❤️ 영화 찜하기

🎭 배우 및 감독 정보

📝 영화 리뷰 섹션

🌐 다국어(다중 언어) 지원

📄 라이선스
이 프로젝트는 MIT 라이선스 하에 배포됩니다.

🙏 감사의 말
풍부한 영화 정보를 제공한 TMDB

Flutter 커뮤니티의 유용한 자료와 영감

피드백을 제공해준 모든 테스터 여러분

