# 미래캠퍼스

관심 분야를 찾고 대학의 교육과정을 살펴본 뒤, 전공을 세 단계로 체험하는 React + FastAPI 앱입니다.

## 바로 실행

아래에서 사용하는 운영체제의 명령 블록을 **전체 복사해서 터미널에 붙여넣으세요.** Node.js 22.12 이상, npm, Python 3.10 이상과 가상환경 기능, Git을 확인하고, 부족한 프로그램을 설치한 다음 프로젝트 다운로드와 실행까지 진행합니다.

설치 위치는 명령을 실행한 폴더 아래 `mirae-campus`입니다. 이미 내려받았다면 **그 폴더의 상위 폴더**에서 실행하세요. 같은 저장소이고 수정한 파일이 없으면 최신 코드로 업데이트합니다. 기존 파일을 삭제하거나 수정 내용을 덮어쓰지 않습니다.

최초 실행에는 인터넷과 프로그램 설치 권한이 필요합니다. 설치 중 관리자 승인, 암호 또는 약관 확인 창이 나오면 직접 확인해주세요. 회사·학교에서 프로그램 설치를 막은 컴퓨터에서는 관리자에게 설치를 요청해야 합니다.

### Windows 10/11 — PowerShell

시작 메뉴에서 **PowerShell**을 열고 붙여넣으세요. `npm.ps1` 실행 정책 문제를 피하도록 실행 스크립트는 `npm.cmd`를 사용합니다.

```powershell
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$setupUrl = 'https://raw.githubusercontent.com/justpastmarch/mirae-campus/main/scripts/bootstrap.ps1'
$setupCode = (Invoke-WebRequest -UseBasicParsing $setupUrl).Content
& ([scriptblock]::Create($setupCode))
```

필요한 프로그램은 Windows 패키지 관리자 WinGet으로 설치합니다. WinGet이 없다는 메시지가 나오면 Microsoft의 [앱 설치 관리자](https://aka.ms/getwinget)를 설치·업데이트하고 PowerShell을 새로 열어 같은 명령을 실행하세요. 설치 후 PATH를 찾을 수 없다는 메시지도 새 PowerShell에서 재실행하면 됩니다.

이전 설치 명령에서 `NativeCommandError` 또는 `Python was not found`로 멈췄다면 위 명령 블록을 다시 실행하세요. 최신 스크립트는 `python3`가 실행되지 않아도 `python`, `py`를 이어서 확인합니다. Python 확인 실패와 실제 설치 실패를 구분하며, 프로그램이 실패 코드로 종료하면 해당 오류를 표시하고 중단합니다.

### macOS — 터미널

```bash
(
  set -e
  campus_setup=$(mktemp)
  curl -fsSL https://raw.githubusercontent.com/justpastmarch/mirae-campus/main/scripts/bootstrap.sh -o "$campus_setup"
  bash "$campus_setup"
)
```

부족한 프로그램은 Homebrew로 설치합니다. Homebrew가 없으면 공식 설치 프로그램을 실행합니다. Apple Silicon과 Intel 경로를 구분하며, macOS 개발 도구 설치가 필요한 경우 화면 안내를 따라주세요.

### Ubuntu 22.04 이상 / Debian 12 이상 — 터미널

```bash
(
  set -e
  if ! command -v curl >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl ca-certificates
  fi
  campus_setup=$(mktemp)
  curl -fsSL https://raw.githubusercontent.com/justpastmarch/mirae-campus/main/scripts/bootstrap.sh -o "$campus_setup"
  bash "$campus_setup"
)
```

Git·Python·가상환경 기능은 apt로, Node.js가 없거나 버전이 낮으면 NodeSource의 Node.js 22 저장소를 통해 설치합니다. 다른 Linux 배포판은 자동 설치 대상이 아닙니다.

Windows에서는 설치 여부 확인과 새 프로젝트의 자동 패키지 설치·실행을 검증했습니다. macOS/Linux 스크립트는 구문 검사만 완료했으며 해당 운영체제에서 설치 실행은 검증하지 않았습니다.

설치 방식: [Microsoft WinGet](https://learn.microsoft.com/en-us/windows/package-manager/winget/install), [Homebrew](https://docs.brew.sh/Installation), [NodeSource](https://github.com/nodesource/distributions).

### 필수 프로그램이 이미 설치된 경우

```bash
git clone https://github.com/justpastmarch/mirae-campus.git
cd mirae-campus
npm start
```

기본 주소는 `http://localhost:5173`입니다. 포트가 사용 중이면 터미널에 표시되는 주소를 확인하세요. ZIP을 받았다면 압축을 푼 폴더에서 `npm start`를 실행하면 됩니다.

Windows PowerShell에서 `npm.ps1을 실행할 수 없다`는 오류가 나면 `npm.cmd start`를 사용하세요. 재시작은 실행 중인 터미널에서 `Ctrl+C` 후 같은 폴더에서 다시 실행하면 됩니다. 터미널을 새로 열어 명령을 찾지 못한다면 위 운영체제별 블록을 상위 폴더에서 다시 실행하세요.

`npm start`는 처음 실행할 때 프런트엔드 패키지, Python 가상환경, 백엔드 패키지를 설치한 뒤 프런트엔드와 백엔드를 함께 시작합니다. 초기 설치에는 인터넷 연결이 필요합니다. 이후에는 포함된 대학 데이터로 동작합니다. 종료하려면 터미널에서 Ctrl+C를 누르세요.

- 프런트엔드: 기본 5173 포트
- 백엔드: 기본 8000 포트
- API 문서: `http://localhost:8000/docs`
- 별도 계정이나 API 키 불필요

8000 포트가 이미 사용 중이면 PowerShell에서 `$env:API_PORT="8001"`, macOS/Linux에서는 `API_PORT=8001 npm run dev`로 다른 포트를 지정할 수 있습니다. PowerShell은 환경변수 지정 후 `npm run dev`를 실행합니다.

## 전공 체험

모든 학과의 앱 내 학습 과정은 세 단계입니다.

학과는 Figma에 표시된 산업디자인학과와 심리학과만 제공합니다. 추천·검색·저장 기록·API 조회에 동일한 범위를 적용합니다.

1. 기초 탐색 — 1학년, 주제를 관찰하고 기록합니다.
2. 적용 실습 — 2학년, 아이디어를 적용하고 결과를 기록합니다.
3. 졸업작품 — 4학년, 작품에 스프레이로 색을 입히고 생각을 제출합니다.

대학의 실제 전체 교육과정은 학과 상세의 교육과정 탭에서 별도로 확인할 수 있습니다. 앱의 세 단계 활동은 진로 탐색용으로 구성한 체험이며, 대학의 공식 학년별 수업이나 성적을 의미하지 않습니다.

졸업작품 작업실에서는 마우스와 터치 드래그로 도색합니다. 다섯 가지 색상, 분사 크기 조절, 되돌리기, 다시 칠하기, PNG 내려받기를 지원합니다. 캔버스에 키보드 초점을 두고 방향키로 스프레이를 옮긴 뒤 스페이스를 누르는 방식도 사용할 수 있습니다. 색칠한 작품과 작성한 설명을 함께 제출하면 졸업 리포트가 완성됩니다.

체험 진행률, 관찰 노트, 작품, 리포트는 현재 브라우저에 저장됩니다. 기기 간 동기화는 하지 않습니다. 기존 8단계 버전의 기록은 삭제하지 않고 세 단계로 이관합니다. 브라우저 데이터를 지우면 기록이 사라지므로 필요한 작품과 리포트는 내려받으세요.

접속하거나 새로고침하면 항상 시작 화면이 열립니다. 저장된 기록은 ‘이전 기록 이어서 하기’를 눌러 불러올 수 있습니다. ‘처음부터 시작하기’를 누르면 기존 기록을 초기화하고 새 체험을 시작합니다.

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

그라디언트는 [Figma Make 버전 4](https://www.figma.com/make/nFew2Mg9bmQAUsjrwrNS7s/Implement-Design-with-UX-Focus)의 전체 체험 흐름과 SVG 에셋을 확인해 적용했습니다.

| 위치 | 원본 값 |
| --- | --- |
| 추천 분야·학과 소개 카드 | `#27D8CD`, 위쪽 불투명도 0% → 아래쪽 20% |
| 학과 소개 팔레트 | 원본 `major-palette.svg`, `#27D8CD` → `#90DAD6`, 불투명도 48%, 블러 7.8 |
| 체험 입학증·성적표·졸업증명서의 접힌 모서리 | 135도, `#27D8CD` 49% → `#EAFFFD` 51% |
| 스프레이 분사 | 불투명도 70%·25%·0%, 위치 0%·55%·72% |

시작·관심 선택·키워드·로딩·대학 목록·전공 홈·사포 과제·졸업 요약 화면에는 원본 CSS/SVG 그라디언트가 없습니다. 서류는 앱 내 체험 기록이며 공식 대학 증명서나 성적표가 아닙니다.
