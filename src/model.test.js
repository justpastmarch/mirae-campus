import test from "node:test";
import assert from "node:assert/strict";
import { loadState, recommend, completeLesson, initialState } from "./model.js";

test("손상된 저장 데이터는 안전한 초기 상태로 복구한다", () => {
  assert.deepEqual(loadState({ getItem: () => "{broken" }), initialState);
  const state = loadState({
    getItem: () =>
      JSON.stringify({
        current: "missing",
        journeys: { design: { completed: 99 }, invalid: {} },
        notes: { a: 2, b: "기록" },
      }),
  });
  assert.equal(state.current, "design");
  assert.equal(state.journeys.design.completed, 8);
  assert.equal(state.journeys.invalid, undefined);
  assert.deepEqual(state.notes, { b: "기록" });
});
test("관심 분야와 활동에 따라 추천 학과가 바뀐다", () => {
  assert.equal(recommend(["심리", "교육"], ["listen"])[0].id, "psychology");
  assert.equal(recommend(["컴퓨터"], ["puzzle"])[0].id, "computer");
  assert.equal(recommend(["디자인"], ["draw"])[0].id, "design");
});
test("실습 완료는 한 단계씩만 진행되며 중복 완료와 휴학 중 진행을 막는다", () => {
  const state = {
    ...structuredClone(initialState),
    journeys: { design: { completed: 0, paused: false } },
  };
  const next = completeLesson(state, "design", 0, "  첫 관찰  ");
  assert.equal(next.journeys.design.completed, 1);
  assert.equal(next.notes["design-0"], "첫 관찰");
  assert.equal(completeLesson(next, "design", 0, "중복"), next);
  assert.equal(completeLesson(next, "design", 3, "건너뛰기"), next);
  const paused = {
    ...next,
    journeys: { design: { completed: 1, paused: true } },
  };
  assert.equal(completeLesson(paused, "design", 1, "쉬는 중"), paused);
});
test("8개의 실습을 끝내도 다른 학과의 진행 상태는 유지한다", () => {
  let state = {
    ...structuredClone(initialState),
    journeys: {
      design: { completed: 0, paused: false },
      psychology: { completed: 2, paused: true },
    },
  };
  for (let i = 0; i < 8; i++)
    state = completeLesson(state, "design", i, `기록 ${i}`);
  assert.equal(state.journeys.design.completed, 8);
  assert.equal(Object.keys(state.notes).length, 8);
  assert.deepEqual(state.journeys.psychology, { completed: 2, paused: true });
  assert.equal(completeLesson(state, "design", 8, "추가"), state);
});
