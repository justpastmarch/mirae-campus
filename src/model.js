export const STORAGE_KEY = "mirae-campus-v1";
export const departments = [
  {
    id: "design",
    name: "시각디자인학과",
    category: "디자인",
    group: "예술 · 디자인",
    icon: "palette",
    keywords: ["디자인", "영상·콘텐츠", "미술"],
    description:
      "사람의 일상을 관찰하고, 생각을 시각적인 해결책으로 바꾸는 과정을 체험해요.",
    tags: ["사용자 관찰", "화면 설계"],
    years: [
      "디자인의 시작",
      "사람을 위한 디자인",
      "아이디어 구체화",
      "공유하고 돌아보기",
    ],
    lessons: [
      "일상 속 디자인 찾기",
      "색과 형태로 표현하기",
      "사용자 관찰",
      "학교 앱의 불편 찾기",
      "아이디어 스케치",
      "화면 스케치 만들기",
      "피드백으로 다듬기",
      "나의 디자인 돌아보기",
    ],
    jobs: ["UX/UI 디자이너", "브랜드 디자이너", "콘텐츠 디자이너"],
  },
  {
    id: "psychology",
    name: "심리학과",
    category: "사람·사회",
    group: "사람 · 사회",
    icon: "brain",
    keywords: ["심리", "교육", "사회"],
    description:
      "사람의 마음과 행동이 궁금하다면, 일상 속 질문을 통해 심리학을 만나보세요.",
    tags: ["감정 기록", "행동 관찰"],
    years: ["마음의 이해", "사람과 관계", "행동을 탐구하기", "발견을 나누기"],
    lessons: [
      "마음의 이해",
      "오늘의 감정 기록",
      "나의 습관 관찰",
      "친구의 이야기 듣기",
      "질문지 만들기",
      "응답에서 패턴 찾기",
      "작은 실험 설계",
      "나의 발견 돌아보기",
    ],
    jobs: ["심리 연구원", "상담 분야 전문가", "사용자 경험 연구원"],
  },
  {
    id: "media",
    name: "미디어콘텐츠학과",
    category: "디자인",
    group: "예술 · 디자인",
    icon: "film",
    keywords: ["영상·콘텐츠", "디자인", "공연"],
    description:
      "나만의 이야기를 찾고, 글과 이미지, 영상으로 사람들에게 전해요.",
    tags: ["스토리 구성", "영상 기획"],
    years: ["이야기의 시작", "콘텐츠 기획", "직접 제작하기", "세상과 연결하기"],
    lessons: [
      "좋아하는 콘텐츠 분석",
      "나의 이야기 찾기",
      "독자와 시청자 이해",
      "콘텐츠 주제 정하기",
      "스토리보드 만들기",
      "짧은 콘텐츠 제작",
      "피드백 모으기",
      "포트폴리오 돌아보기",
    ],
    jobs: ["콘텐츠 기획자", "영상 제작자", "미디어 에디터"],
  },
  {
    id: "computer",
    name: "컴퓨터공학과",
    category: "기술·자연",
    group: "기술 · 자연",
    icon: "code",
    keywords: ["컴퓨터", "데이터", "공학"],
    description:
      "일상의 문제를 작은 단계로 나누고, 기술로 해결하는 방법을 배워요.",
    tags: ["문제 해결", "논리적 사고"],
    years: [
      "컴퓨팅의 시작",
      "문제 해결의 기초",
      "서비스 만들기",
      "개선하고 공유하기",
    ],
    lessons: [
      "일상 속 알고리즘",
      "문제를 단계로 나누기",
      "데이터 관찰",
      "나만의 규칙 만들기",
      "서비스 아이디어",
      "화면 흐름 설계",
      "오류 찾아 개선하기",
      "나의 프로젝트 돌아보기",
    ],
    jobs: ["소프트웨어 개발자", "데이터 분석가", "서비스 엔지니어"],
  },
];
export const initialState = {
  interests: [],
  activities: [],
  journeys: {},
  current: "design",
  notes: {},
  reports: [],
  onboarded: false,
};
export function loadState(storage) {
  try {
    const value = JSON.parse(storage.getItem(STORAGE_KEY));
    if (!value || typeof value !== "object")
      return structuredClone(initialState);
    const validIds = new Set(departments.map((d) => d.id));
    const journeys = Object.fromEntries(
      Object.entries(value.journeys || {})
        .filter(([id]) => validIds.has(id))
        .map(([id, item]) => [
          id,
          {
            completed: Math.min(
              8,
              Math.max(0, Math.trunc(Number(item?.completed) || 0)),
            ),
            paused: !!item?.paused,
          },
        ]),
    );
    return {
      ...structuredClone(initialState),
      interests: Array.isArray(value.interests)
        ? value.interests.filter((v) => typeof v === "string")
        : [],
      activities: Array.isArray(value.activities)
        ? value.activities.filter((v) => typeof v === "string")
        : [],
      journeys,
      current: validIds.has(value.current) ? value.current : "design",
      notes:
        value.notes &&
        typeof value.notes === "object" &&
        !Array.isArray(value.notes)
          ? Object.fromEntries(
              Object.entries(value.notes).filter(
                ([, note]) => typeof note === "string",
              ),
            )
          : {},
      reports: Array.isArray(value.reports)
        ? value.reports.filter(
            (r) => validIds.has(r?.id) && typeof r?.date === "string",
          )
        : [],
      onboarded: !!value.onboarded,
    };
  } catch {
    return structuredClone(initialState);
  }
}
export function recommend(interests, activities) {
  const scores = { design: 0, psychology: 0, media: 0, computer: 0 };
  departments.forEach((d) => {
    scores[d.id] += d.keywords.filter((k) => interests.includes(k)).length * 3;
  });
  const activityMap = {
    puzzle: ["computer"],
    draw: ["design", "media"],
    listen: ["psychology"],
    science: ["computer"],
    experiment: ["computer", "design"],
  };
  activities.forEach((a) =>
    activityMap[a]?.forEach((id) => {
      scores[id] += 2;
    }),
  );
  return [...departments].sort((a, b) => scores[b.id] - scores[a.id]);
}
export function completeLesson(state, id, index, note) {
  const journey = state.journeys[id];
  if (!journey || journey.paused || journey.completed !== index || index >= 8)
    return state;
  return {
    ...state,
    notes: { ...state.notes, [`${id}-${index}`]: note.trim() },
    journeys: { ...state.journeys, [id]: { ...journey, completed: index + 1 } },
  };
}
