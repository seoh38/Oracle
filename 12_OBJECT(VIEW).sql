/*
    <VIEW>
        SELECT 문을 저장할 수 있는 객체 (논리적인 가상 테이블)
        데이터를 저장하고 있지 않으며 테이블에 대한 SQL만 저장되어 있어 VIEW 에 접근할 때 SQL을 수행하면서 결과값을 저장한다.
 
        [표현법]
           CREATE [OR REPLACE] VIEW 
           AS 서브쿼리;
*/

-- '한국'에서 근무하는 사원의 사번, 이름 ,부서명, 급여, 근무국가명 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '한국';

-- '러시아'에서 근무하는 사원의 사번, 이름 ,부서명, 급여, 근무국가명 조회
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '러시아';

-----------------------------------------------------------------------------
-- 1) 공통적으로 사용되는 쿼리를 VIEW로 만들기
CREATE OR REPLACE VIEW V_EMPLOYEE 
AS SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
   FROM EMPLOYEE E
   JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
   JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
   JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE);
   
SELECT * FROM V_EMPLOYEE; -- 실제로 데이터를 가지고 있지않고 쿼리문의 결과를 가상테이블로 사용

-- '한국'에서 근무하는 사원의 사번, 이름 ,부서명, 급여, 근무국가명 조회
/*
        SELECT 문을 저장할 수 있는 객체(논리적인 가상 테이블)
        데이터를 저장하고 있지 않으며 테이블에 대한 SQL만 저장되어 있어 VIEW 접근할 때 SQL을 수행하면서 결과값을 가져온다.
        
        [표현법]
            CREATE [OR REPLACE] VIEW 뷰명
            AS 서브 쿼리;
*/

-- '한국'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회하시오.
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '한국';

-- '러시아'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회하시오.
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE N.NATIONAL_NAME = '러시아';

------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_EMPLOYEE
AS SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, E.SALARY, N.NATIONAL_NAME
   FROM EMPLOYEE E
   JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
   JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
   JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE);
   
SELECT * 
FROM V_EMPLOYEE; -- 가상 테이블로 실제 데이터가 담겨있는 것은 아니다.

-- 한국에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회하시오.
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

-- 러시아에서 근무하는 사원들 조회
SELECT *
FROM V_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';


-- 총무부에 근무하는 사원들 사원명, 급여
SELECT EMP_NAME, SALARY
FROM V_EMPLOYEE
WHERE DEPT_TITLE = '총무부';

SELECT * FROM USER_TABLES;
SELECT * FROM USER_VIEWS; -- 해당 계정이 가지고 있는 VIEW들에 대한 서브쿼리가 모두 들어가있다!
---------------------------------------------------------------------------

/*
    <VIEW 컬럼에 별칭 부여>
        서브쿼리의 SELECT 절에 함수나 산술연산이 기술되어 있는 경우 반드시 별칭을 지정해야 한다.
         
*/

-- 2) VIEW 컬럼에 별칭부여해서 만들기
-- 사원의 사번, 사원명, 성별, 근무년수를 조회할 수 있는 뷰를 생성
SELECT EMP_ID, 
       EMP_NAME,
       DECODE(SUBSTR(EMP_NO, 8,1), '1', '남', '2', '여'),
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

-- 연산식에는 항상 별칭을 붙여줘야한다.
CREATE OR REPLACE VIEW V_EMP_01
AS SELECT EMP_ID, 
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8,1), '1', '남', '2', '여') 성별,
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
   FROM EMPLOYEE;

SELECT * FROM V_EMP_01;

-- 모든 컬럼에 별칭을 부여해야한다.
CREATE OR REPLACE VIEW V_EMP_02(사번, 사원명, 성별, 근무년수)
AS SELECT EMP_ID, 
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8,1), '1', '남', '2', '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE;

SELECT * FROM V_EMP_02;
SELECT 사번, 사원명, 성별, 근무년수 FROM V_EMP_02; --> 별칭을 사용해서 SELECT도 가능하다.

-- VIEW 삭제해보기
DROP VIEW V_EMP_01;
DROP VIEW V_EMP_02;

---------------------------------------------------------------------

/*
    <VIEW를 이용해서 DML(INSERT, UPDAATE, DELETE) 사용>
        VIEW를 통해 데이터를 변경하게 되면 실제 데이터가 담겨있는 기본 테이블에도 적용된다.

*/
 CREATE OR REPLACE VIEW V_JOB
 AS SELECT * FROM JOB;

SELECT * FROM V_JOB;

-- VIEW에 INSERT
INSERT INTO V_JOB VALUES ('J8', '알바');
SELECT * FROM USER_VIEWS; -- 해당 계정이 가지고 있는 VIEW 들에 대한 내용을 조회하는 데이터 딕셔너리이다.

----------------------------------------------------------------------

/*
    <뷰 컬럼에 별칭 부여>
        서브 쿼리의 SELECT 절에 함수나 산술연산이 기술되어 있는 경우 반드시 별칭을 지정해야 한다.
*/

-- 사원의 사번, 사원명, 성별, 근무년수를 조회할 수 있는 뷰를 생성
SELECT EMP_ID, 
       EMP_NAME,
       DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

CREATE VIEW V_EMP01
AS SELECT EMP_ID, 
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별,
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
   FROM EMPLOYEE;
   
SELECT * FROM USER_VIEWS;
SELECT * FROM V_EMP01;

CREATE OR REPLACE VIEW V_EMP02(사번, 사원명, 성별, 근무년수) -- 모든 컬럼에 별칭을 부여해야 한다.
AS SELECT EMP_ID, 
          EMP_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
   FROM EMPLOYEE;

SELECT 사번, 사원명, 성별, 근무년수 FROM V_EMP02;

-- 뷰를 삭제할 때
DROP VIEW V_EMP01;
DROP VIEW V_EMP02;

------------------------------------------------------------------
/*
    <VIEW를 이용해서 DML(INSERT, UPDATE, DELETE) 사용>
        뷰를 통해 데이터를 변경하게 되면 실제 데이터가 담겨있는 기본 테이블에도 적용된다.
*/
CREATE OR REPLACE VIEW V_JOB
AS SELECT * FROM JOB;

-- VIEW에 SELECT
SELECT JOB_CODE, JOB_NAME
FROM V_JOB;

-- VIEW에 INSERT
INSERT INTO V_JOB VALUES('J8', '알바');

SELECT * FROM V_JOB;
SELECT * FROM JOB;


-- VIEW에 UPDATE (J8의 직급명 인턴으로 변경)
UPDATE V_JOB
SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J8';

-- JOB 테이블에도 인턴으로 변경
SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- VIEW에 DELETE
DELETE FROM V_JOB
WHERE JOB_CODE = 'J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

<<<<<<< HEAD
-------------------------------------------------------
/*
    <DML 구문으로 VIEW 조작이 불가능한 경우
      1) VIEW 정의에 포함되지 않은 컬럼을 조작하는 경우
      2) VIEW에 포함되지 않는 컬럼 중에 기본 테이블 상에 NOT NULL 제약조건이 지정된 경우
      3) 산술 표현시긍로 정의된 경우
      4) 그룹함수나 GROUP BY 절을 포함한 경우
      5) DISTINCT 를 포함한 경우
      6) JOIN을 이용해 여러 테이블을 연결한 경우
*/

-- 1) VIEW 정의에 포함되지 않은 컬럼을 조작하는 경우(INSERT를 허용하지 않는다.)
CREATE OR REPLACE VIEW VM_JOB2
AS SELECT JOB_CODE
   FROM JOB;

--INSERT 
INSERT INTO VM_JOB2 VALUES('J8' ,'알바'); --> "too many values"
INSERT INTO VM_JOB2 VALUES('J8');

-- UPDATE
UPDATE VM_JOB2
SET JOB_NAME = '알바' --> 뷰가 JOB_NAME을 가지고 있지 않기 때문에 에러가 발생한다.
WHERE JOB_CODE = 'J8'; 

UPDATE VM_JOB2
SET JOB_CODE = 'J0' 
WHERE JOB_CODE = 'J8';

-- DELETE 
DELETE FROM VM_JOB2
WHERE JOB_NAME = '사원'; --> invalid identifier" 

DELETE FROM VM_JOB2
WHERE JOB_CODE = 'J0';

SELECT * FROM VM_JOB2;
SELECT * FROM JOB;

-- 2) VIEW에 포함되지 않는 컬럼 중에 기본 테이블 상에 NOT NULL 제약조건이 지정된 경우 (INSERT를 허용하지 않는다.)
CREATE OR REPLACE VIEW V_JOB3
AS SELECT JOB_NAME
   FROM JOB;

-- INSERT
-- 기본테이블인 JOB 테이블에 JOB_CODE는 NOT NULL 제약조건이 있기 때문에 오류가 발생한다.
INSERT INTO V_JOB3 VALUES('알바'); --> cannot insert NULL into ("KH"."JOB"."JOB_CODE") JOB_CODE에 NULL이 들어갈수 없다

-- UPDATE
UPDATE V_JOB3
SET JOB_NAME = '인턴'
WHERE JOB_NAME = '사원'; --> JOB_NAME만 변경하는 것은 가능

-- DELETE(FK 제약조건으로 인해서 삭제되지 않는다)
DELETE FROM V_JOB3
WHERE JOB_NAME = '인턴'; -- child record found -->EMPLOYEE에서 JOB테이블에 있는 행을 참조하고 있다.

SELECT * FROM V_JOB3;
SELECT * FROM JOB;

ROLLBACK;

-- 3) 산술 표현식으로 정의된 경우(INSERT, UPDATE를 허용하지 않는다.)
CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID,
          EMP_NAME, 
          SALARY,
          SALARY * 12 AS "연봉"
   FROM EMPLOYEE;       

SELECT * FROM V_EMP_SAL;
SELECT * FROM EMPLOYEE;

-- INSERT
INSERT INTO V_EMP_SAL VALUES(800, '홍길동', 3000000, 36000000);

-- UPDATE

-- DELETE

=======
--------------------------------------------------------------
/*
    <DML 구문으로 VIEW 조작이 불가능한 경우>
        1) 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우
        2) 뷰에 포함되지 않는 컬럼 중에 기본 테이블 상에 NOT NULL 제약조건이 지정된 경우
        3) 산술 표현식으로 정의된 경우
        4) 그룹 함수나 GROUP BY 절을 포함한 경우
        5) DISTINCT를 포함한 경우
        6) JOIN을 이용해 여러 테이블을 연결한 경우
*/
>>>>>>> 0a2e7b864a9d2e8e97c50d25d0fe629db5cea6cd

-- 1) 뷰 정의에 포함되지 않은 컬럼을 조작하는 경우 (INSERT를 허용하지 않는다.)
CREATE OR REPLACE VIEW V_JOB2
AS SELECT JOB_CODE
   FROM JOB;
   
-- INSERT
INSERT INTO V_JOB2 VALUES('J8', '알바');
INSERT INTO V_JOB2 VALUES('J8');

-- UPDATE
UPDATE V_JOB2
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

UPDATE V_JOB2
SET JOB_CODE = 'J0'
WHERE JOB_CODE = 'J8';

--DELETE
DELETE FROM V_JOB2
WHERE JOB_NAME = '사원';

DELETE FROM V_JOB2
WHERE JOB_CODE = 'J0';

SELECT * FROM V_JOB2;
SELECT * FROM JOB;

-- 2) 뷰에 포함되지 않는 컬럼 중에 기본 테이블 상에 NOT NULL 제약조건이 지정된 경우 (INSERT를 허용하지 않는다.)
CREATE OR REPLACE VIEW V_JOB3
AS SELECT JOB_NAME
   FROM JOB;

-- INSERT
-- 기본 테이블인 JOB 테이블에 JOB_CODE는 NOT NULL 제약조건이 있기 때문에 오류가 발생한다.
INSERT INTO V_JOB3 VALUES('알바');

-- UPDATE
UPDATE V_JOB3
SET JOB_NAME = '인턴'
WHERE JOB_NAME = '사원';

<<<<<<< HEAD
-- 4) 그룹함수나 GROUP BY 절을 포함한 경우(INSERT, UPDATE, DELETE 모두 사용 불가능하다.)
SELECT DEPT_CODE, SUM(SALARY), FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

CREATE OR REPLACE VIEW V_DEPT
AS SELECT DEPT_CODE, SUM(SALARY) 합계, FLOOR(AVG(NVL(SALARY, 0))) 평균
   FROM EMPLOYEE
   GROUP BY DEPT_CODE;
   
SELECT * FROM V_DEPT;   

-- INSERT
-- "virtual column not allowed here" --> 가상 컬럼에 값을 넣을수 없다.
INSERT INTO V_DEPT VALUES('D0', 8000000, 400000);

-- UPDATE
-- "data manipulation operation not legal on this view" --> 에러발생
-- 원본테이블에 (그룹으로)존재하는 값들을 모두 바꿀 수도 있기 때문에 허용해 주지 않는다.
UPDATE V_DEPT
SET "합계" = 12000000
WHERE DEPT_CODE = 'D1';

UPDATE V_DEPT
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D1';

--DELETE
-- 원본테이블에 (그룹으로)존재하는 값들을 모두 바꿀 수도 있기 때문에 허용해 주지 않는다.
DELETE FROM V_DEPT
WHERE DEPT_CODE = 'D1';

-- 5) DISTINCT 를 포함한 경우(INSERT, UPDATE, DELETE 모두 사용 불가능하다.)
CREATE OR REPLACE VIEW V_DT_JOB
AS SELECT DISTINCT JOB_CODE
   FROM EMPLOYEE;

SELECT * FROM V_DT_JOB;

-- INSERT
-- "data manipulation operation not legal on this view" --> 에러발생
INSERT INTO V_DT_JOB VALUES('J8');

-- UPDATE --> 에러발생
UPDATE V_DT_JOB
SET JOB_CODE = 'J8'
WHERE JOB_CODE = 'J7';

-- DELETE
DELETE FROM V_DT_JOB
WHERE JOB_CODE = 'J7';

=======
-- DELETE 
-- EMPLOYEE 테이블의 FK 제약조건이 있기 때문에 오류가 발생한다.
DELETE FROM V_JOB3
WHERE JOB_NAME = '인턴';

SELECT * FROM V_JOB3;
SELECT * FROM JOB;

ROLLBACK;

-- 3) 산술 표현식으로 정의된 경우 (INSERT, UPDATE를 허용하지 않는다.)
CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID, 
          EMP_NAME, 
          SALARY,
          SALARY * 12 AS "연봉"
   FROM EMPLOYEE;

-- INSERT
INSERT INTO V_EMP_SAL VALUES(800, '홍길동', 3000000, 36000000);

-- UPDATE
UPDATE V_EMP_SAL
SET "연봉" = 80000000
WHERE EMP_ID = 200;

-- 산술연산과 무관한 컬럼은 변경 가능
UPDATE V_EMP_SAL
SET SALARY = 5000000
WHERE EMP_ID = 200;

SELECT * FROM V_EMP_SAL;
SELECT * FROM EMPLOYEE;

-- DELETE
DELETE FROM V_EMP_SAL
WHERE "연봉" = 60000000;

ROLLBACK;

-- 4) 그룹 함수나 GROUP BY 절을 포함한 경우 (INSERT, UPDATE, DELETE 모두 허용하지 않는다.)
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

CREATE OR REPLACE VIEW V_DEPT
AS SELECT DEPT_CODE, SUM(SALARY) 합계, FLOOR(AVG(NVL(SALARY, 0))) 평균
   FROM EMPLOYEE
   GROUP BY DEPT_CODE;
   
SELECT * FROM V_DEPT;

-- INSERT
INSERT INTO V_DEPT VALUES('D0', 8000000, 4000000);

-- UPDATE
UPDATE V_DEPT
SET "합계" = 12000000
WHERE DEPT_CODE = 'D1';

UPDATE V_DEPT
SET DEPT_CODE = 'D0'
WHERE DEPT_CODE = 'D1';

-- DELETE
DELETE FROM V_DEPT
WHERE DEPT_CODE = 'D1';

-- 5) DISTINCT를 포함한 경우 (INSERT, UPDATE, DELETE 모두 허용하지 않는다.)
CREATE OR REPLACE VIEW V_DT_JOB
AS SELECT DISTINCT JOB_CODE
   FROM EMPLOYEE;

SELECT * FROM V_DT_JOB;

-- INSERT
INSERT INTO V_DT_JOB VALUES('J8');

-- UPDATE
UPDATE V_DT_JOB
SET JOB_CODE = 'J8'
WHERE JOB_CODE = 'J7';

-- DELETE
DELETE FROM V_DT_JOB
WHERE JOB_CODE = 'J7';

>>>>>>> 0a2e7b864a9d2e8e97c50d25d0fe629db5cea6cd
-- 6) JOIN을 이용해 여러 테이블을 연결한 경우
CREATE OR REPLACE VIEW V_EMP
AS SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE
   FROM EMPLOYEE E
<<<<<<< HEAD
   JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID);

SELECT * FROM V_EMP;

-- INSERT
-- "cannot modify more than one base table through a join view" --> 각각의 테이블에 INSERT 작업을 해야하기 때문에 허용하지 않는다.
INSERT INTO V_EMP VALUES(800, '홍길동', '총무부');

-- UPDATE
UPDATE V_EMP
SET EMP_NAME = '서동일'
WHERE EMP_ID = 200;

UPDATE V_EMP
SET DEPT_TITLE = '총무1팀' -- 에러발생 WHY? JOIN된 테이블들의 변경 수정은 허용이 불가능하다.
                          -- JOIN되고 있는 테이블의 모든 값을 변경해야하기 때문이다.                   
WHERE EMP_ID = 200;

-- DELETE
DELETE FROM V_EMP
WHERE EMP_ID = 200;

DELETE FROM V_EMP
WHERE DEPT_TITLE = '총무부'; -- 서브쿼리의 FROM 절의 테이블에만 영향을 끼친다.

SELECT *
FROM DEPARTMENT; --참조 되고 있는 테이블에는 영향을 주지 않는다.!!

ROLLBACK;
-------------------------------------------------------------------------

/*
    <VIEW 옵션>
      [표현법]
         CREATE [OR REPLACE] [FORCE | NOFORCE]VIEW 뷰명 
         AS 서브쿼리
          [WITH CHECK OPTION]
          [WITH READ ONLY];
          
       - 1. OR REPLACE : 기존에 동일한 뷰가 있을 경우 덮어쓰고, 존재하지 않으면 뷰를 새로 생성한다.
       - 2. FORCE : 서브 쿼리에 기술된 테이블이 존재하지 않는 테이블이어도 뷰 생성이 가능하다. (뷰를 미리 만들고 싶을때 사용??)
            NOFORCE : 서브 쿼리에 기술된 테이블이 존재해야만 뷰가 생성된다.(기본값)
       - 3. WITH CHECK OPTION : 서브 쿼리에 기술된 조건에 부함하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
       - 4. WITH READ ONLY : 뷰에 대해서 조회만 가능하다.(DML 수행 결과)

*/
-- 1) OR REPLACE
-- OR REPLACE 가 없으면 이미 생성된 이름으로 새로 생성이 불가능하다. 
CREATE /*OR REPLACE*/ VIEW V_EMP_01
AS SELECT EMP_ID, EMP_NAME, SALARY
   FROM EMPLOYEE;

SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP_01';

-- 2) FORCE / NOFORCE
-- NOFROCE --> "table or view does not exist" 실제로 테이블이 존재하지 않으면 에러발생
CREATE OR REPLACE /*NOFORCE*/ VIEW V_EMP_02
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;

-- "컴파일 오류와 함께 뷰가 생성되었습니다."
CREATE OR REPLACE FORCE VIEW V_EMP_02
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;

SELECT * FROM V_EMP_02;

-- TT 테이블을 생성하면 그때부터 VIEW 조회 가능
CREATE TABLE TT(
   TCODE NUMBER,
   TNAME VARCHAR2(20),
   TCONTENT VARCHAR(20)
);

-- 3) WITH CHECK OPTION --> WHERE절에 기술된 조건에 부합하지 않은 값으로 수정을 허용하지 않는다.
CREATE OR REPLACE VIEW V_EMP_03
AS SELECT *
   FROM EMPLOYEE
   WHERE SALARY >= 3000000
WITH CHECK OPTION;

SELECT * FROM V_EMP_03;
-- 딕셔너리 확인
SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP_03';

-- 200 사원의 급여를 200만원으로 변경 --> "view WITH CHECK OPTION where-clause violation"
-- 서브 쿼리의 조건에 부합하지 않기 때문에 변경이 불가능하다(서브쿼리 조건 : WHERE SALARY >= 3000000)
UPDATE V_EMP_03
SET SALARY = 2000000
WHERE EMP_ID = 200;

-- 200 사원의 급여를 400만원으로 변경(서브쿼리의 조건에 부합하기 때문에 변경이 가능하다.)
UPDATE V_EMP_03
SET SALARY = 4000000
WHERE EMP_ID = 200;

SELECT * FROM EMPLOYEE;
ROLLBACK;

-- 4) WITH READ ONLY --> 이옵션이 들어가면 INSERT UPDATE, DELETE 모두 불가능하다) 
-- "cannot perform a DML operation on a read-only view"
CREATE OR REPLACE VIEW V_DEPT02
AS SELECT *
   FROM DEPARTMENT
WITH READ ONLY;   

SELECT * FROM V_DEPT02;
SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_DEPT02';

-- INSERT
INSERT INTO V_DEPT02 VALUES('D0', '해외영업4부', 'L5');

-- UPDATE
UPDATE V_DEPT02
SET LOCATION_ID = 'L2'
WHERE DEPT_TITLE = '해외영업4부';

-- DELETE 
DELETE FROM V_DEPT02
WHERE DEPT_ID = 'D0';

ROLLBACK;
=======
   JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID;

SELECT * FROM V_EMP;

-- INSERT
INSERT INTO V_EMP VALUES(800, '홍홍홍', '총무부');

-- UPDATE
UPDATE V_EMP
SET EMP_NAME = '서동일'
WHERE EMP_ID = 200;

UPDATE V_EMP
SET DEPT_TITLE = '총무1팀'
WHERE EMP_ID = 200;

--DELETE
DELETE FROM V_EMP
WHERE EMP_ID = 200;

DELETE FROM V_EMP
WHERE DEPT_TITLE = '총무부'; -- 서브 쿼리에 FROM 절의 테이블에만 영향을 끼친다.

SELECT * 
FROM EMPLOYEE;
SELECT *
FROM DEPARTMENT;

ROLLBACK;

---------------------------------------------------
/*
    <VIEW 옵션>
        [표현법]
            CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
            AS 서브 쿼리
            [WITH CHECK OPTION]
            [WITH READ ONLY];
            
        - OR REPLACE : 기존에 동일한 뷰가 있을 경우 덮어쓰고, 존재하지 않으면 뷰를 새로 생성한다.
        - FORCE : 서브 쿼리에 기술된 테이블이 존재하지 않는 테이블이어도 뷰가 생성된다.
        - NOFORCE : 서브 쿼리에 기술된 테이블이 존재해야만 뷰가 생성된다. (기본값)
        - WITH CHECK OPTION : 서브 쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
        - WITH READ ONLY : 뷰에 대해 조회만 가능(DML 수행 불가)
*/

-- 1) OR REPLACE
CREATE /*OR REPLACE*/ VIEW V_EMP01
AS SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
   FROM EMPLOYEE;
   
SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP01';

-- 2) FORCE / NOFORCE
-- NOFORCE
CREATE OR REPLACE /*NOFORCE*/ VIEW V_EMP02
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;
   
-- FORCE
CREATE OR REPLACE FORCE VIEW V_EMP02
AS SELECT TCODE, TNAME, TCONTENT
   FROM TT;

SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP02';

SELECT * FROM V_EMP02;

-- TT 테이블을 생성하면 그때부터 VIEW 조회 가능
CREATE TABLE TT(
    TCODE NUMBER, 
    TNAME VARCHAR2(10),
    TCONTENT VARCHAR2(20)
);

SELECT * FROM V_EMP02;

-- 3) WITH CHECK OPTION
CREATE OR REPLACE VIEW V_EMP03
AS SELECT *
   FROM EMPLOYEE
   WHERE SALARY >= 3000000
WITH CHECK OPTION;

SELECT * FROM V_EMP03;
SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_EMP03';

-- 200 사원의 급여를 200만원으로 변경(서브 쿼리의 조건에 부합하지 않기 때문에 변경이 불가능하다. )
UPDATE V_EMP03
SET SALARY = 2000000
WHERE EMP_ID = 200;

-- 200 사원의 급여를 400만원으로 변경(서브 쿼리의 조건에 부합하기 때문에 변경이 가능하다. )
UPDATE V_EMP03
SET SALARY = 4000000
WHERE EMP_ID = 200;
>>>>>>> 0a2e7b864a9d2e8e97c50d25d0fe629db5cea6cd

SELECT * FROM EMPLOYEE;

ROLLBACK;

-- 4) WITH READ ONLY
CREATE OR REPLACE VIEW V_DEPT02
AS SELECT *
   FROM DEPARTMENT
WITH READ ONLY;

SELECT * FROM USER_VIEWS WHERE VIEW_NAME = 'V_DEPT02';

-- INSERT
INSERT INTO V_DEPT02 VALUES('D0', '해외영업4부', 'L5');

-- UPDATE
UPDATE V_DEPT02
SET LOCATION_ID = 'L2'
WHERE DEPT_TITLE = '해외영업4부';

-- DELETE
DELETE FROM V_DEPT02
WHERE DEPT_ID = 'D0';

SELECT * FROM V_DEPT02;