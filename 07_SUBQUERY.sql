/*
    <SUBQUERY>
      하나의 SQL 문 안에 포함된 또 다른 SQL 문을 뜻한다.
      메인 쿼리(기존 쿼리)를 보조하는 역할을 하는 쿼리문이다.
      
      메인쿼리가 싱행되기 전에 한번만 실행된다.
      반드시 괄호()로 묶고, 비교연산자의 오른쪽에 기술해야 한다.
      단, 서브쿼리와 비교할 항목은 반드시 SELSET한 항목의 개수와 자료형을 일치시켜야한다.

*/
-- 서브 쿼리 예시
-- EMPLOYEE 테이블에서 노홍철 사원과 같은 부서원들을 조회하라
-- 1) 노옹철 사원의 부서코드 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE EMP_NAME ='노옹철';
-- 2) 부서 코드가 노옹철 사원의 부서 코드와 동일한 사원들을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';
-- 3) 위의 두 단계를 하나의 쿼리로 작성
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (
  SELECT DEPT_CODE 
  FROM EMPLOYEE
  WHERE EMP_NAME ='노옹철');
---------------------------------------------------------------

/*
    <서브 쿼리 구분>
      - 서브쿼리는 서브 쿼리를 수행한 결과값의 행과 열의 개수에 따라서 분류할 수 있다.
      
      1. 단일행 서브쿼리       : 서브 쿼리의 조회 결과 값의 행의 개수가 오로지 1개 일 때
      2. 다중행 서브쿼리       : 서브 쿼리의 조회 결과 값의 행의 개수가 여러 행 일 때
      3. 다중열 서브쿼리       : 서브 쿼리의 조회 결과 값이 한 행이지만 컬럼이 여러개 일 때 
      4. 다중행 다중열 서브쿼리 : 서브 쿼리의 결과 값이 여러 행 여러 열 일 때
      
      
      * 서브쿼리의 유형에 따라 서브 쿼리 앞에 붙는 연산자가 달라진다. (중요)
      
    <단일행 서브쿼리>
       서브 쿼리의 조회 결과 값의 행의 개수가 오로지 1개 일 때 (단일행, 단일열)
       비교 연산자를 사용 가능하다 (>, <, >=, <=, =, !=, <>, ^=...)
*/
----------------------------------------------------------------------
-- 1) 전 직원의 평균 급여보다 급여를 적게 받는 직원들의 이름, 직급코드, 급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE; -- 1행 1열

-- 위 쿼리를 서브쿼리로 사용하는 메인 쿼리 작성 
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE 
WHERE SALARY < 
  (SELECT AVG(SALARY) 
   FROM EMPLOYEE)
ORDER BY JOB_CODE;  

-- 2) 최저 급여를 받는 직원의 사번, 이름, 직급코드, 급여, 입사일
SELECT MIN(SALARY)
FROM EMPLOYEE; -- 1행 1열 (1380000)
-- 위 쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성
SELECT EMP_ID,
       EMP_NAME, 
       JOB_CODE, 
       SALARY, 
       HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (
   SELECT MIN(SALARY)
   FROM EMPLOYEE);
   
-- 3) 노옹철 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서명, 직급 코드 , 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';
-- 위 쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성(ANSI 구문)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE SALARY > (
   SELECT SALARY
   FROM EMPLOYEE
   WHERE EMP_NAME = '노옹철');
-- 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
  AND SALARY > (
   SELECT SALARY
   FROM EMPLOYEE
   WHERE EMP_NAME = '노옹철');

-- 4) 부서별 급여의 합이 가장 큰 부서의 부서 코드, 급여의 합 조회 (GROUPING)
SELECT MAX(SUM(SALARY)) 
FROM EMPLOYEE
GROUP BY DEPT_CODE;
-- * 서브쿼리는 WHERE절 뿐만 아니라, SELECT / FROM/ HAVING 에서 사용이 가능하다.
-- 위 쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE E
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
  SELECT MAX(SUM(SALARY)) 
  FROM EMPLOYEE
  GROUP BY DEPT_CODE);

-- 5) 전지연 사원이 속해있는 부서원들 조회(단, 전지연 사원은 제외)
-- 사번, 사원명, 전화번호, 직급명, 부서명, 입사일
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';
-- 위 쿼리를 서브 쿼리로 사용하는 메인 쿼리 작성(ANSI 구문)
SELECT E.EMP_ID, E.EMP_NAME, E.PHONE, J.JOB_NAME, D.DEPT_TITLE, E.HIRE_DATE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE E.DEPT_CODE = ( 
  SELECT DEPT_CODE
  FROM EMPLOYEE
  WHERE EMP_NAME = '전지연')
  AND E.EMP_NAME != '전지연';
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, E.PHONE, J.JOB_NAME, D.DEPT_TITLE, E.HIRE_DATE
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
  AND E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = ( 
  SELECT DEPT_CODE
  FROM EMPLOYEE
  WHERE EMP_NAME = '전지연')
  AND E.EMP_NAME != '전지연';

---------------------------------------------------------------------
/*
    <다중행 서브 쿼리>
       서브 쿼리의 조회 결과 갑스이 행의 개수가 여러개 일 때
       
       IN / NOT IN (서브 쿼리) : 여러개의 결과 값중에서 한개라도 일치하는 값이 있다면(IN) 혹은 없다면(NOT IN) TRUE를 리턴
       ANY : 여러개의 값들 중에서 한개라도 만족하면 TRUE, IN과 다른 점은 비교 연산자를 사용한다는 점이다.
             SALARY = ANY(...)  : IN과 같은 결과
             SALARY != ANY(...) : NOT IN과 같은 결과
             SALARY > ANY(...)  : 최소값 보다 크면 TRUE 리턴
             SALARY < ANY(...)  : 최대값 보다 작으면 TRUE 리턴
       ALL : 여러개의 값들 모두와 비교하여 만족해야만 TRUE를 리턴
             SALARY > ALL(...)  : 최대값 보다 크면 TRUE 리턴
             SALARY < ALL(...)  : 최소값 보다 작으면 TRUE 리턴

*/
-- 1) 각 부서별 최고 급여를 받는 직원의 이름, 직급 코드, 부서 코드 급여 조회
-- 부서별 최고 급여 조회
SELECT MAX(SALARY) 
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- (2890000,3660000,8000000,3760000,3900000,2490000,2550000)
-- 위 급여를 받는 사원들 조회
SELECT EMP_NAME, JOB_CODE, NVL(DEPT_CODE, '부서 없음'), SALARY
FROM EMPLOYEE
WHERE SALARY IN (2890000,3660000,8000000,3760000,3900000,2490000,2550000)
ORDER BY DEPT_CODE;
-- 두 쿼리문을 합쳐서 하나의 쿼리문으로 작성
SELECT EMP_NAME, JOB_CODE, NVL(DEPT_CODE, '부서 없음'), SALARY
FROM EMPLOYEE
WHERE SALARY IN (
  SELECT MAX(SALARY) 
  FROM EMPLOYEE
  GROUP BY DEPT_CODE
)
ORDER BY DEPT_CODE;

-- 2) 직원에 대해 사번, 이름, 부서 코드, 구분(사수/사원) 조회
-- 사수에 해당하는 사번을 조회
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL; -- (201,204,100,200,211,207,214)
-- 사번이 위와 같은 직원들의 사번, 이름, 부서코드, 구분(사수) 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사수' AS "구분"
FROM EMPLOYEE
WHERE EMP_ID IN(201,204,100,200,211,207,214);
-- 두 쿼리문을 합쳐서 하나의 쿼리문으로 작성
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사수' AS "구분"
FROM EMPLOYEE
WHERE EMP_ID IN(
  SELECT DISTINCT MANAGER_ID
  FROM EMPLOYEE
  WHERE MANAGER_ID IS NOT NULL
);

-- 일반 사원에 해당하는 정보 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사원' AS "구분"
FROM EMPLOYEE
WHERE EMP_ID NOT IN( -- 값을 만족하지 않는 사원들을 찾을때는 NOT IN
  SELECT DISTINCT MANAGER_ID
  FROM EMPLOYEE
  WHERE MANAGER_ID IS NOT NULL
);

-- 위의 결과들을 하나의 결과로 확인 (UNION) -> 집합연산자를 사용하여 하나로 확인
SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사수' AS "구분"
FROM EMPLOYEE
WHERE EMP_ID IN(
  SELECT DISTINCT MANAGER_ID
  FROM EMPLOYEE
  WHERE MANAGER_ID IS NOT NULL
)

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, '사원' AS "구분"
FROM EMPLOYEE
WHERE EMP_ID NOT IN( -- 값을 만족하지 않는 사원들을 찾을때는 NOT IN
  SELECT DISTINCT MANAGER_ID
  FROM EMPLOYEE
  WHERE MANAGER_ID IS NOT NULL
);

-- SELECT 절에 서브 쿼리를 사용하는 방법
SELECT EMP_ID, EMP_NAME, DEPT_CODE, 
  CASE 
      WHEN EMP_ID IN (201,204,100,200,211,207,214) THEN '사수'
      ELSE '사원'
  END AS "구분"
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, 
  CASE 
      WHEN EMP_ID IN (
            SELECT DISTINCT MANAGER_ID
            FROM EMPLOYEE
            WHERE MANAGER_ID IS NOT NULL
            )THEN '사수'
             ELSE '사원'
  END AS "구분"
FROM EMPLOYEE;

-- 3) 대리 직급임에도 과장 직급들의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급, 급여
-- 과장 직급들의 급여 정보
SELECT SALARY
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '과장'; --(2200000, 2500000, 3760000)

-- 직급이 대리인 직원들 중에서 위 목록들 값 중에 하나라도 큰 경우
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리'
  AND SALARY > ANY(2200000, 2500000, 3760000); -- SALARY > 220만 OR SALARY > 250만 OR SALARY >  376만

-- 한 개의 쿼리문으로 합쳐보기  
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리'
  AND SALARY > ANY(
       SELECT SALARY
       FROM EMPLOYEE E
       JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
       WHERE J.JOB_NAME = '과장');
       
-- 4) 과장 직급 임에도 차장 직급의 최대 급여보다 더 많이 받는 직원들의 사번, 이름, 직급, 급여
-- 차장 직급들의 급여 조회
SELECT SALARY
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '차장'; -- (2800000,1550000,2490000,2480000)
    
-- 과장 직급임에도 차장 직급의 최대 급여보다 많이 받는 직원 조회
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE J.JOB_NAME = '과장'
  AND SALARY > ALL (2800000,1550000,2490000,2480000);
  -- SALARY > 280만 ADN SALARY > 155만 AND SALARY > 249만 AND SALARY > 248만 을 모두 만족해야한다!!
  
-- 한개의 쿼리문으로 합쳐보기
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE)
WHERE J.JOB_NAME = '과장'
  AND SALARY > ALL (
       SELECT SALARY
       FROM EMPLOYEE E
       JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
       WHERE J.JOB_NAME = '차장');  
--------------------------------------------------------------------

/*
   <다중열 서브쿼리>
     서브 쿼리의 조회 결과 값은 한개의 행이지만 나열된 컬럼이 여러개 일 때
*/

-- 1) 하이유 사원과 같은 부서코드, 같은 직급코드의 해당하는 사원들을 조회
-- 하이유 사원의 부서코드와 직급코드 조회
SELECT DEPT_CODE, JOB_CODE 
FROM EMPLOYEE
WHERE EMP_NAME = '하이유'; -- D5, J5

-- 부서코드가 D5이면서 직급코드가 J5인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5'; 

-- 각각 단일행 서브쿼리로 작성(불편)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (
    SELECT DEPT_CODE -- 단일행 서브쿼리 
    FROM EMPLOYEE
    WHERE EMP_NAME = '하이유'
)
AND JOB_CODE = (
    SELECT JOB_CODE -- 단일행 서브쿼리
    FROM EMPLOYEE
    WHERE EMP_NAME = '하이유'
);

-- 다중열 서브쿼리를 사용해서 하나의 쿼리로 작성
SELECT EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = ( -- (('D5', 'J5')); -- 하나의 쌍으로 묶인 하나의 값!!
    SELECT DEPT_CODE, JOB_CODE -- 다중열 서브쿼리(비교할 쿼리들을 하나로 묶어준다)
    FROM EMPLOYEE
    WHERE EMP_NAME = '하이유'
);

-- 2) 박나라 사원과 직급코가 일치하면서 같은 사수를 가지고 있는 사원의 사번, 이름, 직급코드 사수 사번 조회
-- 박나라 사원의 직급코드와 사수의 사번을 조회
SELECT JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NAME = '박나라'; -- 'J7', 207

-- 다중열 서브쿼리를 사용해서 하나의 쿼리로 작성
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (
     SELECT JOB_CODE, MANAGER_ID
     FROM EMPLOYEE
     WHERE EMP_NAME = '박나라');
     
-- IN 사용해보기
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) IN (('J7', 207));
------------------------------------------------------------------

/*
    <다중행 다중열 서브쿼리>
      서브 쿼리의 조회 결과 값이 여러 행 여러 열일 경우
      
*/
-- 1) 각 직급별로 최소 급여를 받는 사원들의 사번, 이름, 직급코드, 급여 조회
--각 직급별 최소 급여
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE; 
-- 각 직급별로 최소급여를 받는 사원들의 사번, 이름, 직급코드, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000
   OR JOB_CODE = 'J7' AND SALARY = 1380000
   OR JOB_CODE = 'J3' AND SALARY = 3400000;
   
-- 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (('J2', 3700000), ('J7',1380000), ('J3',3400000));

-- 다중행 다중열 서브쿼리를 사용해서 각 직급별로 최소 급여를 받는 사원의 사번, 이름, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
   SELECT JOB_CODE, MIN(SALARY)
   FROM EMPLOYEE
   GROUP BY JOB_CODE)
ORDER BY JOB_CODE;

-- 2) 각 부서별 최소급여를 받는 사원들의 사번, 이름, 부서코드, 급여 조회
SELECT NVL(DEPT_CODE, '부서 없음'), MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE, '부서없음'), SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE, '부서없음'), SALARY) IN (
   SELECT NVL(DEPT_CODE, '부서 없음'), MIN(SALARY)
   FROM EMPLOYEE
   GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;
------------------------------------------------------------------------

/*
    <인라인 뷰>
      FROM절에 서브쿼리를 제시하고, 서브쿼리를 수행한 결과를 테이블 대신에 사용한다.
*/
-- 1) 인라인 뷰를 활용한 TOP-N 분석
-- 전 직원중에 급여가 가장 높은 상위 5명 의 순위 이름, 급여 조회
--   * ROWNUM : 오라클에서 제공하는 컬럼, 조회된 순서대로 1부터 순번을 부여하는 컬럼이다.
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
-- 쿼리문이 실행되는 순서 때문에 !! --> 원하지 않는 순서대로 정렬이된다.
-- 이미 순번이 정해진 다음에 정렬이 되었다.
-- FROM -> SELECT(순번이 정해진다.) -> ORDER BY

-- 해결 방법
-- ORDER BY 한 결과값을 가지고 ROWNUM을 부여하면 된다. (인라인 뷰 사용)
SELECT ROWNUM AS "순위", 
       EMP_NAME AS "사원명", 
       SALARY AS "급여"
FROM(
   SELECT EMP_NAME, SALARY
   FROM EMPLOYEE
   ORDER BY SALARY DESC) --> 쿼리 결과를 테이블 대신에 사용하겠다.
WHERE ROWNUM <= 5;   --> 상위 5명만 조회

-- 2) 부서별 평균 급여가 높은 3개 부서의 부서코드, 평균 급여 조회
-- 부서별 평균 급여
SELECT DEPT_CODE, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY FLOOR(AVG(NVL(SALARY, 0))) DESC;

SELECT ROWNUM, DEPT_CODE, ROUND(평균급여) 
FROM (
<<<<<<< HEAD:06_SUBQUERY.sql
   SELECT DEPT_CODE, 
          AVG(NVL(SALARY, 0)) AS "평균급여"
   FROM EMPLOYEE
   GROUP BY DEPT_CODE
   ORDER BY AVG(NVL(SALARY, 0)) DESC) --> 정렬 결과를 만든다음 테이블로 지정해준다.
WHERE ROWNUM <= 3;   

-- 2-1) WITH를 이용한 방법
WITH TOPN_SAL AS (
    SELECT DEPT_CODE, 
=======
    SELECT NVL(DEPT_CODE, '부서없음') AS "DEPT_CODE", 
           AVG(NVL(SALARY, 0)) AS "평균급여"
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY 2 DESC
)
WHERE ROWNUM <= 3;

-- 2-1) WITH를 이용한 방법
WITH TOPN_SAL AS (
    SELECT NVL(DEPT_CODE, '부서없음') AS "DEPT_CODE", 
>>>>>>> d28b29d849215ca7ed90aa0442bc5ffb11524793:07_SUBQUERY.sql
           AVG(NVL(SALARY, 0)) AS "평균급여"
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
    ORDER BY AVG(NVL(SALARY, 0)) DESC
)

SELECT DEPT_CODE, ROUND(평균급여)
<<<<<<< HEAD:06_SUBQUERY.sql
FROM TOPN_SAL --> 이름을 지정한 서브쿼리를 테이블로 지정!
WHERE ROWNUM <= 3;
-------------------------------------------------------------  
/*
    <RANK 함수>
        [표현법]
           RANK() OVER(정렬기준) / DENSE_RANK() OVER(정렬기준)
           
        RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너뛰고 순위를 계산한다.
                                 (공동 1위가 2명이면 그 다음 순위는 3위)
                                 
        DENSE_RANK() OVER(정렬기준) : 동일한 순위이후의 등수를 무조건 1씩 증가한다.
                                         (공동 1위가 2명이면 다음 순위는 2위)
*/
-- 사원별 급여가 높은 순서대로 순위를 매겨서 순위, 사원명, 급여 조회
-- RANK() OVER(정렬기준)
-- 공동 19위 2명 뒤에 순위는 21위
SELECT RANK()OVER(ORDER BY SALARY DESC) AS "RANK", EMP_NAME, SALARY
FROM EMPLOYEE;
-- DENSSE_RANK() OVER(정렬기준)
-- 공동 19위 2명 뒤에 순위는 20위
SELECT DENSE_RANK()OVER(ORDER BY SALARY DESC) AS "RANK", EMP_NAME, SALARY
FROM EMPLOYEE;

-- 상위 5명만 조회(RANK절은 SELECT 에서만 사용이 가능하다.)
SELECT RANK()OVER(ORDER BY SALARY DESC) AS "RANK", EMP_NAME, SALARY
FROM EMPLOYEE;
-- WHERE RANK()OVER(ORDER BY SALARY DESC) <= 5; -- WHERE절 에서는 RANK를 사용할 수 없다.
   
-- 상위 5명만 조회(RANK를 서브쿼리로 쓰기)
SELECT RANK, EMP_NAME, SALARY
FROM(
     SELECT RANK()OVER(ORDER BY SALARY DESC) AS "RANK", 
     EMP_NAME, SALARY
     FROM EMPLOYEE)
WHERE RANK <=5;
   
=======
FROM TOPN_SAL
WHERE ROWNUM <= 3;

-------------------------------------------------------------------
/*
    <RANK 함수>
        [표현법]
            RANK() OVER(정렬 기준) / DENSE_RANK() OVER(정렬 기준)

        RANK() OVER(정렬 기준)       : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너뛰고 순위를 계산한다. (ex. 공동 1위가 2명이명 다음 순위는 3위)
        DENSE_RANK() OVER(정렬 기준) : 동일한 순위 이후의 등수를 무조건 1씩 증가한다. (ex. 공동 1위가 2명이면 다음 순위는 2위 )
*/
-- 사원별 급여가 높은 순서대로 순위를 매겨서 순위, 사원명, 급여 조회
-- 공동 19위 2명 뒤에 순위는 21위
SELECT RANK() OVER(ORDER BY SALARY DESC) AS "RANK" ,EMP_NAME, SALARY
FROM EMPLOYEE;

-- 공동 19위 2명 뒤에 순위는 20위
SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "RANK" ,EMP_NAME, SALARY
FROM EMPLOYEE;

-- 상위 5명만 조회
SELECT RANK() OVER(ORDER BY SALARY DESC) AS "RANK" ,EMP_NAME, SALARY
FROM EMPLOYEE
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5; -- RANK 함수는 WHERE 절에 사용할 수 없다.

SELECT RANK, EMP_NAME, SALARY
FROM (
    SELECT RANK() OVER(ORDER BY SALARY DESC) AS "RANK" ,EMP_NAME, SALARY
    FROM EMPLOYEE
)
WHERE RANK <= 5;
>>>>>>> d28b29d849215ca7ed90aa0442bc5ffb11524793:07_SUBQUERY.sql
