# 미래캠퍼스

관심 분야를 찾고, 전공을 체험하며 나만의 진로 기록을 쌓는 React 앱입니다.

## 실행

Node.js 22.12 이상이 필요합니다. Node.js 24 LTS를 권장합니다.

```bash
npm install
npm run dev
```

터미널에 표시되는 로컬 주소(기본 `http://localhost:5173`)를 브라우저에서 열면 됩니다. 5173 포트를 사용 중이면 다음 빈 포트로 실행됩니다. 계정, API 키, 서버 설정은 필요하지 않습니다.

GitHub에서 받는 경우:

```bash
git clone https://github.com/justpastmarch/mirae-campus.git
cd mirae-campus
npm ci
npm run dev
```

ZIP으로 받았다면 압축을 푼 폴더에서 `npm install`과 `npm run dev`를 실행하세요.

## 주요 기능

- 관심 분야와 활동 선택, 선택 결과를 반영한 학과 추천
- 학과 검색과 분야 필터, 학과별 교육과정 보기
- 시각디자인·심리·미디어콘텐츠·컴퓨터공학 전공 체험
- 학과별 8개 실습과 관찰 노트, 진행률 저장
- 휴학·복학·전과·복수 전공 체험
- 졸업 리포트 저장, 다시 보기, 텍스트 파일 내려받기
- 모바일 화면과 데스크톱 미리보기, 키보드 탐색

진행 상태는 현재 브라우저의 `localStorage`에 저장됩니다. 새로고침해도 유지되지만 기기나 브라우저 사이에는 동기화되지 않습니다. 브라우저 데이터를 지우면 기록도 사라집니다. 더 보기 메뉴에서 기록을 초기화할 수 있습니다.

전공 및 교육과정은 진로 탐색을 위한 체험용 예시입니다. 실제 대학의 입학·학적 시스템과 연결되어 있지 않습니다. 추천은 선택한 키워드와 활동을 점수로 계산합니다.

## 빌드와 검사

```bash
npm test
npm run build
npm run preview
```

배포용 결과는 `dist` 폴더에 생성됩니다. `preview`의 기본 주소는 `http://localhost:4173`입니다.

## 구성

```text
src/
  App.jsx          화면과 화면 전환
  Icon.jsx         아이콘
  Mascot.jsx       캐릭터
  main.jsx         앱 시작
  model.js         학과 데이터, 저장, 추천, 체험 진행
  model.test.js    주요 동작 검사
  styles.css       화면 스타일
public/
  favicon.svg
```

React, React DOM, Vite를 사용합니다. 폰트는 기기에 설치된 한국어 시스템 글꼴을 사용하며, 캐릭터와 아이콘은 SVG로 포함되어 실행 시 외부 이미지 요청이 없습니다.

## 디자인

[Figma 원본](https://www.figma.com/design/UbRl3qJMjmuXwsUiyZ4RkK/?node-id=0-1)

원본의 14개 모바일 화면을 바탕으로 구현했습니다. 캐릭터는 SVG로 재구성했고, 원본에서 상세 내용이 제공되지 않은 학과와 실습은 체험용 콘텐츠로 구성했습니다.
