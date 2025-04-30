영화 정보 앱 (TMDB Movie App)
<img src="https://image.tmdb.org/t/p/w500/wwemzKWzjKYJFfCeiB57q3r4Bcm.png" width="150" align="right" />
👋 소개
영화 정보 앱은 TMDB API를 활용하여 최신 영화 정보, 트레일러, 상세 정보를 제공하는 Flutter 모바일 앱입니다. 다크 모드 UI와 세련된 디자인으로 영화 탐색 경험을 향상시켰습니다.
✨ 주요 기능

카테고리별 영화 탐색

현재 상영중인 영화
인기 순위 영화 (순위 표시 포함)
평점 높은 영화
개봉 예정 영화


상세 영화 정보

영화 포스터 및 배경 이미지
줄거리, 장르, 러닝타임
평점, 인기도, 예산, 수익
제작사 정보


트레일러 재생

앱 내 YouTube 트레일러 재생
여러 트레일러 및 티저 지원



🛠️ 기술 스택

아키텍처: MVVM + Clean Architecture
상태 관리: Riverpod
데이터 소스: TMDB API
네트워킹: Retrofit + Dio
캐싱: Hive
UI 컴포넌트: Custom & Material Design

📱 스크린샷
<table>
  <tr>
    <td><img src="https://via.placeholder.com/250x500?text=홈+화면" alt="홈 화면"/></td>
    <td><img src="https://via.placeholder.com/250x500?text=영화+상세+정보" alt="영화 상세 정보"/></td>
    <td><img src="https://via.placeholder.com/250x500?text=트레일러+재생" alt="트레일러 재생"/></td>
  </tr>
</table>
🚀 시작하기
요구사항

Flutter 3.0.0 이상
Dart 2.17.0 이상
TMDB API 키 (https://www.themoviedb.org/settings/api에서 발급)

설치 방법

저장소 복제
bashgit clone https://github.com/yourusername/movie_info_app.git
cd movie_info_app

의존성 설치
bashflutter pub get

환경 설정

.env.template 파일을 복사하여 .env 파일 생성
TMDB API 키와 엑세스 토큰을 추가


코드 생성
bashflutter pub run build_runner build --delete-conflicting-outputs

앱 실행
bashflutter run


🌟 특징

반응형 UI: 다양한 화면 크기에 적응하는 레이아웃
스마트 캐싱: 데이터 사용량 절약 및 오프라인 지원
세련된 애니메이션: 부드러운 전환 및 시각적 피드백
오류 처리: 강력한 예외 처리 및 사용자 친화적 오류 메시지
다크 모드: 기본 다크 테마로 눈의 피로 감소

📝 TODO

 검색 기능 추가
 영화 찜하기 기능
 배우 및 감독 정보 페이지
 영화 리뷰 섹션
 다중 언어 지원

📄 라이선스
이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 LICENSE 파일을 참조하세요.
🙏 감사의 말

TMDB에서 제공하는 풍부한 영화 데이터베이스
영감과 지원을 제공한 Flutter 커뮤니티
피드백을 제공해 준 모든 테스터들


⭐ 이 프로젝트가 마음에 드셨다면 별표를 눌러주세요! ⭐
