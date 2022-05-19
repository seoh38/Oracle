/*
    <DML(Dato Manipulation Language)>
       데이터 조작 언어로 테이블에 값을 삽입(INSERT)하거나 수정(UPDATE), 삭제(DELETE)하는 구문이다.

    <INSERT>
       테이블에 새로운 행을 추가하는 구문이다.
       
       [표현법]
         1) INSERT INTO 테이블명 VALUES(값, 값, 값..., 값);
            테이블에 모든 컬럼에 값을 INSETRT 하고자 할때 사용한다.
            컬럼 순번을 지켜서 VALUES에 값을 나열해야 한다.
            
         2) INSERT INTO 테이블명(컬럼명, 컬럼명,...컬럼명) (값, 값, 값..., 값);
            테이블에 내가 선택한 컬럼에 대한 값만 INSERT 하고자 할 때 사용한다.
            선택이 안된 컬럼들은 기본적으로 NULL값이 들어간다. (NOT NULL 제약 조건이 걸려있는 컬럼은 반드시 선택해서 값을 제시해야 한다.)
            단, 기본값(DAEFAULT)이 지정되어 있으면 NULL이 아닌 기본값이 들어간다.
            
         3) INSERT INTO 테이블명 (서브 쿼리);
            VALUES를 대신해서 서브쿼리로 조회한 결과값을 통째로 INSERT 한다. (즉, 여러행을 INSERT 시킬 수 있다.)
            서브쿼리의 결과값이 INSERT 문에 지정된 컬럼의 개수와 데이터 타입이 같아야 한다.
            
            
*/
-- 표현법 1) INSERT INTO 테이블명 VALUES(값, 값, 값..., 값); 사용
INSERT INTO EMPLOYEE 
VALUES(900, '도경수', '930112-1111111', 'do@kh.or.kr', 0105556666, 'D1', 'J7', 
        5000000, 0.5,  '200', SYSDATE, NULL, DEFAULT);
        
-- 표현법 2) INSERT INTO 테이블명(컬럼명, 컬럼명,...컬럼명) (값, 값, 값..., 값); 사용       
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
VALUES(901, '이서희', '960308-2222222', 'J7');

SELECT * FROM EMPLOYEE
ORDER BY EMP_ID DESC;

-- 표현법  3) INSERT INTO 테이블명 (서브 쿼리); 사용
-- 새로운 테이블 생성
CREATE TABLE EMP_01(
     EMP_ID NUMBER,
     EMP_NAME VARCHAR2(30),
     DEPT_TITLE VARCHAR2(35)
);

-- 전체 사원의 사번, 이름, 부서명을 조회하여 결과값을 EMP_01 테이블에 INSERT 한다.
INSERT INTO EMP_01(
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE E
    LEFT OUTER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
);

INSERT INTO EMP_01(EMP_ID, EMP_NAME)(
    SELECT EMP_ID, EMP_NAME
    FROM EMPLOYEE E
    LEFT OUTER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)    
);

SELECT * FROM EMP_01;
DROP TABLE EMP_01;

/*
    <INSERT ALL>
      두 개 이상의 테이블에 INSERT 하는데 동일한 서브쿼리가 사용되는 경우
      INSERT ALL구문을 이요해서 여러 테이블에 한번에 데이터 삽입이 가능하다.

      [표현법]
         1) INSERT ALL
            INTO 테이블명1 [(컬럼, 컬럼,...)] VALUES(값, 값, ..., 값)
            INTO 테이블명2 [(컬럼, 컬럼,...)] VALUES(값, 값, ..., 값)
                 서브쿼리;
                 
         2) INSERT ALL
            WHEN 조건1 THEN
                  INTO 테이블명1 [(컬럼, 컬럼,...)] VALUES(값, 값, ..., 값)
            WHEN 조건2 THEN
                  INTO 테이블명2 [(컬럼, 컬럼,...)] VALUES(값, 값, ..., 값)
            서브쿼리;
*/
-- 표현법 1번을 테스트할 테이블 생성(테이브 구조만 복사)
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
   FROM EMPLOYEE
   WHERE 1 = 0;
   
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
   FROM EMPLOYEE
   WHERE 1 = 0;

-- EMP_DEPT 테이블에 EMPLOYEE 테이블의 부서코드가 D1인 직원의 사번, 이름, 부서코드, 입사일을 삽입
-- EMP_MANAGER 테이블에 EMPLOYEE 테이블의 부서코드가 D1인 직원의 사번, 이름 관리자 사번을 조회하여 삽입
INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

DROP TABLE EMP_DEPT;
DROP TABLE EMP_MANAGER;

-- 표현법 2번을 테스트할 테이블 만들기(테이블 구조만 복사)
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;
   
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;
   
-- EMPLOYEE 테이블의 입사일 기준으로 2000년 1월 1일 이전에 입사한 사원의 정보는 EMP_OLD 테이블에 삽입하고
-- 2000년 1월 1일 이후에 입사한 사원의 정보는 EMP_NEW 테이블에 삽입한다.
INSERT ALL 
WHEN HIRE_DATE < '2000/01/01' THEN
   INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
   INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

DROP TABLE EMP_OLD;
DROP TABLE EMP_NEW;
------------------------------------------------------------------
/*
    <UPDATE>
       테이블에 기록된 데이터를 수정하는 구문이다.
       
       [표현법
         UPDATE 테이블명 
         SET 컬럼명 = 변경하려는 값, (서브쿼리 입력도 가능)
             컬럼명 = 변경하려는 값  (서브쿼리 입력도 가능)
             ...
         [WHERE 조건]; 

       -- SET 절에서 여러 개의 컬럼을 콤마(,)로 나열해서 값을 동시에 변경할 수 있다.
       -- WHERE 절을 생략하면 모든 행의 데이터가 변경된다.
       -- UPDATE 시에 서브 쿼리를 사용해서 서브 쿼리를 수행한 결과값으로 컬럼의 값을 변경할 수 있다
          (WHERE 절에서 서브쿼리 사용가능)
*/

-- 테스트 진행할 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
   FROM EMPLOYEE;
 
SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

-- DEPT_ID가 'D9'인 부서명을 '전력기획팀'으로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- EMP_SALARY에서 노옹철 사원의 급여를 1000000으로 변경
UPDATE EMP_SALARY
SET SALARY = 1000000
WHERE EMP_NAME = '노옹철';

-- 선동일 사원의 급여를 700만원으로, 보너스를 0.2로 변경
UPDATE EMP_SALARY
SET SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '선동일';    

-- 모든 사원의 급여를 기존 급여에서 10% 인상한 금액(기존급여 * 1.1)으로 변경
UPDATE EMP_SALARY
SET SALARY = SALARY * 1.1;

-- UPDATE 시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되면 안된다.
-- 사번이 200번인 사원의 사원번호를 NULL로 변경
UPDATE EMP_SALARY
SET EMP_ID = NULL -- EMP_ID에 NOT NUL 제약조건이 걸려있음(제약조건 위배)
WHERE EMP_ID = 200;

-- EMPLOYEE 테이블에서 노옹철 사원의 부서코드를 'D0'으로 변경
UPDATE EMPLOYEE
SET DEPT_CODE = 'D0' -- FOREIGN KEY 제약조건에 위배
WHERE EMP_NAME = '노옹철';






































