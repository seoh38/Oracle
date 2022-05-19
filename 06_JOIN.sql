/*
    <JOIN>
      두 개 이상의 테이블에서 데이터를 조회하고자 할때 사용되는 구문
      무작정 데이터를 가져오는게 아니라 각 테이블 간에 공통된 컬럼(데이터 타입)으로 데이터를 합쳐서 하나의 결과(RESULT SET)로 조회한다. 
 
      1. 등가 조인(EQUAL JOIN) / 내부 조인(INNER JOIN)
       - 연결시키는 컬럼의 값이 일치하는 행들만 조인돼서 조회한다. (일치하는 값이 없는 행은 조회 X)
         1) 오라클 전용 구문
            [표현법]
               SELECT 컬럼, 컬럼, 컬럼....
               FROM 테이블1, 테이블2
               WHERE 테이블1. 컬럼명 = 테이블2. 컬럼명;
               
            - FROM 절에 조회하고자하는 테이블들을 콤마로(,) 구분하여 나열한다.
            - WHERE 절에 매칭 시킬 컬럼명에 대한 조건을 제시한다.
         
         2) ANSI 표준 구문
            [표현법]
              SELECT 컬럼, 컬럼, 컬럼....
              FROM 테이블1
              JOIN 테이블2 ON(테이블1. 컬럼명 = 테이블2. 컬럼명)
                   테이블2 USING()
             - FROM 절에 기준이 되는 테이블을 기술한다.
             - JOIN절에 같이 조회하고자 하는 테이블을 기술후 매칭시키 컬럼에 대한 조건을 기술한다.
             - 연결에 사용하려는 컬럼명이 같은 경우 ON 구문 대신에 USING 구문을 사용한다.
       
*/
/*
-- 각 사원들의 사번, 사원명, 부서코드, 부서명을 조회
        두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문이다.
        무작정 데이터를 가져오는게 아니라 각 테이블 간에 공통된 컬럼으로 데이터를 합쳐서 하나의 결과(RESULT SET)로 조회한다.
        
        1. 등가 조인(EQUAL JOIN) / 내부 조인(INNER JOIN)
            연결시키는 컬럼의 값이 일치하는 행들만 조인되서 조회한다. (일치하는 값이 없는 행은 조회 X)
            
            1) 오라클 전용 구문
                [표현법]
                    SELECT 컬럼, 컬럼, 컬럼, ...
                    FROM 테이블1, 테이블2
                    WHERE 테이블1.컬럼명 = 테이블2.컬럼명;
                    
                - FROM 절에 조회하고자 하는 테이블들을 콤마로(,) 구분하여 나열한다.
                - WHERE 절에 매칭 시킬 컬럼명에 대한 조건을 제시한다.
                
            2) ANSI 표준 구문
                [표현법]
                    SELECT 컬럼, 컬럼, 컬럼, ...
                    FROM 테이블1
                    [INNER] JOIN 테이블2 ON(테이블1.컬럼명 = 테이블2.컬럼명);
                    
                - FROM 절에 기준이 되는 테이블을 기술한다.
                - JOIN 절에 같이 조회하고자 하는 테이블을 기술 후 매칭 시킬 컬럼에 대한 조건을 기술한다.
                - 연결에 사용하려는 컬럼명이 같은 경우 ON 구문 대신에 USING(컬럼명) 구문을 사용한다.
*/

-- 각 사원들의 사번, 사원명, 부서 코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 각 사원들의 사번, 사원명, 부서코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;
-- 각 사원들의 사번, 사원명, 부서 코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

-- > 나는 테이블을 한번에 보고싶어~!

-- 오라클 구문
-- 1-1) 연결할 두 컬럼이 다른 경우
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여, 사번, 사원명, 부서코드, 부서명을 조회
-- 일치하는 값이 없는 행은 조회에서 제외된다. (DEPT_CODE가 NULL인 사원, DEPT_ID가 D3, D4 D7인 사원)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT -- 두개의 테이블을 하나의 결과로 보여준다.
WHERE DEPT_CODE = DEPT_ID; -- 같은 데이터를 가진 컬럼을 합쳐준다(EQUAL JOIN)

-- 1-2) 연결할 컬럼명이 같은 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 사원명, 직급코드, 직급명을 조회
-- 방법 1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
-- SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME -- JOB_CODE가 EMPLOYEE 테이블인지 JOB테이블인지 모호해서 에러가 난다.
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법 2) 테이블의 별칭을 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J -- 별칭을 지정해줌
WHERE E.JOB_CODE = J.JOB_CODE;

-- ANSI 구문
-- 2-1) 연결할 두 컬럼이 다른 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 사원명, 직급코드, 직급명을 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE 
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID); -- INNER은 생략 가능

-- 2-2) 연결할 두 컬럼이 같은 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 사원명, 직급코드, 직급명을 조회
-- 방법 1) USING 구문을 이용하는 방법
SELECT  E.EMP_ID, E.EMP_NAME, JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J USING(JOB_CODE); -- USING은 같은 컬럼이라고 인식해서 AMBIGUOUSLY(애매하다)가 발생하지 않는다.
                            -- 두 테이블의 동일한 컬럼만 입력해주면 된다. USING(JOB_CODE)     
-- 방법 2) 테이블의 별칭을 이용하는 방법
SELECT  E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME -- 별칭을 명시해준다
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 방법 3) NATURAL JOIN을 이용하는 방법(참고만 하기~)
-- 자동으로 동일한 타입과 이름을 가진 컬럼을 찾아서 JOIN을 해준다.
-- 같은 이름을 가진 컬럼을 모두 JOIN 해주기 때문에 원하지 않는 결과가 나올 수 있다.
-- JOIN 하려는 컬럼을 명시해 주는 것이 좋다!!!!!
SELECT  EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
NATURAL JOIN JOB;

-- 연습문제
-- EMPLOYEE 테이블과 JOB 테이블을 JOIN하여 직급이 대리인 사원의 사번 , 사원명, 직급명, 급여조회
--오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SLALRY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND J.J0B_NAME = '대리';
-- 오라클 구문
-- 1-1)연결할 두 컬럼이 다른 경우
-- EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인하여 사번, 사원명, 부서 코드, 부서명을 조회
-- 일치하는 값이 없는 행은 조회에서 제외된다. (DEPT_CODE가 NULL인 사원, DEPT_ID D3, D4, D7인 사원)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 1-2) 연결할 두 컬럼명이 같은 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 사원명, 직급 코드 직급명을 조회
-- 방법 1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 방법 2) 테이블의 별칭을 이용하는 방법 
SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- ANSI 구문
-- 2-1)연결할 두 컬럼이 다른 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 사원명, 직급 코드 직급명을 조회
SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE
FROM EMPLOYEE E
/*INNER*/ JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

-- 2-2) 연결할 두 컬럼명이 같은 경우
-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 사번, 사원명, 직급 코드 직급명을 조회
-- 방법 1) USING 구문을 이용하는 방법
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE); -- USING은 같은 컬럼이라고 인식해서 ambiguously 발생하지 않는다.

-- 방법 2) 테이블의 별칭을 이용하는 방법 
SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 방법 3) NATURAL JOIN을 이용하는 방법 (참고만 하세요~!)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- EMPLOYEE 테이블과 JOB 테이블을 조인하여 직급이 대리인 사원의 사번, 사원명, 직급명, 급여를 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND J.JOB_NAME = '대리';

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, E.SALARY
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE =  J.JOB_CODE)
WHERE J.JOB_NAME = '대리';

---------------------------- 실습 문제 --------------------------------------
SELECT * FROM DEPARTMENT;
SELECT *FROM LOCATION;
SELECT * FROM EMPLOYEE;
SELECT * FROM NATIONAL;

-- 1. DEPARTMENT 테이블과 LOCATION 테이블을 JOIN하여 부서코드, 부서명, 지역코드, 지역명을 조회
-- 오라클 구문
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.LOCAL_NAME 
FROM DEPARTMENT D, LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;
-- ANSI구문
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.LOCAL_NAME
FROM DEPARTMENT D
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);

-- 2. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, E.BONUS, D.DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE (E.DEPT_CODE = D.DEPT_ID) AND E.BONUS IS NOT NULL;
--ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.BONUS, D.DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE E.BONUS IS NOT NULL;  

-- 3. EMPLOYEE테이블과 DEPARTMENT 테이블을 조인해서 인사관리부가 아닌 사원들의 사원명, 부서명, 급여 조회
--오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY 
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND D.DEPT_TITLE != '인사관리부';
--ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY 
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE D.DEPT_TITLE != '인사관리부';

-- 4. EMPLOYEE테이블과 DEPARTMENT 테이블, LOCATION테이블을 조인해서 사번, 사원명, 부서명, 지역명를 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE;
-- ANSI 구문
-- 다중 조인은 순서가 굉장히 중요하다. (EMPLOYEE E와 DEPARTMENT D를 먼저 JOIN) ->JOIN된 값을 가지고 LOCATION을 조인해줌
-- ANSI구문에서 조인을 하기 위해서는 조인하기 위한 모든 테이블을 적어 줘야한다.
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE); 

-- 5. 사번, 사원명, 부서명, 지역명, 국가명 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE
      AND L.NATIONAL_CODE = N.NATIONAL_CODE;
-- ANSI구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE);


-- 6.  사번, 사원명, 부서명, 지역명, 국가명, 급여 등급 조회(NON EQUAL JOIN후에 실습 조회)
SELECT * FROM DEPARTMENT;
SELECT *FROM LOCATION;
SELECT * FROM EMPLOYEE;
SELECT * FROM NATIONAL;
------------------------------------------------------------------------------

/*
    2. 외부 조인 (OUTER JOIN)
       - 테이블간에 JOIN 시 일치하지 않는 행도 포함시켜서 조회가 가능하다.
         단, 반드시 기준이 되는 테이블(컬럼)을 지정해야 한다. (LEFI/RIGHT/(+))
*/

-- OUTTER JOIN과 비교할 INNER JOIN 구하기
-- 부서가 지정되지 않는 사원 2명에 대한 정보가 조회되지 않는다.
-- 부서가 지정되어 있어서 DEPARTMENT에 부서에 대한 정보가 없으면 조회되지 않는다.
SELECT E.EMP_NAME, D.DEPT_CODE, E.DALARY, E.SALARY * 12
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행한다.
-- ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+);

-- 2) RIGHT [OUTER] JOIN : 두 테이블중 오른편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행한다.
-- ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12
FROM EMPLOYEE E
RIGHT OUTER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);
-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회할 수 있다. (단, 오라클 구문은 지원하지 않는다) 
-- ANSI 구문만 지원
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12
FROM EMPLOYEE E
FULL OUTER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);
-- 오라클 구문에서는 FULL OUTER 구문은 지원하지 않음(에러)
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID(+);

 ------------------------------------ 실습 문제 --------------------------------------
-- 1. DEPARTMENT 테이블과 LOCATION 테이블의 조인하여 부서 코드, 부서명, 지역 코드, 지역명을 조회
-- 오라클 구문
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.NATIONAL_CODE
FROM DEPARTMENT D, LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;

-- ANSI 구문
SELECT D.DEPT_ID, D.DEPT_TITLE, D.LOCATION_ID, L.NATIONAL_CODE
FROM DEPARTMENT D
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);

-- 2. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명을 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, E.BONUS, D.DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND NVL(BONUS, 0) > 0 ;

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, E.BONUS, D.DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE BONUS IS NOT NULL;

-- 3. EMPLOYEE 테이블과 DEPARTMENT 테이블을 조인해서 인사관리부가 아닌 사원들의 사원명, 부서명, 급여를 조회
-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND D.DEPT_TITLE != '인사관리부'; 

-- ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE D.DEPT_ID != 'D1';


SELECT * FROM EMPLOYEE;     -- DEPT_CODE
SELECT * FROM DEPARTMENT;   -- DPET_ID      LOCATION_ID 
SELECT * FROM LOCATION;     --              LOCAL_CODE      NATIONAL_CODE
SELECT * FROM NATIONAL;     --                              NATIONAL_CODE            

-- 4. EMPLOYEE 테이블, DEPARTMENT 테이블, LOCATION 테이블의 조인해서 사번, 사원명, 부서명, 지역명 조회
-- 오라클 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE /*AND LOCAL_NAME = 'ASIA1'*/;

-- ANSI 구문 (다중 조인은 순서가 중요하다.)
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON( D.LOCATION_ID = L.LOCAL_CODE)
/*WHERE LOCAL_NAME = 'ASIA1'*/;

-- 5. 사번, 사원명, 부서명, 지역명, 국가명 조회
-- 오라클 구문
<<<<<<< HEAD
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME 
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE 
      AND L.NATIONAL_CODE = N.NATIONAL_CODE;

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME 
=======
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = L.LOCAL_CODE AND L.NATIONAL_CODE = N.NATIONAL_CODE;

-- ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE);

-- 6. 사번, 사원명, 부서명, 지역명, 국가명, 급여 등급 조회 (NON EQUAL JOIN 후에 실습 진행)
-- 오라클 구문
<<<<<<< HEAD
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME, S.SAL_LEVEL
=======
SELECT E.EMP_ID, 
       E.EMP_NAME, 
       D.DEPT_TITLE, 
       L.LOCAL_NAME, 
       N.NATIONAL_NAME,
       S.SAL_LEVEL
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID 
  AND D.LOCATION_ID = L.LOCAL_CODE 
  AND L.NATIONAL_CODE = N.NATIONAL_CODE
<<<<<<< HEAD
  AND E.SALARY BETWEEN S.MIN_SAL AND MAX_SAL;
=======
  AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed

-- ANSI 구문
SELECT E.EMP_ID AS "사번", 
       E.EMP_NAME AS "사원명", 
<<<<<<< HEAD
       D.DEPT_TITLE AS "부서명", 
       L.LOCAL_NAME AS "근무지역명", 
       N.NATIONAL_NAME AS "근무국가명", 
       S.SAL_LEVEL AS "급여 등급"
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
INNER JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
INNER JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND MAX_SAL);
=======
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역명",
       N.NATIONAL_NAME AS "근무국가명",
       S.SAL_LEVEL AS "급여등급"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed

----------------------------------------------------------------------
/*
        2. 외부 조인(OUTER JOIN)
            테이블 간의 JOIN 시 일치하지 않는 행도 포함시켜서 조회가 가능하다.
            단, 반드시 기준이되는 테이블(컬럼)을 지정해야 한다. (LEFT/RIGHT/(+))
*/
-- OUTER JOIN과 비교할 INNER JOIN 구해놓기
-- 부서가 지정되지 않는 사원 2명에 대한 정보가 조회되지 않는다.
-- 부서가 지정되어 있어서 DEPARTMENT에 부서에 대한 정보가 없으면 조회되지 않는다.
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12 
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행한다.
-- ANSI 구문
-- 부서 코드가 없던 사원(이오리, 하동운)의 정보가 나오게 된다.
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12 
FROM EMPLOYEE E 
LEFT /*OUTER*/ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12 
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+);

-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른편에 기술된 테이블의 컬럼을 기준으로 JOIN을 진행한다.
-- ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12 
FROM EMPLOYEE E 
RIGHT /*OUTER*/ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 오라클 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12 
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 테이블이 가지 모든 행을 조회할 수 있다. (단, 오라클 구문은 지원하지 않는다.)
-- ANSI 구문
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12 
FROM EMPLOYEE E 
FULL /*OUTER*/ JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

-- 오라클 구문 (에러 발생)
SELECT E.EMP_NAME, D.DEPT_TITLE, E.SALARY, E.SALARY * 12 
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID(+);

<<<<<<< HEAD
-------------------------실습 문제-------------------------
SELECT * FROM EMPLOYEE;     -- DEPT_CODE
SELECT * FROM DEPARTMENT;   -- DPET_ID      LOCATION_ID 
SELECT * FROM LOCATION;     --              LOCAL_CODE      NATIONAL_CODE
SELECT * FROM NATIONAL;     --                              NATIONAL_CODE 
SELECT * FROM JOB;

=======
------------------------------------------------------------------
/*
        3. 카테시안곱(CARTESIAN PRODUCT) / 교차 조인(CROSS JOIN)
            조인되는 모든 테이블의 각 행들이 서로서로 모두 매핑된 데이터가 검색된다. (곱집합)
            테이블의 행들이 모두 곱해진 행들의 조합이 출력 -> 방대한 데이터 출력 -> 과부하의 위험
*/
-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME;  -- 23 * 9 => 207

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
ORDER BY EMP_NAME;
------------------------------------------------------------------
/*
        4. 비등가 조인(NON EQUAL JOIN)
            조인 조건에 등호(=)를 사용하지 않는 조인문을 비등가 조인이라고 한다.
            지정한 컬럼 값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식이다.
            (= 이외의 비교 연산자 >, <, >=, <=, BETWEEN AND, IN, NOT IN 등을 사용한다.)
            ANSI 구문으로는 JOIN ON 구문으로만 사용이 가능하다.(USING 사용 불가)
*/
-- EMPLOYEE 테이블과 SAL_GRADE 테이블을 비등가 조인하여 사원명, 급여, 급여 등급 조회
-- ANSI 구문
SELECT E.EMP_NAME, E.SALARY, S.SAL_LEVEL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

-- 오라클 구문
SELECT E.EMP_NAME, E.SALARY, S.SAL_LEVEL
FROM EMPLOYEE E, SAL_GRADE S
WHERE E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

------------------------------------------------------------------
/*
        5. 자체 조인(SELF JOIN)
            같은 테이블을 다시 한번 조인하는 경우에 사용한다.
*/
SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE;

-- EMPLOYEE 테이블을 SELF JOIN 하여 사번, 사원 이름, 부서 코드, 사수 사번, 사수 이름 조회
-- ANSI 구문
SELECT E1.EMP_ID AS "사번", 
       E1.EMP_NAME AS "사원 이름", 
       E1.DEPT_CODE AS "부서 코드", 
       E1.MANAGER_ID AS "사수 사번", 
       E2.EMP_NAME AS "사수 이름"
FROM EMPLOYEE E1
LEFT OUTER JOIN EMPLOYEE E2 ON (E1.MANAGER_ID = E2.EMP_ID);

-- 오라클 구문
SELECT E1.EMP_ID AS "사번", 
       E1.EMP_NAME AS "사원 이름", 
       E1.DEPT_CODE AS "부서 코드", 
       E1.MANAGER_ID AS "사수 사번", 
       E2.EMP_NAME AS "사수 이름"
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+);

-------------------------종합 실습 문제-------------------------
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed
-- 1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원들의 사번, 사원명, 직급명, 부서명, 근무지역, 급여를 조회하세요.
-- 오라클 구문
<<<<<<< HEAD
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, D.DEPT_TITLE, E.SALARY, L.LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID 
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND E.JOB_CODE = J.JOB_CODE 
  AND J.JOB_NAME = '대리' AND L.LOCAL_NAME LIKE 'ASIA%';  
=======
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "사원명", 
       J.JOB_NAME AS "직급명", 
       D.DEPT_TITLE AS "부서명", 
       L.LOCAL_NAME AS "근무지역", 
       E.SALARY AS "급여"
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND J.JOB_NAME = '대리' 
  AND L.LOCAL_NAME LIKE 'ASIA%';
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
<<<<<<< HEAD
SELECT E.EMP_ID, E.EMP_NAME, J.JOB_NAME, D.DEPT_TITLE, E.SALARY, L.LOCAL_NAME
FROM EMPLOYEE E
INNER JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
INNER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
INNER JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
WHERE J.JOB_NAME = '대리' AND L.LOCAL_NAME LIKE 'ASIA%'; -- 와일드카드 % 넣어줌
=======
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "사원명", 
       J.JOB_NAME AS "직급명", 
       D.DEPT_TITLE AS "부서명", 
       L.LOCAL_NAME AS "근무지역", 
       E.SALARY AS "급여"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
WHERE J.JOB_NAME = '대리' 
  AND L.LOCAL_NAME LIKE 'ASIA%';
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed

-- 2. 70년대생 이면서 여자이고, 성이 전 씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하세요.
-- 오라클 구문
<<<<<<< HEAD
SELECT E.EMP_NAME, E.EMP_NO, D.DEPT_TITLE, J.JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID 
  AND E.JOB_CODE = J.JOB_CODE
  AND E.EMP_NAME LIKE '전%' 
  AND INSTR(E.EMP_NO, 8, 1) = '2';
=======
SELECT E.EMP_NAME AS "사원명",
       E.EMP_NO AS "주민번호",
       D.DEPT_TITLE AS "부서명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
  AND E.JOB_CODE = J.JOB_CODE
  AND SUBSTR(E.EMP_NO, 1, 1) = '7'
  AND SUBSTR(E.EMP_NO, 8, 1) = '2'
  AND E.EMP_NAME LIKE '전%';
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
<<<<<<< HEAD
SELECT E.EMP_NAME, E.EMP_NO, D.DEPT_TITLE, J.JOB_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
INNER JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE E.EMP_NAME LIKE '전%'
  AND SUBSTR(E.EMP_NO, 1, 1) = '7'
  AND SUBSTR(E.EMP_NO, 8, 1) = '2';
  
=======
SELECT E.EMP_NAME AS "사원명",
       E.EMP_NO AS "주민번호",
       D.DEPT_TITLE AS "부서명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
--WHERE SUBSTR(E.EMP_NO, 1, 1) = '7'
WHERE E.EMP_NO LIKE '7%'
  AND SUBSTR(E.EMP_NO, 8, 1) = '2'
  AND E.EMP_NAME LIKE '전%';

>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed
-- 3. 보너스를 받는 직원들의 사원명, 보너스, 연봉, 부서명, 근무지역을 조회하세요.
--    단, 부서 코드가 없는 사원도 출력될 수 있게 Outer JOIN 사용
-- 오라클 구문
<<<<<<< HEAD
SELECT E.EMP_NAME AS "사원명", 
       NVL(E.BONUS, 0) AS "보너스", 
       TO_CHAR(E.SALARY * 12, 'L99,999,999') AS "연봉", 
       D.DEPT_TITLE AS "부서명", 
       L.LOCAL_NAME AS "근무지역"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE;
=======
SELECT E.EMP_NAME AS "사원명",
       NVL(E.BONUS, 0) AS "보너스",
       TO_CHAR(E.SALARY * 12, '99,999,999') AS "연봉",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID(+)
  AND D.LOCATION_ID = L.LOCAL_CODE(+)
  AND E.BONUS IS NOT NULL;
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
<<<<<<< HEAD
SELECT E.EMP_NAME AS "사원명", 
       NVL(E.BONUS, 0) AS "보너스", 
       TO_CHAR(E.SALARY * 12, 'L99,999,999') AS "연봉", 
       D.DEPT_TITLE AS "부서명", 
       L.LOCAL_NAME AS "근무지역"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
-- 앞에서 조인된 결과에 INNER JOIN을 하기 때문에 부서코드가 다시 제외된다.
-- LOCATION 테이블을 조인해줄때 다시 LEFT OUTER 조인을 해주어야한다. 
LEFT JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);
-- WHERE BONUS IS NOT NULL; -- 보너스를 받는 직원만 보고싶으면! WHERE 표시도 가능
=======
SELECT E.EMP_NAME AS "사원명",
       NVL(E.BONUS, 0) AS "보너스",
       TO_CHAR(E.SALARY * 12, '99,999,999') AS "연봉",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무지역"
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT OUTER JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed

-- 4. 한국과 일본에서 근무하는 직원들의 사원명, 부서명, 근무지역, 근무 국가를 조회하세요.
-- 오라클 구문
SELECT E.EMP_NAME AS "사원명", 
       D.DEPT_TITLE AS "부서명", 
       L.LOCAL_NAME AS "근무지역", 
       N.NATIONAL_NAME AS "근무국가"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE
  AND L.NATIONAL_CODE = N.NATIONAL_CODE
<<<<<<< HEAD
  AND N.NATIONAL_NAME IN ('한국','일본');
=======
  AND N.NATIONAL_NAME IN ('한국', '일본');
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
SELECT E.EMP_NAME AS "사원명", 
       D.DEPT_TITLE AS "부서명", 
       L.LOCAL_NAME AS "근무지역", 
       N.NATIONAL_NAME AS "근무국가"
FROM EMPLOYEE E
<<<<<<< HEAD
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME IN ('한국','일본');
=======
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
-- WHERE N.NATIONAL_NAME IN ('한국', '일본');
WHERE N.NATIONAL_NAME = '한국' OR N.NATIONAL_NAME = '일본';
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed

-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균 급여(정수 처리)를 조회하세요.
--    단, 부서 배치가 안된 사원들의 평균도 같이 나오게끔 해주세요^^
-- 오라클 구문
SELECT NVL(D.DEPT_TITLE, '부서없음') AS "부서명", 
<<<<<<< HEAD
       TO_CHAR(FLOOR(AVG(E.SALARY)), '99,999,999') AS "급여 평균"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
=======
       TO_CHAR(ROUND(AVG(NVL(SALARY, 0))), '99,999,999') AS "급여평균"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+)
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918
GROUP BY DEPT_TITLE
ORDER BY D.DEPT_TITLE;

-- ANSI 구문
SELECT NVL(D.DEPT_TITLE, '부서없음') AS "부서명", 
<<<<<<< HEAD
       TO_CHAR(FLOOR(AVG(E.SALARY)), '99,999,999') AS "급여 평균"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
GROUP BY DEPT_TITLE;
=======
       TO_CHAR(ROUND(AVG(NVL(SALARY, 0))), '99,999,999') AS "급여평균"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY D.DEPT_TITLE
ORDER BY D.DEPT_TITLE;
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed

-- 6. 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회하시오.
-- 오라클 구문
SELECT D.DEPT_TITLE AS "부서명", 
<<<<<<< HEAD
       TO_CHAR(SUM(E.SALARY), '99,999,999') AS "급여 합계"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000 --> 그룹에 조건 제시(HAVING)
ORDER BY D.DEPT_TITLE;
=======
       TO_CHAR(SUM(SALARY), '99,999,999') AS "급여의 합"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= 10000000;
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
SELECT D.DEPT_TITLE AS "부서명", 
<<<<<<< HEAD
       TO_CHAR(SUM(E.SALARY), '99,999,999') AS "급여 합계"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(E.SALARY) >= 10000000 --> 그룹에 조건 제시(HAVING)
=======
       TO_CHAR(SUM(SALARY), '99,999,999') AS "급여의 합"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY D.DEPT_TITLE
HAVING SUM(SALARY) >= 10000000
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed
ORDER BY D.DEPT_TITLE;

-- 7. 사번, 사원명, 직급명, 급여 등급, 구분을 조회 (NON EQUAL JOIN 후에 실습 진행)
--    이때 구분에 해당하는 값은 아래와 같이 조회 되도록 하시오.
--    급여 등급이 S1, S2인 경우 '고급'
--    급여 등급이 S3, S4인 경우 '중급'
--    급여 등급이 S5, S6인 경우 '초급'
-- 오라클 구문
SELECT E.EMP_ID AS "사번", 
       E.EMP_NAME AS "사원명", 
<<<<<<< HEAD
       J.JOB_NAME AS "직급명", 
       S.SAL_LEVEL AS "급여 등급",
       CASE 
            WHEN S.SAL_LEVEL IN('S1','S2') THEN '고급'
            WHEN S.SAL_LEVEL IN('S3','S4') THEN '중급'
            WHEN S.SAL_LEVEL IN('S5','S6') THEN '초급'
       END AS "구분"     
FROM EMPLOYEE E, JOB J, DEPARTMENT D, SAL_GRADE S
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
=======
       J.JOB_NAME AS "직급명",
       S.SAL_LEVEL AS "급여 등급",
       CASE 
            WHEN S.SAL_LEVEL IN ('S1', 'S2') THEN '고급' 
            WHEN S.SAL_LEVEL IN ('S3', 'S4') THEN '중급'
            WHEN S.SAL_LEVEL IN ('S5', 'S6') THEN '초급'
       END AS "구분"
FROM EMPLOYEE E, JOB J, SAL_GRADE S
WHERE E.JOB_CODE = J.JOB_CODE
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918
  AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

-- ANSI 구문
SELECT E.EMP_ID AS "사번", 
       E.EMP_NAME AS "사원명", 
<<<<<<< HEAD
       J.JOB_NAME AS "직급명", 
       S.SAL_LEVEL AS "급여 등급",
       CASE 
            WHEN S.SAL_LEVEL IN('S1','S2') THEN '고급'
            WHEN S.SAL_LEVEL IN('S3','S4') THEN '중급'
            WHEN S.SAL_LEVEL IN('S5','S6') THEN '초급'
       END AS "구분"     
FROM EMPLOYEE E 
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
  
=======
       J.JOB_NAME AS "직급명",
       S.SAL_LEVEL AS "급여 등급",
       CASE 
            WHEN S.SAL_LEVEL IN ('S1', 'S2') THEN '고급' 
            WHEN S.SAL_LEVEL IN ('S3', 'S4') THEN '중급'
            WHEN S.SAL_LEVEL IN ('S5', 'S6') THEN '초급'
       END AS "구분"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);


>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed
-- 8. 보너스를 받지 않는 직원들 중 직급 코드가 J4 또는 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
-- 오라클 구문
SELECT E.EMP_NAME AS "사원명", 
       J.JOB_NAME AS "직급명", 
       E.SALARY AS "급여"
<<<<<<< HEAD
FROM EMPLOYEE E , JOB J
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.BONUS IS NULL 
  AND J.JOB_CODE IN('J7','J4');
=======
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.BONUS IS NULL
  AND E.JOB_CODE IN ('J4', 'J7');
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
SELECT E.EMP_NAME AS "사원명", 
       J.JOB_NAME AS "직급명", 
       E.SALARY AS "급여"
<<<<<<< HEAD
FROM EMPLOYEE E 
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE E.BONUS IS NULL 
  AND J.JOB_CODE IN('J7','J4');
 -- AND J.JOB_CODE = 'J4' OR J.JOB_CODE = 'J7';
 
=======
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE E.BONUS IS NULL
  AND E.JOB_CODE IN ('J4', 'J7');
--  AND (E.JOB_CODE = 'J4' OR E.JOB_CODE = 'J7');
  
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed
-- 9. 부서가 있는 직원들의 사원명, 직급명, 부서명, 근무 지역을 조회하시오.
-- 오라클 구문
<<<<<<< HEAD
SELECT E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역"
=======
SELECT EMP_NAME  AS "사원명", 
       JOB_NAME  AS "직급명", 
       DEPT_TITLE  AS "부서명", 
       LOCAL_NAME  AS "근무 지역"
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE;

-- ANSI 구문
<<<<<<< HEAD
SELECT E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       L.LOCAL_NAME AS "근무 지역"
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID) 
=======
SELECT EMP_NAME  AS "사원명", 
       JOB_NAME  AS "직급명", 
       DEPT_TITLE  AS "부서명", 
       LOCAL_NAME  AS "근무 지역"
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE);

-- 10. 해외영업팀에 근무하는 직원들의 사원명, 직급명, 부서 코드, 부서명을 조회하시오
-- 오라클 구문
<<<<<<< HEAD
SELECT E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       E.DEPT_CODE AS "부서코드"
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
  AND D.DEPT_TITLE  LIKE '해외영업%';
=======
SELECT E.EMP_NAME AS "사원명", 
       J.JOB_NAME AS "직급명", 
       E.DEPT_CODE AS "부서 코드", 
       D.DEPT_TITLE AS "부서명"
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
  AND E.JOB_CODE = J.JOB_CODE
  AND DEPT_TITLE LIKE '해외영업%';
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
<<<<<<< HEAD
SELECT E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명",
       D.DEPT_TITLE AS "부서명",
       E.DEPT_CODE AS "부서코드"
FROM EMPLOYEE E  
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE D.DEPT_TITLE  LIKE '해외영업%';
=======
SELECT E.EMP_NAME AS "사원명", 
       J.JOB_NAME AS "직급명", 
       E.DEPT_CODE AS "부서 코드", 
       D.DEPT_TITLE AS "부서명"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE D.DEPT_TITLE LIKE '해외영업%'
ORDER BY E.EMP_NAME;
>>>>>>> d0daca31e6078afe2bfb28b9af0a5af6b21adbed

-- 11. 이름에 '형'자가 들어있는 직원들의 사번, 사원명, 직급명을 조회하시오.
-- 오라클 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E, JOB J
<<<<<<< HEAD
WHERE E.JOB_CODE = J.JOB_CODE AND E.EMP_NAME LIKE '%형%';
=======
WHERE E.JOB_CODE = J.JOB_CODE
  AND EMP_NAME LIKE '%형%';
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- ANSI 구문
SELECT E.EMP_ID AS "사번",
       E.EMP_NAME AS "사원명",
       J.JOB_NAME AS "직급명"
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
<<<<<<< HEAD
WHERE E.EMP_NAME LIKE '%형%';
-------------------------------------------------------------
/*
    3. 카테시안 곱(CARTECATION PRODUCT) / 교차조인(CROSS JOIN) 
        조인되는 모든 테이블의 각 행들이 서로서로 모두 매핑된 데이터가 검색된다. (곱집합)
        테이블의 행들이 모두 곱해진 행들의 조합이 출력 -> 방대한 데이터 출력 -> 과부하 위험
*/
-- ANSI 구문 
-- 많은 데이터가 출력된다.
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME; -- -> 23 * 9의 결과로 값이 검색된다.

-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
ORDER BY EMP_NAME;
------------------------------------------------------------
/*
     4. 비등가 조인(NON EQUAL JOIN)
        조인 조건에 등호(=)를 사용하지 않는 조인문을 비등가조인이라고 한다.
        지정한 컬럼값이 일치하는 경우가 아닌 값의 범위에 포함되는 행들을 연결하는 방식이다.
        (= 이외의 비교 연산자 >, <, >=, <=. BETWEEN AND, IN, NOT IN 등을 사용한다.)
        ANSI구문으로는 JOIN ON 구문으로만 사용이 가능하다.(USING은 사용 불가)
*/
-- EMPLOYEE 테이블과 SAL_GRADE 태이블을 비등가 조인하여 사원명, 급여 급여 등급 조회
-- ANSI구문
SELECT E.EMP_NAME, E.SALARY, S.SAL_LEVEL, S.MIN_SAL, S.MAX_SAL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON(E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

-- 오라클 구문
SELECT E.EMP_NAME, E.SALARY, S.SAL_LEVEL, S.MIN_SAL, S.MAX_SAL
FROM EMPLOYEE E , SAL_GRADE S
WHERE E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;
--------------------------------------------------------------------
/*
     5. 자체 조인(SELF JOIN)
        같은 테이블을 다시 한번 조인하는 경우에 사용한다.
        
*/
SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE E;

-- EMPLOYEE 테이블을 SELF JOIN하여 사번, 사원이름, 부서코드, 사수 번호, 사수 이름 조회
--ANSI 구문
SELECT E1.EMP_ID AS "사번", 
       E1.EMP_NAME AS "사원이름", 
       E1.DEPT_CODE AS "부서코드", 
       E1.MANAGER_ID AS "사수번호", 
       E2.EMP_NAME AS "사수이름" 
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID); -- (NULL값 까지 보고 싶으면 LEFT JOIN)
-- 오라클 구문
SELECT E1.EMP_ID AS "사번", 
       E1.EMP_NAME AS "사원이름", 
       E1.DEPT_CODE AS "부서코드", 
       E1.MANAGER_ID AS "사수번호", 
       E2.EMP_NAME AS "사수이름" 
FROM EMPLOYEE E1, EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID(+);
-------------------------------------------------------------------------
CREATE TABLE DEPARTMENT(

DEPTCODE NUMBER PRIMARY KEY,

DEPTNAME NVARCHAR2(10) NOT NULL

);

CREATE TABLE EMPLOYEE(

EMPNO NUMBER PRIMARY KEY,

EMPNAME VARCHAR2(10) NOT NULL,

DEPTNO NUMBER REFERENCES DEPARTMENT(DEPTCODE)

);
