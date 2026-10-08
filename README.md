# 미래캠퍼스

관심 분야를 찾고 대학의 교육과정을 살펴본 뒤, 전공을 세 단계로 체험하는 React + FastAPI 앱입니다.

## 바로 실행

Node.js 22.12 이상과 Python 3.10 이상이 필요합니다.

```bash
git clone https://github.com/justpastmarch/mirae-campus.git
cd mirae-campus
npm start
```

기본 주소는 `http://localhost:5173`입니다. 포트가 사용 중이면 터미널에 표시되는 주소를 확인하세요. ZIP을 받았다면 압축을 푼 폴더에서 `npm start`를 실행하면 됩니다.

`npm start`는 처음 실행할 때 프런트엔드 패키지, Python 가상환경, 백엔드 패키지를 설치한 뒤 프런트엔드와 백엔드를 함께 시작합니다. 초기 설치에는 인터넷 연결이 필요합니다. 이후에는 포함된 대학 데이터로 동작합니다. 종료하려면 터미널에서 Ctrl+C를 누르세요.

- 프런트엔드: 기본 5173 포트
- 백엔드: 기본 8000 포트
- API 문서: `http://localhost:8000/docs`
- 별도 계정이나 API 키 불필요

8000 포트가 이미 사용 중이면 PowerShell에서 `$env:API_PORT="8001"`, macOS/Linux에서는 `API_PORT=8001 npm run dev`로 다른 포트를 지정할 수 있습니다. PowerShell은 환경변수 지정 후 `npm run dev`를 실행합니다.

## 전공 체험

모든 학과의 앱 내 학습 과정은 세 단계입니다.

1. 기초 탐색 — 1학년, 주제를 관찰하고 기록합니다.
2. 적용 실습 — 2학년, 아이디어를 적용하고 결과를 기록합니다.
3. 졸업작품 — 4학년, 작품에 스프레이로 색을 입히고 생각을 제출합니다.

대학의 실제 전체 교육과정은 학과 상세의 교육과정 탭에서 별도로 확인할 수 있습니다. 앱의 세 단계 활동은 진로 탐색용으로 구성한 체험이며, 대학의 공식 학년별 수업이나 성적을 의미하지 않습니다.

졸업작품 작업실에서는 마우스와 터치 드래그로 도색합니다. 다섯 가지 색상, 분사 크기 조절, 되돌리기, 다시 칠하기, PNG 내려받기를 지원합니다. 캔버스에 키보드 초점을 두고 방향키로 스프레이를 옮긴 뒤 스페이스를 누르는 방식도 사용할 수 있습니다. 색칠한 작품과 작성한 설명을 함께 제출하면 졸업 리포트가 완성됩니다.

체험 진행률, 관찰 노트, 작품, 리포트는 현재 브라우저에 저장됩니다. 기기 간 동기화는 하지 않습니다. 기존 8단계 버전의 기록은 삭제하지 않고 세 단계로 이관합니다. 브라우저 데이터를 지우면 기록이 사라지므로 필요한 작품과 리포트는 내려받으세요.

## 백엔드

[dotorihanjum/litton](https://github.com/dotorihanjum/litton)의 API 명세와 CSV 데이터를 사용합니다. 해당 저장소의 기준 커밋에 실행 서버가 없어 같은 계약을 구현하는 FastAPI 서버를 포함했습니다.

- `POST /api/course_list` — 관심 분야별 학과 목록
- `POST /api/school_list` — 선택한 학과의 개설 대학
- `POST /api/curriculum_list` — 대학·학과의 교과목 목록
- `GET /api/health` — 서버 상태

학과 검색 → 대학 선택 → 교육과정 조회 → 체험 입학이 실제 API로 연결됩니다. 서버 오류는 화면에서 안내하고 다시 시도할 수 있습니다. 데이터의 출처와 응답 형식은 [backend/SOURCE.md](backend/SOURCE.md)에 정리되어 있습니다.

같은 API 계약을 제공하는 별도 서버를 사용할 때는 `API_TARGET` 환경변수를 서버 주소로 설정하세요. 예: PowerShell에서 `$env:API_TARGET="http://127.0.0.1:9000"` 설정 후 `npm run dev`. 이 경우 포함된 Python 서버는 실행하지 않습니다. 개발 서버와 미리보기 모두 `/api` 요청을 해당 주소로 전달합니다.

## 검사와 빌드

```bash
npm --prefix frontend ci
npm test
npm run build
```

백엔드 테스트는 초기 설정 후 실행할 수 있습니다.

```bash
npm run setup
```

Windows:

```powershell
backend/.venv/Scripts/python.exe -m pip install -r backend/requirements-test.txt
backend/.venv/Scripts/python.exe -m unittest backend.test_api -v
```

macOS/Linux:

```bash
backend/.venv/bin/python -m pip install -r backend/requirements-test.txt
backend/.venv/bin/python -m unittest backend.test_api -v
```

프런트엔드 빌드 결과는 `frontend/dist`에 생성됩니다. 빌드 결과를 백엔드와 함께 확인하려면 `npm run preview`를 실행합니다. 기본 주소는 `http://localhost:4173`입니다. 정적 파일만 외부 서버에 배포하는 경우에는 `/api`를 FastAPI 서버로 전달하는 설정이 필요합니다.

## 개별 실행

프런트엔드:

```bash
cd frontend
npm ci
npm run dev
```

백엔드:

```bash
cd backend
python -m venv .venv
```

Windows에서는 `.venv/Scripts/python.exe`, macOS/Linux에서는 `.venv/bin/python`을 사용합니다.

```powershell
.venv/Scripts/python.exe -m pip install -r requirements.txt
.venv/Scripts/python.exe -m uvicorn main:app --host 127.0.0.1 --port 8000
```

각각 다른 터미널에서 실행합니다. 프런트엔드는 `/api` 요청을 백엔드의 8000 포트로 전달합니다.

## 구성

```text
frontend/
  src/                 React 화면, API 호출, 체험 상태, 스프레이 작업실
  public/              정적 에셋
  index.html           HTML 진입점
  vite.config.js       프런트엔드 빌드와 API 프록시
  package.json         프런트엔드 의존성과 실행 명령
  package-lock.json    프런트엔드 의존성 버전
backend/
  main.py              FastAPI 서버
  data/                압축한 Litton 대학 데이터
  requirements.txt     백엔드 의존성
  test_api.py          API 테스트
scripts/dev.mjs        통합 설치·실행
package.json           루트 실행 명령
```

[업데이트된 Figma 디자인](https://www.figma.com/design/UbRl3qJMjmuXwsUiyZ4RkK/?node-id=0-1)을 바탕으로 구성했습니다. 캐릭터와 작업실 배경은 SVG, 스프레이 효과는 Canvas로 구현되어 별도 이미지 서비스 없이 실행됩니다.
