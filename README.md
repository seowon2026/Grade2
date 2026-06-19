# Seowon University Grade 2

서원대학교 2학년 과목별 학습 자료와 과제, 실습 코드, 비교과 활동 자료를 정리한 통합 저장소입니다.  
각 과목은 개별 GitHub 저장소로 관리되며, 이 저장소에서는 서브모듈로 연결합니다.

---

## 📚 과목 저장소

| 과목 | GitHub 저장소 | 주요 내용 |
| --- | --- | --- |
| 데이터구조 | [`Data-Structure`](https://github.com/seowon2026/Data-Structure) | C 예제 코드, 장별 PDF, 과제, 시험 대비 자료 |
| 웹프로그래밍1 | [`Web-Programming1`](https://github.com/seowon2026/Web-Programming1) | HTML/CSS/JavaScript/JSP/SQL 교육자료와 실습 코드 |
| IoT기초실험 | [`IoT-Basic-Experiment`](https://github.com/seowon2026/IoT-Basic-Experiment) | Arduino 실습, 센서 예제, App Inventor, 기말 프로젝트 |
| 논리회로 | [`Logic-Circuit`](https://github.com/seowon2026/Logic-Circuit) | 논리회로 강의자료, LogicWorks 실습, 팀 과제 |
| 알고리즘 | [`Algorithm`](https://github.com/seowon2026/Algorithm) | 알고리즘 강의자료와 단원별 PDF |
| 리턴 프로젝트 | [`Return-Project`](https://github.com/seowon2026/Return-Project) | 비교과 리턴 프로젝트 워크시트, PPT, 최종 소감문 |
| SU진로코칭Ⅱ | [`SU-Career-Coaching-II`](https://github.com/seowon2026/SU-Career-Coaching-II) | 진로 목표 설정 프로젝트 보고서 |

---

## 🧭 폴더명 운영 방식

평소에는 한글 폴더명으로 사용하고, GitHub 업로드와 서브모듈 작업 시에는 영문 폴더명으로 전환합니다.

| 평시 폴더명 | 업로드 폴더명 |
| --- | --- |
| `데이터구조` | `Data-Structure` |
| `웹프로그래밍1` | `Web-Programming1` |
| `IoT기초실험` | `IoT-Basic-Experiment` |
| `논리회로` | `Logic-Circuit` |
| `알고리즘` | `Algorithm` |
| `리턴 프로젝트 (비교과)` | `Return-Project` |
| `ＳＵ진로코칭Ⅱ` | `SU-Career-Coaching-II` |

```bash
bash gitname.sh status
bash gitname.sh english
bash gitname.sh korean
```

---

## 🚀 전체 업로드

`allgit.sh`는 7개 과목 저장소를 순서대로 커밋/푸시한 뒤, 부모 저장소의 서브모듈 포인터를 갱신합니다.

```bash
bash allgit.sh
```

실제 커밋 없이 변경 상태만 확인하려면:

```bash
bash allgit.sh --dry-run
```

---

## 🔗 중첩 서브모듈

IoT기초실험의 기말 프로젝트는 별도 저장소로 연결되어 있습니다.

| 경로 | 연결 저장소 |
| --- | --- |
| `IoT-Basic-Experiment/기말 프로젝트/SmartCarPark` | [`hy040504/IoTProject-SmartCarPark`](https://github.com/hy040504/IoTProject-SmartCarPark) |

GitHub에서 해당 경로를 클릭하면 스마트 주차장 프로젝트 저장소로 이동합니다.
