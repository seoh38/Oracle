/*
    <GROUP BY>
<<<<<<< HEAD
       그룹 기준을 제기할 수 있는 구문
       여러 개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용한다.

*/
-- 전체 사원을 하나의 그룹으로 묶어서 급여의 총합을 구한 결과
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 각 부서별 그룹으로 묶어서 부서별 급여의 총합을 구한 결과 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE NULLS FIRST;

-- 전체 사원 수
SELECT COUNT(*) 
FROM EMPLOYEE; 

-- 각 부서별 사원수
SELECT DEPT_CODE, COUNT(*) -- 그룹별로 행의 개수를 세어준다.
FROM EMPLOYEE
GROUP BY DEPT_CODE -- 하나의 그룹으로 묶어줌
ORDER BY DEPT_CODE NULLS FIRST;

-- 각 직급별 보너스를 받는 사원 수 조회
SELECT JOB_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 각 직급별 급여의 평균조회
SELECT JOB_CODE, 
       TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), '999,999,999') AS "급여 평균"
FROM EMPLOYEE;

-- 전체 사원수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 각 부서별 사원수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE NULLS FIRST;

-- 각 직급별 보너스를 받는 사원수 조회
SELECT JOB_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 1;

-- 각 직급별 급여 평균 조회
SELECT JOB_CODE AS "직급 코드", 
       TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), '99,999,999') AS "급여 평균"
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

<<<<<<< HEAD
-- 부서별 사원수, 보너스를 받는 사원수, 급여의 합계, 평균급여, 최고급여, 최저급여를 부서별 내림차순으로 조회
SELECT DEPT_CODE AS "부서", COUNT(*) AS "사원수", 
       COUNT(BONUS) AS "보너스 받는 사원수", 
       TO_CHAR(SUM(SALARY), '999,999,999') AS "급여 합계" , 
       TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), '999,999,999') AS "평균 급여", 
       TO_CHAR(MAX(SALARY), '999,999,999') AS "최고 급여", 
       TO_CHAR(MIN(SALARY), '999,999,999') AS "최저 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE DESC;

-- 성별 별 사원수
SELECT SUBSTR(EMP_NO, 8, 1) AS "성별", COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8,1) -- 컬럼명, 계산식, 함수호출 구문이 올수 있다. (단, 컬럼순번, 별칭은 사용할 수 없다.)
ORDER BY "성별";

-- 여러 컬럼을 제시해서 그룹 기준을 선정
SELECT DEPT_CODE AS "부서코드", JOB_CODE AS "직급 코드", 
       COUNT(*) AS "직원 수",
       TO_CHAR(SUM(SALARY), '999,999,999') AS "급여의 합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;

/*
    <HAVING>
      그룹에 대한 조건을 제시할 때 사용하는 구문 (주로 그룹함수의 결과를 가지고 비교 수행)
     
     * 실행 순서
     5 --> SELECT     : 조회하고자 하는 컬럼명 AS "별칭" | 계산식 | 함수식
     1 --> FROM       : 조회하고자 하는 테이블명
     2 --> WHERE      : (SELECT문의) 조건식
     3 --> GROUP BY   : 그룹기준에 해당하는 컬럼명 | 계산식 | 함수식 단, 별칭을 올수 없다!!
     4 --> HAVING     : 그룹에 대한 조건식
     6 --> ORDER BY   : 컬럼명 | 별칭 | 컬럼 순번 [ASC|DESC] [NULLS FIRST|NULLS LAST] 
     
*/
-- 각 부서별 급여가 300만원 이상인 직원의 평균 급여 조회
SELECT DEPT_CODE, AVG(SALARY)
=======
-- 부서별 사원수, 보너스를 받는 사원수, 급여의 합, 평균 급여, 최고 급여, 최저 급여를 부서별 내림차순으로 조회
SELECT DEPT_CODE AS "부서",
       COUNT(*) AS "사원수",
       COUNT(BONUS) AS "보너스를 받는 사원수",
       TO_CHAR(SUM(SALARY), '99,999,999') AS "급여의 합",
       TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), '99,999,999') AS "평균 급여",
       TO_CHAR(MAX(SALARY), '99,999,999') AS "최고 급여",
       TO_CHAR(MIN(SALARY), '99,999,999') AS "최저 급여"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE DESC NULLS LAST;

-- 성별 별 사원수
SELECT SUBSTR(EMP_NO, 8, 1) AS "성별"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1) -- 컬럼, 계산식, 함수 호출 구문이 올 수 있다. (단, 컬럼 순번, 별칭은 사용할 수 없다.)
ORDER BY "성별";

-- 여러 컬럼을 제시해서 그룹 기준을 선정
SELECT DEPT_CODE AS "부서 코드", 
       JOB_CODE AS "직급 코드", 
       COUNT(*) AS "직원수",
       SUM(SALARY) AS "급여의 합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

/*
    <HAVING>
      그룹에 대한 조건을 제시할 때 사용하는 구문(주로 그룹 함수의 결과를 가지고 비교 수행)
      
    * 실행 순서
      5: SELECT    조회하고자 하는 컬럼명 AS "별칭" | 계산식 | 함수식
      1: FROM      조회하고자 하는 테이블명
      2: WHERE     조건식
      3: GROUP BY  그룹 기준에 해당하는 컬럼명 | 계산식 | 함수식
      4: HAVING    그룹에 대한 조건식
      6: ORDER BY  컬럼명 | 별칭 | 컬럼 순번 [ASC|DESC] [NULLS FIRST|LAST]
*/

-- 각 부서별 급여가 300만원 이상인 직원의 평균 급여 조회
SELECT DEPT_CODE, AVG(NVL(SALARY, 0))
FROM EMPLOYEE
WHERE SALARY >= 3000000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

<<<<<<< HEAD
-- 각 부서별 평균급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), '99,999,999') AS "평균 급여"
FROM EMPLOYEE
-- GRPUP BY 보다 먼저 수행되기 때문에 에러가 발생한다.
-- WHERE TO_CHAR(FLOOR(AVG(NVL(SALARY, 0))), '99,999,999') AS "평균 급여" >= 3000000 --> 에러발생
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(NVL(SALARY, 0))) >=3000000
ORDER BY DEPT_CODE;

-- 직급별 총 급여의 합이 10000000 이상인 직금들만 조회
SELECT JOB_CODE, SUM(SALARY) 
=======
-- 각 부서별 평균 급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
-- WHERE FLOOR(AVG(NVL(SALARY, 0))) >= 3000000 -- 에러 발생
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(NVL(SALARY, 0))) >= 3000000
ORDER BY DEPT_CODE;

-- 직급별 총 급여의 합이 10000000 이상인 직급들만 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000
ORDER BY JOB_CODE;

<<<<<<< HEAD
-- 부서별 보너스를 받는 사원이 없는 부서만 조회
SELECT DEPT_CODE
=======
-- 부서별 보너스를 받는 사원이 없는 부서들만 조회
SELECT DEPT_CODE, COUNT(BONUS)
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0
ORDER BY DEPT_CODE;

/*
<<<<<<< HEAD
    <>
    
    
=======
    <집계 함수>
      그룹별 산출한 결과 값의 중간 집계를 계산 해주는 함수
      
      ROLLUP, CUBE
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
*/
-- 각 직급별 급여의 합계를 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

<<<<<<< HEAD
-- 마지막 행에 전체 총 급여 합계까지 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP (JOB_CODE)
ORDER BY JOB_CODE;
 
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE (JOB_CODE)
ORDER BY JOB_CODE;

-- 부서코드도 같고 직급코드도 같은 사원들을 그룹지어서 해당 급여의 합계를 조회
-- 마지막 행에 전체 총 급여의 합계까지 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE;

-- 부서 코드도 같고 직급 코드도 같은 사원들을 그룹 지어서 해당 급여의 합계를 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

<<<<<<< HEAD
-- ROLLUP(컬럼1, 컬럼2, ...) -> 컬럼1을 가지고 중간집계를 내는 함수
=======
-- ROLLUP(컬럼1, 컬럼2, ...) -> 컬럼 1을 가지고 중간집계를 내는 함수
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

<<<<<<< HEAD
-- CUBE(컬럼1, 컬럼2, ...) -> 컬럼1을 가지고 중간집계를 내고, 컬럼2를 자기고도 중간집계를 낸다. 
--                           즉, 전달되는 모든 컬럼의 중간집계를 낸다.
=======
-- CUBE(컬럼1, 컬럼2, ...) -> 컬럼 1을 가지고 중간집계를 내고, 컬럼 2를 가지고도 중간집계를 낸다. 즉, 전달되는 컬럼 모두를 집계한다.
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

/*
    <GROUPING>
<<<<<<< HEAD
      ROLLUP이나 CUBE에 의해 산출되는 값이 해당 컬럼의 집합의 산출물이면 0을 반환, 아니면 1을 반환하는 함수
*/
--
SELECT DEPT_CODE,
       JOB_CODE, 
       SUM(SALARY),
       GROUPING(DEPT_CODE),
       GROUPING(JOB_CODE)
FROM EMPLOYEE
GROUP BY ROLLUP (DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;
------------------------------------------------------------------

/*
    <집합 연산자>
      여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자이다.
      
      UNION     : 두 쿼리문을 수행한 결과값을 더한 후 중복되는 행은 중복을 제거한다. (합집합)
      UNION ALL : UNION과 동일하게 두 쿼리문을 수행한 결과값은 더하고 중복은 허용한다. (합집합)
      INTERSECT : 두 쿼리문을 수행한 결과값애 중복된 결과값만 추출한다. (교집합)
      MINUS     : 선행 결과값에서 후행 결과값을 뺀 나머지 결과값만 추출한다. (차집합)
*/
--EMPLOYEE 테이블에서 부서코드가 D5인 사원들만 조회
=======
      ROLLUP이나 CUBE에 의해 산출된 값이 해당 컬럼의 집합의 산출물이면 0을 반환, 아니면 1을 반환하는 함수
*/
SELECT DEPT_CODE, 
       JOB_CODE, 
       SUM(SALARY),
       GROUPING(DEPT_CODE),
       GROUPING(JOB_CODE)       
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

SELECT DEPT_CODE, 
       JOB_CODE, 
       SUM(SALARY),
       GROUPING(DEPT_CODE),
       GROUPING(JOB_CODE)       
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

/*
    <집합 연산자>
      여러 개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자이다.
      
      UNION     : 두 쿼리문을 수행한 결과값을 더한 후 중복되는 행은 제거한다. (합집합)
      UNION ALL : UNION과 동일하게 두 쿼리문을 수행한 결과값을 더하고 중복은 허용한다. (합집합)
      INTERSECT : 두 쿼리문을 수행한 결과값에 중복된 결과값만 추출한다. (교집합)
      MINUS     : 선행 결과값에서 후행 결과값을 뺀 나머지 결과값만 추출한다. (차집합)
*/
-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원들만 조회
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6명 조회

<<<<<<< HEAD
--EMPLOYEE 테이블에서 급여가 300만원 초과인 사원들
=======
-- EMPLOYEE 테이블에서 급여가 300만원 초과인 사원들만 조회
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8명 조회

<<<<<<< HEAD
-- 1) UNION
-- EMPLOYEE 테이블에서 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원 조회
=======
-- 1. UNION
-- EMPLOYEE 테이블에서 부서 코드가 D5인 사원 또는 급여가 300만원 초과인 사원 조회
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
<<<<<<< HEAD
WHERE SALARY > 3000000; 
=======
WHERE SALARY > 3000000;
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f

-- 위 쿼리문 대신에 WHERE 절에 OR를 사용해서 처리 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
<<<<<<< HEAD
WHERE DEPT_CODE ='D5' OR SALARY > 3000000; 

-- 2) UNION ALL
-- 중복을 허용해주기 때문에 UNION과 비슷하지만 결과는 다르다.
=======
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-- 2. UNION ALL
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
<<<<<<< HEAD
WHERE SALARY > 3000000; 

-- 3) INTERSECT
-- 교집합만 허용
-- EMPLOYEE 테이블에서 부서코드가 D5이면서 급여가 300만원 초과인 사원 조회
=======
WHERE SALARY > 3000000;

-- 3. INTERSECT
-- EMPLOYEE 테이블에서 부서 코드가 D5이면서 급여가 300만원 초과인 사원 조회
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
<<<<<<< HEAD
WHERE SALARY > 3000000; 

-- 위 쿼리문 대신에 WHERE 절에 AND를 사용해서 처리 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' AND SALARY > 3000000; 

-- 4)MINUS
-- 부서코드가 D5인 사원들 중에서 급여가 300만원 초과인 사원들을 제외해서 조회
=======
WHERE SALARY > 3000000;

-- 위 쿼리문 대신에 WHRER 절에 AND를 사용해서 처리 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

-- 4. MINUS
-- 부서 코드가 D5인 사원들 중에서 급여가 300만원 초과인 사원들을 제외해서 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; 

-- 위 쿼리를 사용하지 않고 AND문을 사용해서 처리 가능하다(조건문만 변경)
-- 집합연산자를 사용하는 것보다 효율적이다!
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000; 
--------------------------------------------------------------------

/*
    <GROUPING SETS>
      그룹별로 처리된 여러 개의 SELECT 문을 하나로 합친 결과를 원할때 사용한다.
*/
=======
WHERE SALARY > 3000000;

-- 위 쿼리문 대신에 WHRER 절에 AND를 사용해서 처리 가능
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;

/*
    <GROUPING SET>
      그룹 별로 처리된 여러 개의 SELECT 문을 하나로 합친 결과를 원할 때 사용한다.
*/

>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
-- 부서별 사원수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE

UNION ALL
-- 직급별 사원수
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE;

<<<<<<< HEAD
-- GROUPING SETS 사용
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY GROUPING SETS(DEPT_CODE, JOB_CODE);
-----------------------------------------------------------------
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID;

SELECT DEPT_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALㄴARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE, MANAGER_ID;

SELECT JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY JOB_CODE, MANAGER_ID;

-- GROUPING SETS 
-- 위의 3개의 쿼리를 각각 실해앻서 합친것과 동일한 결과를  갖는다.
-- 합쳐야 할 것이 많아지면 GROUPING SETS를 사용하자
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY GROUPING SETS ((DEPT_CODE,JOB_CODE), (DEPT_CODE, MANAGER_ID), (JOB_CODE, MANAGER_ID));
---------------------------------------------------------------------
=======
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY GROUPING SETS(DEPT_CODE, JOB_CODE);

--SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
--FROM EMPLOYEE
--GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID;

--SELECT DEPT_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
--FROM EMPLOYEE
--GROUP BY DEPT_CODE, MANAGER_ID;

--SELECT JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
--FROM EMPLOYEE
--GROUP BY JOB_CODE, MANAGER_ID;

-- 위의 쿼리를 각각 실행해서 합친 것과 동일한 결과를 갖는다.
SELECT DEPT_CODE, JOB_CODE, MANAGER_ID, FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY GROUPING SETS((DEPT_CODE, JOB_CODE, MANAGER_ID), (DEPT_CODE, MANAGER_ID), (JOB_CODE, MANAGER_ID));
>>>>>>> a4c3db5a00f1577378e06925b700cfe084daad1f
