-- BASIC SELECT
-- 1) 춘 대학교의 학과이름과 계열을 표시하시오.
--    단, 출력헤더는 '학과 명', '계열', 으로 표시하도록 한다.
SELECT DEPARTMENT_NAME AS "학과명", 
       CATEGORY AS "계열"
FROM TB_DEPARTMENT;       

-- 2) 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
SELECT DEPARTMENT_NAME || '의 정원은' ||CAPACITY || '명 입니다.' AS "학과별 정원"
FROM TB_DEPARTMENT;

-- 3) '국어 국문학과' 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 들어와있다.
--     누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아내도록하자)
SELECT *
FROM TB_DEPARTMENT
WHERE DEPARTMENT_NAME = '국어국문학과';

-- JOIN해서 풀어보기
SELECT TS.STUDENT_NAME
FROM TB_STUDENT TS
JOIN TB_DEPARTMENT TB ON(TS.DEPARTMENT_NO = TB.DEPARTMENT_NO)
WHERE TB.DEPARTMENT_NAME = '국어국문학과'
  AND SUBSTR(TS.STUDENT_SSN, 8, 1) = 2
  AND TS.ABSENCE_YN = 'Y';

-- 4) 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시하고자 한다. 
--    그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL문을 작성하시오


-- 5) 입학정원이 20면 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오

-- 6) 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속학과를 가지고 있다.
--    그럼 춘기술대학교 총장의 이름을 알나낼수 있는 SQL 문장을 작성하시오.
SELECT *
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7) 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다.
--    어떠한 SQL 문장을 사용하면 될 것인지 작성하시오
SELECT *
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- 8) 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 
--    선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오(셀프조인 해준다.)
SELECT TC1.CLASS_NO, TC1.CLASS_NAME, TC1.PREATTENDING_CLASS_NO, TC2.CLASS_NAME
FROM TB_CLASS TC1
JOIN TB_CLASS TC2 ON(TC1.PREATTENDING_CLASS_NO = TC2.CLASS_NO)
WHERE TC1.PREATTENDING_CLASS_NO IS NOT NULL;

-- 9) 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오

-- 10 ) 02 학번 전주 거주자들의 모임을 만들려고 한다. 
--      휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름 주민번호를 출력하는 구문을 작성하시오
SELECT STUDENT_NO AS 학번,
       STUDENT_NAME AS 이름,
       STUDENT_SSN AS 주민번호,
       STUDENT_ADDRESS,
       ABSENCE_YN,
       ENTRANCE_DATE AS 입학년도
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) = 2002
      AND STUDENT_ADDRESS LIKE '%전주%' 
      AND ABSENCE_YN = 'N';
-- WHERE ENTRANCE_DATE LIKE '02%'


--------------------------------------------------------------------------------------
-- SELECT 함수
-- 1) 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학년도를 입학 년도가 빠른 순으로 표시하는 SQL문장을 작성하시오.
--    단 , 헤더는 '학번',''이름', '입학년도' 가 표시되도록한다.
SELECT STUDENT_NO AS 학번, 
       STUDENT_NAME AS 이름, 
       TO_CHAR(ENTRANCE_DATE, 'YYYY-MM-DD') AS 입학년도
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '002' 
ORDER BY ENTRANCE_DATE;

-- 2)
SELECT PROFESSOR_NAME, PROFESSOR_SSN 
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';
-- WHERE LENTGH(PROFESSOR_NAME) != 3; -- 좋음!

-- 3)
SELECT PROFESSOR_NAME AS 이름, 
       FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE('19' || SUBSTR(PROFESSOR_SSN, 1, 2), 'YYYY')) / 12) AS 나이
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = '1'
ORDER BY 2, 1; -- 2번을 먼저 정렬하고 1번을 정렬

-- 4)(SUBSTR)


-- 5)춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가?
--   이때, 19 살에 입학하면 재수하지 않은 것으로 간주한다.   ??? 어려웡
SELECT STUDENT_NO, 
       STUDENT_NAME, 
       MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD')) / 12 AS "나이"
FROM TB_STUDENT
WHERE MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD')) / 12 > 19
  AND MONTHS_BETWEEN(ENTRANCE_DATE, TO_DATE(SUBSTR(STUDENT_SSN, 1, 6), 'RRMMDD')) / 12 <= 20;
  
-- 6)
SELECT TO_CHAR(TO_DATE('2021/12/25'), 'DAY')
FROM DUAL;

-- 7)


-- 8)


-- 9)


-- 10) COUNT


-- 11)
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12)
SELECT SUBSTR(TERM_NO, 1, 4) AS "년도", ROUND(AVG(NVL(POINT, 0)), 1) AS "년도 별 평점" 
FROM TB_GRADE
WHERE STUDENT_NO ='A112113'
GROUP BY SUBSTR(TERM_NO, 1, 4)
ORDER BY 1;

-- 13) 학과별 휴학생 수를 파악하려고 한다. 학과 번호와 휴학생 수를 표시하는 SQL문장을 작성하시오
SELECT DEPARTMENT_NO, COUNT(DECODE(ABSENCE_YN, 'Y', ABSENCE_YN, NULL))
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 14) 춘 대학교에 다니는 동명이인 학생들의 이름을 찾고자 한다. 어떤 SQL 문장을 사용하면 가능하겠는가?
SELECT STUDENT_NAME, COUNT(STUDENT_NAME)
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(STUDENT_NAME) >= 2;

-- 15)  학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 
--      총평점을 구하는 SQL 문을 작성하시오. (단, 평점은 소수점 1 자리까지맊 반올림하여 표시한다.)
-- ROLLUP 함수사용해서 추가적 집꼐 결과를 반환해준다.
SELECT SUBSTR(TERM_NO, 1, 4) AS "년도", 
       SUBSTR(TERM_NO, 5) AS "학기",
       ROUND(AVG(NVL(POINT, 0)), 1) AS "평균"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5))
ORDER BY SUBSTR(TERM_NO, 1, 4);

-- SELECT OPTION
-- 1) 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고,
--    정렬은 이름으로 오름차순 표시하도록 한다.

-- 2) 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.

-- 3) 주소지가 강원도나 경기도인 학생들 중 1900 년대 학번을 가진 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오. 
--    단, 출력헤더에는 "학생이름","학번", "거주지 주소" 가 출력되도록 핚다.

-- 4) 현재 법학과 교수 중 가장 나이가 맋은 사람부터 이름을 확인핛 수 있는 SQL 문장을작성하시오. 
--    (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아내도록 하자)


-- 5)  2004 년 2 학기에 'C3118100' 과목을 수강핚 학생들의 학점을 조회하려고 핚다. 학점이높은 학생부터 표시하고, 
--     학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.

-- 6) 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오.
SELECT * FROM TB_STUDENT;
SELECT * FROM TB_DEPARTMENT;

SELECT S.STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
ORDER BY S.STUDENT_NAME;

-- 7)  춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.


-- 8) 과목별 교수 이름을 찾으려고 핚다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
SELECT C.CLASS_NAME AS "과목 이름", 
       P.PROFESSOR_NAME AS "교수 이름" 
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
JOIN TB_PROFESSOR P ON(CP.PROFESSOR_NO = P.PROFESSOR_NO);

-- 9) 8 번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 한다. 
--    이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
SELECT C.CLASS_NAME AS "과목 이름", 
       P.PROFESSOR_NAME AS "교수 이름" 
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
JOIN TB_PROFESSOR P ON(CP.PROFESSOR_NO = P.PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.CATEGORY LIKE '%인문사회%'
ORDER BY 2;

-- 10) ‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름", "전체 평점"을 출력하는 SQL 문장을 작성하시오. 
--   (단, 평점은 소수점 1 자리까지만 반올림하여 표시핚다.)
SELECT S.STUDENT_NO AS "학번",
       S.STUDENT_NAME AS "학생이름",
       ROUND(AVG(NVL(POINT, 0)), 1) AS "전체 평점"
FROM TB_GRADE G
JOIN TB_STUDENT S ON(G.STUDENT_NO = S.STUDENT_NO)
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '음악학과'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME  
ORDER BY S.STUDENT_NAME;

-- 11) 학번이 A313047 인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다.
--    이때 사용할 SQL 문을 작성하시오. 단, 출력헤더는 ‚학과이름‛, ‚학생이름‛, ‚지도교수이름‛으로 출력되도록 한다.



-- 12)  2007 년도에 '인갂관계롞' 과목을 수강한 학생을 찾아 학생이름과 수강학기름 표시하는 SQL 문장을 작성하시오.



-- 13) 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목이름과 학과 이름을 출력하는 SQL 문장을 작성하시오
SELECT C.CLASS_NAME, D.DEPARTMENT_NAME
FROM TB_CLASS C
LEFT JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
WHERE D.CATEGORY = '예체능'
   AND CP.PROFESSOR_NO IS NULL;

-- 14) 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과 지도교수 이름을 찾고 
--    만일 지도 교수가 없는 학생일 경우 "지도교수 미지정‛으로 표시하도록 하는 SQL 문을 작성하시오. 
--    단, 출력헤더는 ‚학생이름‛, ‚지도교수‛로표시하며 고학번 학생이 먼저 표시되도록 핚다


-- 15)  휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과이름, 평점을 출력하는 SQL 문을 작성하시오
SELECT S.STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME, ROUND(AVG(NVL(POINT, 0)), 1)
FROM TB_STUDENT S
JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME
HAVING AVG(NVL(POINT, 0)) >= 4
ORDER BY 1;

-- 16) 환경조경학과 젂공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.


-- 17) 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL 문을 작성하시오.


-- 18) 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을 작성하시오.
SELECT S.STUDENT_NAME, S.STUDENT_NO
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
WHERE DEPARTMENT_NAME = '국어국문학과'
GROUP BY S.STUDENT_NAME, S.STUDENT_NO
HAVING AVG(POINT) = ( -- 서브쿼리....?
    SELECT MAX(AVG(G.POINT))
    FROM TB_STUDENT S
    JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
    JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
    WHERE DEPARTMENT_NAME = '국어국문학과'
    GROUP BY S.STUDENT_NO
);

-- 19) 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL 문을 찾아내시오. 
--   단, 출력헤더는 "계열 학과명", "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다.













