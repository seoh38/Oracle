/*
    <함수>
        컬럼값을 읽어서 계산한 결과를 반환한다.
            - 단일행 함수 : N 개의 값을 읽어서 N 개의 결과를 리턴한다. (매 행 함수 실행 결과 반환)
            - 그룹 함수 : N 개의 값을 읽어서 1 개의 결과를 리턴한다.
            - SELECT 절에 단일행 함수와 그룹 함수를 함께 사용하지 못한다. (결과 행의 개수가 다르기 때문이다.)
            - 함수를 기술할 수 있는 위치는 SELECT, WHERE, ORDER BY, GROUP BY, HAVING 절에 기술할 수 있다.
*/

-------------------단일행 함수----------------------
/*
    <문자 관련 함수>
        1) LENGHT / LENGTHB
            - LENGTH(컬럼|'문자값') : 글자 수 반환
            - LENGTHB(컬럼|'문자값') : 글자의 바이트 수 반환
              한글 한 글자 -> 3BYTE
              영문자, 숫자, 특수문자 한 글자 -> 1BYTE
        
        * DUAL 테이블
            - SYS 사용자가 소유하는 테이블
            - SYS 사용자가 소유하지만 모든 사용자가 접근이 가능하다.
            - 한 행, 한 컬럼을 가지고 있는 더미(DUMMY) 테이블이다.
            - 사용자가 함수(계산)을 사용할 때 임시로 사용하는 테이블이다.
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

/*
    2) INSTR
        - INSTR(컬럼|'문자값', '문자값'[, POSITON][, OCCURENCE])
        - 지정한 위치부터 지정된 숫자 번째로 나타나는 문자의 시작 위치를 반환한다.
*/
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 3번째 자리 B
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL; -- 3번째 자리 B
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL; -- 2번째 B -> 9번째 자리 B
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL; -- 포지션이 -1이면 오른쪽부터 순서
SELECT INSTR('AABAACAABBAA', 'B', -1, 3) FROM DUAL; -- 오른쪽부터 시작하여 3번째 B 자리 찾기

SELECT EMAIL, INSTR(EMAIL, '@') AS "@위치", INSTR(EMAIL, 's', 1, 2) "S 위치" -- s가 1개인 컬럼은 0 반환
FROM EMPLOYEE;

SELECT EMAIL, INSTR(EMAIL, '@') AS "@위치", INSTR(EMAIL, 'S', 1, 2) "S 위치" -- 데이터에선 대,소문자를 구분한다.
FROM EMPLOYEE;

/*
    3) LPAD / RPAD
        - LPAD / RPAD(컬럼|'문자값', 최종적으로 반환할 문자의 길이(바이트)[, 덧붙이고자 하는 문자])
        - 제시한 컬럼|'문자값'에 임의의 문자를 왼쪽 또는 오른쪽에 덧붙여 최종 N 길이 만큼의 문자열을 반환한다.
        - 문자에 대해 통일감있게 표시하고자 할 때 사용한다.
*/
-- 20만큼의 길이 중 EMAIL 값은 오른쪽으로 정렬하고 공백은 왼쪽으로 채운다.
SELECT LPAD(EMAIL, 20)
FROM EMPLOYEE;

--SELECT LPAD(EMAIL, 10) -- 10BYTE 길이 만큼만 반환
--FROM EMPLOYEE;

--SELECT LPAD(EMP_NAME, 3) -- BYTE 단위라 성만 반환된다.
--FROM EMPLOYEE;

-- 20만큼의 길이 중 EMAIL 값은 왼쪽으로 정렬하고 공백은 오른쪽으로 채운다.
SELECT RPAD(EMAIL,20)
FROM EMPLOYEE;

-- 20만큼의 길이 중 EMAIL값은 왼쪽으로 정렬하고 공백은 특정 문자('*')로 오른쪽으로 채운다.
SELECT RPAD(EMAIL, 20, '*')
FROM EMPLOYEE;

-- 991212-2*******를 출력
SELECT RPAD('921114-2', 14, '*')
FROM DUAL;

-- 듀얼테이블로 쿼리 반환값 연습. 함수를 넣음.
SELECT RPAD(SUBSTR('921114-2222222',1,8), 14, '*')
FROM DUAL;

-- EMPLOYEE 테이블에서 주민등록번호 첫 번째 자리부터 성별까지 추출한 결과 값과 나머지는 *으로 블라인드하여 출력.
-- 함수를 안에 넣어서 쿼리를 짤 수 있다    .
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*' )
FROM EMPLOYEE;

/*
    4) <LTRIM / RTRIM>
        - LTRIM / RTRIM(컬럼|'문자값'[, 제거하고자 하는 문자값]) -- 제거하고자 하는 문자값이 생략되면 공백이 제거된다.
        - 문자열의 왼쪽 혹은 오른쪽에서 제거하고자 하는 문자들을 찾아서 제거한 결과를 반환한다.
        - 제거하고자 하는 문자값을 생략 시 기본값으로 공백을 제거한다.
*/
SELECT LTRIM('   K H')
FROM DUAL;

-- 왼쪽에서 제거할 문자열의 삭제가 끝나면 이후 문자열은 제거할 문자열이 포함되어있어도 그대로 출력된다.
SELECT LTRIM('123123K123H', '123')
FROM DUAL;

SELECT RTRIM('KH   ')
FROM DUAL;

SELECT RTRIM('KH정보교육원0123456789', '0123456789')
FROM DUAL;

/*
    5) TRIM
        - TRIM([[LEADING|TRAILING|BOTH] 제거할 문자 FROM, ] 컬럼|'문자값')
        - 문자열 앞/뒤/양쪽(LEADING/TRAILING/BOTH)에 있는 지정한 문자를 제거한 나머지를 반환한다.
        - 제거하고자 하는 문자값을 생략 시 기본적으로 양쪽의 공백을 모두 제거한다(기본값 BOTH).
*/
SELECT TRIM('   K    H   ')
FROM DUAL;

-- TRIM 기본 생략조건이 BOTH기 때문에 양쪽 문자열 제거 시 BOTH를 생략해도 무방하다.
SELECT TRIM('Z' FROM 'ZZZ영Z영ZZ') FROM DUAL;
SELECT TRIM(BOTH 'Z' FROM 'ZZZKHZZZ') FROM DUAL;
-- LEADING은 시작(왼쪽)의 문자열 제거기 때문에 LPAD로 사용할 수 있다.
SELECT TRIM(LEADING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;
-- TRAILING은 끝(오른쪽)의 문자열 제거기 때문에 RPAD로 사용할 수 있다.
SELECT TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ') FROM DUAL;

/*
    6) SUBSTR
        - SUBSTR(컬럼|'문자값', POSITION[, LENGTH])
        - 문자열에서 지정한 위치부터 지장한 개수만큼의 문자열을 추출해서 반환한다.
*/
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
-- 오른쪽에서 8번째부터 3글자
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('쇼미 더 머니', 2, 3) FROM DUAL;

-- EMPLOYEE 테이블에서 주민번호에 성별을 나타내는 부분만 잘라서 조회
SELECT SUBSTR(EMP_NO, 8, 1) "성별 코드"
FROM EMPLOYEE;
-- EMPLOYEE 테이블에서 여자 사원만 조회(사원명, 성별코드)
SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1) 
FROM EMPLOYEE
WHERE (SUBSTR(EMP_NO,8,1)) = '2'; -- = 2 라고 해도 형변환되어 출력은 되나, 같은 데이터형(문자열)로 맞춰서 조건식을 맞추는게 좋다.
-- EMPLOYEE 테이블에서 사원명, 이메일, 아이디(이메일에서 @앞의 문자값 출력)를 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1) "ID "
FROM EMPLOYEE;

-- -> 특정 문자열의 위치를 찾는 함수 INSTR(컬럼, '문자열') 을 통해 위치를 설정할 수 있다.

/*
    7) LOWER / UPPER / INITCAP
     - LOWER / UPPER / INITCAP(컬럼|'문자값')
     - LOWER : 모두 대문자로 변경한다.
     - UPPER : 모두 소문자로 변경한다.
     - INITCAP : 단어 앞 글자마다 대문자로 변경한다.
*/

SELECT LOWER('Welcom TO My World!') FROM DUAL;
SELECT UPPER('Welcom TO My World!') FROM DUAL;
SELECT INITCAP('welcom to my world!') FROM DUAL;

/*
    8) CONCAT
       - CONCAT(컬럼|'문자값', 컬럼|'문자값')
       - 문자열 두개를 전달받아서 하나로 합친 후 결과를 반환한다.
*/
--CONCAT은 두개의 문자열만 연결 가능하다!
--SELECT CONCAT('가나다라', 'ABCD', '1234') FROM DUAL; --> 에러남
SELECT CONCAT('가나다라', 'ABCD') FROM DUALS;
SELECT '가나다라' || 'ABCD' || '1234' FROM DUAL;

SELECT CONCAT(EMP_ID, EMP_NAME)
FROM EMPLOYEE;

/*
    9) REPLACE
      - REPLACE(컬럼|'문자값', 변경하려고 하는 문자, 변경하고자하는 문자)
      - 컬럼 혹은 문자값에서 "변경하려고 하는 문자"를" 변경하고자 하는 문자"로 변경해서 반환한다/
*/

SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동' ) FROM DUAL;

--EMPLOYEE 테이블에서 이메일을 KH.OR.KR을 GMAIL.COM으로 변경해서 조회
SELECT EMP_NAME, REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;
----------------------------------------------------------------------------

/*
    <숫자 관련 함수>
      1) ABS
        [표현법]
         ABS(NUMBER)
        - 절대값을 구하는 함수
*/
SELECT ABS(10.9) FROM DUAL;
SELECT ABS(-10.9) FROM DUAL;

/*
      2) MOD
        [표현법]
         MOD(NUMBER, DIVISION)
        - 두 수를 나눈 나머지를 반환해 주는 함수(자바의 % 연산과 동일) 
*/
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(-10, 3) FROM DUAL;
SELECT MOD(10, -3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;
SELECT MOD(-10.9, 3) FROM DUAL;

/*
      3) ROUND
        [표현법]
         ROUND(NUMBER[, 위치 지정 가능])
        - 반올림 해주는 함수
        - 위치 : 기본 0(. 소수점의 위치) , 양수(소수점 기준으로 오른쪽)와 음수(소수점 기준으로 왼쪽)로 입력가능
*/
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 4) FROM DUAL;
SELECT ROUND(123.456, -1) FROM DUAL;

SELECT ROUND(180.125)

FROM DUAL;
/*
      4) CEIL 
        [표현법]
         CEIL(NUMBER)
        - 무조건 올림해주는 함수 
*/
SELECT CEIL(123.456) FROM DUAL;
--SELECT CEIL(123.456, 1) FROM DUAL; -->에러남 위치지정 불가능!

/*
      5) FLOOR
        [표현법]
         FLOOR(NUMBER)
        - 소수점 아래를 무조건 버림하는 함수 
*/
SELECT FLOOR(123.456) FROM DUAL;
SELECT FLOOR(456.789) FROM DUAL;
--SELECT FLOOR(123.456, 2) FROM DUAL; --버림 위치지정 불가능

/*
      6) TRUNC
        [표현법]
         TRUNC(NUMBER[, 위치])
         
        - 위치를 지정하여 버림이 가능한 함수
        - 위치 : 기본 0, 양수(소수점 기준으로 오른쪽)와 음수(소수점 기분으로 왼쪽)로 입력가능
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;
--------------------------------------------------------------

/*
    <날짜 처리 함수>
      1) SYSDATE
        [표현법]
         SELECT SYSDATE
         
       - 시스템의 현재 날짜 반환 
*/
SELECT SYSDATE FROM DUAL;

/*
      2) MONTHS_BETWEEN
        [표현법]
         MONTH_BETWEEN(DATE1, DATE2)
         
       - 입력받는 두 날짜 사이의 개월 수를 반환한다. 
       - 결과값은 NUMBER이다.
*/
--EMPLOYEE 테이블에서 직원명, 입사일, 근무개월수 반환
SELECT EMP_NAME, HIRE_DATE, FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS "근무개월수"
FROM EMPLOYEE;

/*
      3) ADD_MONTHS
         [표현법]
          ADD_MONTHS(DATE,NUMBER)
          
         - 특정 날짜에 입력받는 숫자만큼의 개월 수를 더한 날짜를 리턴한다.
         - 결과값은 DATE이다.
*/
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

--EMPLOYEE 테이블에서  직원명, 입사일, 입사후 6개월이 된 날짜를 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

/*
      4) NEXT_DAY
         [표현법]
          NEXT_DAY(DATE, 요일정보(문자|숫자))
         
         - 특정 날짜에서 구하려는 요일의 다가오는 가장 가까운 날짜를 리턴한다.
         - 결과값은 DATE이다.
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 4) FROM DUAL; -- 1:일요일, 2:월요일,.... 7:토요일
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'SUNDAY') FROM DUAL; -- 에러(현재 언어가 KOREAN이기 때문에)

--ALTER SESSION SET NLS_LANGUAGE = AMERICAN; --> 언어변경
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'SUNDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'SUN') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 1) FROM DUAL;


/*
      5) LAST_DATE 
         [표현법]
          LAST_DAY(DATE)
          
        - 해당 월의 마지막 날짜를 반환하는 함수
        - 결과값은 DATE 타입이다.
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;
SELECT LAST_DAY('20210810') FROM DUAL;
SELECT LAST_DAY('20210301') FROM DUAL;

--EMPLOYEE 테이블에서 직원명, 입사일, 입사월의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE) AS "입사월의 마지막 날"
FROM EMPLOYEE;

/*
      6) EXTRACT
         [표현법]
         EXTRACT(YEAR FROM DATE)
         EXTRACT(MONTH FROM DATE)
         EXTRACT(DAY FROM DATE)
         
       - 특정 날짜에서 연도, 월, 일 정보를 추출해서 반환한다. 
         YEAR : 연도만 추출 
         MONTH : 월만 추출
         DAY : 일만 추출
       - 결과값은 NUMBER 타입이다  
*/
-- EMPLOYEE 테이블에서 직원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, 
       HIRE_DATE,
       EXTRACT(YEAR FROM HIRE_DATE) AS "입사년도",
       EXTRACT(MONTH FROM HIRE_DATE) AS "입사월",
       EXTRACT(DAY FROM HIRE_DATE) AS "입사일"
FROM EMPLOYEE
ORDER BY HIRE_DATE; -- 3, 4, 5 로 오름차순으로 중복을 오름차순으로 정렬도 가능

-- EMPLOYEE 테이블에서 날짜포맷 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

SELECT SYSDATE FROM DUAL;

/*
     <형변환 함수>
     
      1) TO_CHAR
        [표현법]
          TO_CHAR(날짜|숫자[, 포멧])
          
        - 날짜 또는 숫자형 타입의 데이터를 문자 타입으로 변환해서 반환한다.
        - 결과값은 CHARACTER이다.
*/
-- 숫자타입 -> 문자타입
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '999999') FROM DUAL; -- 6자리 공간을 확보하고, 오른쪽으로 정렬, 빈칸은 공백으로 채운다. -> '(공백)1234'
SELECT TO_CHAR(12347777, '999999') FROM DUAL; -- 포맷을 벗어나면 오류 -> '#######'
SELECT TO_CHAR(1234, '000000') FROM DUAL; -- 6자리 공간을 확보하고, 오른쪽으로 정렬, 빈칸은 0으로 채운다. '001234'
SELECT TO_CHAR(1234, 'L000000') FROM DUAL; -- 현재 설정된 나라(LOCAL)의 화폐단위
SELECT TO_CHAR(1234, 'L999,999') FROM DUAL;

--EMPLOYEE 테이블에서 사원명, 급여(통화표시, 자리수 구분) 조회
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999') AS "급여"
FROM EMPLOYEE
ORDER BY "급여" DESC;

-- 날짜 타입 -> 문자 타입
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL; -- 현재 날짜의 시간 정보 출력
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL; -- 현재 날짜의 시간 정보 출력(AM|PM)
SELECT TO_CHAR(SYSDATE, 'MON DY, YYYY') FROM DUAL; -- 현재 날짜의 월, 요일, 년도 출력
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD(DAY)') FROM DUAL;

-- 연도에 대한 포맷
-- 연도에 관련된 포맷 문자는 'Y', 'R'이 있다.
-- YY는 무조건 현재 세기를 반영하고, RR는 50 미만이면 현재 세기를 반영, 50 이상이면 이전 세기는 반영한다.
-- 20 18 90 --> YY 2020, 2018, 2090
-- 20 18 90 --> RR 2020, 2018, 1990
SELECT TO_CHAR(SYSDATE,'YYYY'),
       TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'YY'),
       TO_CHAR(SYSDATE, 'RR'),
       TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;       

-- 월에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'MM'), --월은 'MM'
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'RM') -- 로마 기호
FROM DUAL;

-- 일에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'D'), -- 1주를 기준으로 며칠째인지
       TO_CHAR(SYSDATE, 'DD'), -- 1달을 기준으로 며칠째인지
       TO_CHAR(SYSDATE, 'DDD') -- 1년을 기준으로 며칠째인지
FROM DUAL;

-- 요일에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'DAY'),
       TO_CHAR(SYSDATE, 'DY') -- 요일의 약어 EX) 화, 목, 금
FROM DUAL;

-- EMPLOYEE 테이블에서 직원명 입사일 조회
-- 입사일 포맷을 지정해서 조회한다. (2021년 09월 28일(화))
-- 한글은 포맷 문자가 아니기 때문에 ""(큰따옴표)로 감싸준다.
SELECT EMP_NAME, TO_CHAR(HIRE_DATE,'YYYY"년" MM"월" DD"일" (DY)')
FROM EMPLOYEE;
---------------------------------------------------------------------------------------

/*
      2) TO_DATE
        [표현법]
         TO_DATE(CHARACTER[, FORMAT])
         TO_DATE(NUMBER[, FORMAT])
         
       - 숫자 또는 문자 타입의 데이처를 날짜 타입의 데이터로 변환해서 반환한다.
       - 결과값은 DATE 타입이다.
*/
-- 숫자 타입 -- > 날짜 타입
SELECT TO_DATE(20210928) FROM DUAL;
SELECT TO_DATE(20210928111630) FROM DUAL;

-- 문자 타입 --> 날짜 타입
SELECT TO_DATE('20210928') FROM DUAL;
SELECT TO_DATE('20210928 222530') FROM DUAL;
SELECT TO_DATE('20210928', 'YYYYMMDD') FROM DUAL;

-- YY와 RR 비교
SELECT TO_DATE('210928', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('980928', 'YYMMDD') FROM DUAL; -- YY는 무조건 현재 세기를 의미

SELECT TO_DATE('210928', 'RRMMDD') FROM DUAL;
SELECT TO_DATE('980928', 'RRMMDD') FROM DUAL; -- RR은 해당 값이 50년 이상이면 이전세기를 표시, 50미만이면 현재세기 표시

-- EMPLOYEE 테이블에서 1998년 1월1일 이후에 입사한 사원의 사번, 이름 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
--WHERE HIRE_DATE > TO_DATE('19980101', 'YYYYMMDD');
--WHERE HIRE_DATE > TO_DATE('980101', 'RRMMDD');
WHERE HIRE_DATE > '19980101';
---------------------------------------------------------------------------------

/*
      3) TO_NUMBER
        [표현법]
          TO_NUMBER(CHARACTER[, FORMAT])
          
         - 문자 타입의 데이터를 숫자 타입의 데이터로 변환해서 반환한다.
         - 결과값은 NUMBER 이다.
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;
SELECT '123' + '456' FROM DUAL; -- 자동으로 숫자 타입으로 형변환 뒤 연산처리 해준다.
SELECT '123' + '456A' FROM DUAL; -- 에러 발생 : 숫자형태의 문자들만 자동 형변환된다.
SELECT '10,000,000' + '500,000' FROM DUAL; -- 에러 발생 
SELECT TO_NUMBER('10,000,000', '99,999,999') + TO_NUMBER('500,000', '999,999') FROM DUAL;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';
-----------------------------------------------------------------------------

/*
    <NULL 처리 함수>
     1) NVL
       [표현법]
        NVL(컬럼, 컬럼값이 NULL일 경우 변환할 결과값)
        
      - NULL로 되어있는 컬럼의 값을 인자로 지정한 값으로 변경하여 반환한다.
      
     2) NVL2
       [표현법]
       NVL2(컬럼, 바꿀값1, 바꿀값2)
       
      - 컬럼값이 NULL이 아니면 바꿀값1, 컬럼값이 NULL이면 바꿀값2로 변경하여 반환한다.
        EX) 값을 고정 시키고 싶을때 사용
        
     3) NULLIF
       [표현법]
        NULLIF(비교대상 1, 비교대상 2)
      - 두 개의 값이 동일하면 NULL을 반환, 두 개의 값이 동일하지 않으면 비교대상 1을 제외한다.  
*/
-- EMPLOYEE 테이블에서 사원명, 보너스, 연봉(보너스가 포함된) 조회
SELECT EMP_NAME, NVL(BONUS, 0), (SALARY + (SALARY * NVL(BONUS, 0))) * 12 AS "연봉" 
FROM EMPLOYEE;
-- EMPLOYEE 테이블에서 사원명, 부서코드를 조회(단, 부서코드가 NULL이면 "부서없음" 출력)
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음')
FROM EMPLOYEE;

-- 보너스를 동결하고 싶을 때
SELECT EMP_NAME, NVL(BONUS, 0), 
       NVL2(BONUS, 0.1, 0), 
       (SALARY + (SALARY * NVL2(BONUS, 0.1, 0))) * 12 AS "연봉" 
FROM EMPLOYEE;

-- NULLIF 테스트
SELECT NULLIF('123', '123') FROM DUAL; -- NULL 반환
SELECT NULLIF('123', '456') FROM DUAL; -- 123 반환
-----------------------------------------------------------------------------------------

/*
    <선택 함수>
      여러 가지 경우에 선택을 할 수 있는 기능을 제공하는 함수이다.
      
       1) DECODE
         [표현법]
           DECODE(컬럼|계산식, 조건값1, 결과값2, 조건값2, 결과값2,.... 결과값)
           
         - 비교하고자 하는 값이 조건값과 일치할 경우 그에 해당하는 결과값을 반환해주는 함수이다.

*/

-- EMPLOYEE 테이블에서 사번, 사원명, 주민번호, 성별(남/여) 조회
SELECT EMP_ID, EMP_NAME, 
       EMP_NO,
       DECODE(SUBSTR(EMP_NO,8, 1), '1', '남자', '2', '여자', '잘못 된 주민번호 입니다.') AS "성별"
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 사원명, 직급코드, 기존 급여, 인상된 급여 조회 
-- 직급 코드가 J7인 사원은 급여를 10% 인상
-- 직급 코드가 J6인 사원은 급여를 15% 인상
-- 직급 코드가 J5인 사원은 급여를 20% 인상
-- 그 외의 사원은 급여를 5%만 인상
SELECT EMP_NAME AS "사원명", 
       JOB_CODE AS "직급코드", 
       SALARY AS "기존급여",
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, 'J6', SALARY * 1.15, 'J5', SALARY * 1.2, SALARY * 1.05) AS "인상된 급여" 
FROM EMPLOYEE;

/*
      2) CASE
        [표현법]
          CASE WHEN 조건식1 WHEN 결과값 1
               WHEN 조건식1 WHEN 결과값 1
               WHEN 조건식1 WHEN 결과값 1
               ELSE 결과값
           END     
*/
-- EMPLOYEE 테이블에서 사번, 사원명, 주민번호, 성별(남/여) 조회
SELECT EMP_ID AS "사번",
       EMP_NAME AS "사원명",
       EMP_NO AS "주민번호",
       CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여자'
            ELSE '잘못된 주민 번호 입니다.'
        END AS "성별"
FROM EMPLOYEE;

-- 사원명, 급여, 급여등급(1~4 등급) 조회
-- SALARY 값이 500만원 초과일 경우 1등급
-- SALARY 값이 500만원 이하 350만원 초과일 경우 2등급
-- SALARY 값이 350만원 이하 200만원 초과일 경우 3등급
-- 그 외의 경우 4등급
SELECT EMP_NAME AS "사원명", TO_CHAR(SALARY, '9,999,999') AS "급여",
       CASE WHEN SALARY > 5000000 THEN '1등급'
            WHEN SALARY < 3500000 THEN '2등급'
            WHEN SALARY > 2000000 THEN '3등급'
            ELSE '4등급'
       END AS "급여등급"
FROM EMPLOYEE
ORDER BY 급여등급;
-----------------------------------------------------------------------------------

/*
    <그룹 함수>
      대량의 데이터들로 집계나 통계같은 작업을 처리해야 하는 경우 사용되는 함수들이다.
      모든 그룹 함수는 NULL 값을 자동으로 제외하고 값이 있는 것들만 계산한다.
      따라서 AVG를 사용할때는 NLV() 함수와 함께 사용하는 것을 권장한다.
      
      1) SUM
        [표현법]
          SUM(NUMBER)
          
        - 해당 컬럼 값들의 총합계를 반환한다.  안ㄴ녕
*/
-- EMPLOYEE  테이블의 전 사원 총 급여 합계
SELECT SUM(SALARY)
FROM EMPLOYEE; 

-- EMPLOYEE 테이블에서 남자사원의 총 급여의 합계
SELECT SUM(SALARY) AS "남사원 총급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8,1) = '1';

--EMPLOYEE 테이블에서 전 사원의 연봉 합계
SELECT SUM(SALARY * 12)
FROM EMPLOYEE;

/*
      2) AVG
        [표현법]
          AVG(NUMBER)
          
        - 해당 컬럼 값들의 평균을 구해서 반환한다.
*/
-- EMPLOYEE 테이블의 전 사원 급여의 평균
SELECT TO_CHAR(ROUND(AVG(NVL(SALARY, 0))), 'L99,999,999') AS "급여평균"
FROM EMPLOYEE;

 /*   
     3) MAX / MIN
        [표현법]
          MAX(모든 타입 컬럼)
          MIN(모든 타입 컬럼)
          
        - MIN : 해당 컬럼 값들 중에 가장 작은 값을 반환한다.
        - MAX : 해당 컬럼 값들 중에 가장 큰 값을 반환한다.
 */      
SELECT MIN(EMP_NAME), MIN(EMAIL), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;
SELECT MAX(EMP_NAME), MAX(EMAIL), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;
SELECT MIN(EMP_NAME), MAX(EMP_NAME), MIN(EMAIL), MAX(EMAIL),
       MIN(SALARY), MAX(SALARY), MIN(HIRE_DATE), MAX(HIRE_DATE)
FROM EMPLOYEE;

 /*
     4) COUNT
        [표현법]
          COUNT(*|컬럼명|DISTINCT 컬럼명)
        
        - 컬럼 또는 행의 개수를 세서 반환하는 함수이다.
        - COUNT(*) : 조회 결과에 해당하는 모든 행의 개수를 반환한다.
        - COUNT(컬럼명) : 제시한 컬럼 값이 NULL이 아닌 행의 개수를 반환한다.
        - COUNT(DISTINCT 컬럼명) : 해당 컬럼 값의 중복을 제거한 행의 개수를 반환한다.
*/          
-- 전체 사원 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 남자 사원 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1';

-- 퇴사한 직원의 수(ENT-DATE가 NULL인 경우 개수를 세지 않는다.)
SELECT COUNT(ENT_DATE)
FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE ENT_DATE = 'Y';

-- 현재 사원들이 속해있는 부서의 수를 검색
SELECT COUNT(DISTINCT DEPT_CODE) -- 6이 나옴(중복을 모두 제거)
FROM EMPLOYEE;

-- 현재 사원들이 분포되어 있는 직급의 수
SELECT COUNT(DISTINCT JOB_CODE) -- 7개의 직급이 있다
FROM EMPLOYEE;

