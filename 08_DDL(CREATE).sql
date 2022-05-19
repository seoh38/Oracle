/*
    <DDL(Data Definition Language)>
        데이터 정의 언어로 오라클에서 제공하는 객체를 만들고(CREATE), 변경하고(ALTER), 삭제하는(DROP) 등
        실제 데이터 값이 아닌 데이터의 구조 자체를 정의하는 언어로 DB 관리자, 설계자가 주로 사용한다.
        
        * 오라클에서의 객체 : 테이블, 뷰, 시퀀스, 인덱스, 트리커, 프로시져, 함수, 동의어, 사용자 등등
        
    <CREATE>
        데이터베이스 객체를 생성하는 구문이다.
        
    <테이블 생성>
        행과 열로 구성되는 가장 기본적인 데이터베이스 객체로 데이터베이스 내에서 모든 데이터는 테이블에 저장된다.
        
        [표현식]
            CREATE TABLE 테이블명 (
                컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],  
                컬럼명 자료형(크기) [DEFAULT 기본값] [제약조건],
                ...
            );
*/

-- 회원에 대한 데이터를 담을 수 있는 MEMBER 테이블 생성
CREATE TABLE MEMBER (
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE DEFAULT SYSDATE -- 기본값을 지정할 수 있다.
);

-- DROP TABLE MEMBER;

-- 만든 테이블 확인
DESC MEMBER; -- 테이블의 구조를 표시해 주는 구문이다.
SELECT * FROM MEMBER;

/*
    <컬럼에 주석 달기>
        [표현법]
            COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
*/
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원가입일';

/*
    데이터 딕셔너리
        자원을 효율적으로 관라히기 위한 다양한 객체들의 정보를 저장하는 시스템 테이블이다.
        사용자가 객체를 생성하거나 객체를 변경하는 등의 작업을 할 때 데이터베이스에 의해서 자동으로 갱신되는 테이블이다.
        데이터에 관한 데이터가 저장되어 있다고 해서 메타 데이터라고도 한다.
        
    USER_TABLES : 사용자가 가지고 있는 테이블들의 전반적인 구조를 확인하는 뷰 테이블이다.
    USER_TAB_COLUMNS : 테이블, 뷰의 컬럼과 관련된 정보를 조회하는 뷰 테이블이다.
*/
SELECT * FROM USER_TABLES WHERE TABLE_NAME = 'MEMBER';
SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'MEMBER';

-- 테이블에 샘플 데이터 추가(INSERT)
-- INSERT INTO 테이블명[(컬럼명, ..., 컬럼명)] VALUES (값, ..., 값);
INSERT INTO MEMBER VALUES('USER1', '1234', '홍길동', '2021-10-06');
INSERT INTO MEMBER VALUES('USER2', '1234', '김철수', SYSDATE);
INSERT INTO MEMBER VALUES('USER2', '1234', '김철수', DEFAULT);
INSERT INTO MEMBER(MEMBER_ID, MEMBER_PWD, MEMBER_NAME) VALUES('USER2', '1234', '김철수');

SELECT * FROM MEMBER;

-- 위에서 테이블에 추가한 데이터를 실제 데이터베이스에 반영한다. (메모리 버퍼에 임시 저장된 데이터를 실제 테이블에 반영)
COMMIT;

SHOW AUTOCOMMIT;

-- SET AUTOCOMMIT ON;
-- SET AUTOCOMMIT OFF;

------------------------------------------------------
/*
    <제약 조건(CONSTRAINTS)>
        사용자가 원하는 조건의 데이터만 유지하기 위해서 테이블 작성 시 각 컬럼에 대해 저장될 값에 대한 제약조건을 설정할 수 있다.
        제약 조건은 데이터 무결성 보장을 목적으로 한다. (데이터의 정확성과 일관성을 유지시키는 것)
        
        * 종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
        
        [표현법]
            1) 컬럼 레벨
                CRATE TABLE 테이블명 (
                    컬럼명 자료형(크기) [CONSTRAINT 제약조건명] 제약조건,
                    ...
                );
                
            2) 테이블 레벨
                CRATE TABLE 테이블명 (
                    컬럼명 자료형(크기),
                    ...
                    [CONSTRAINT 제약조건명] 제약조건 (컬럼명)
                );
*/
-- 제약 조건 확인
DESC USER_CONSTRAINTS;
SELECT * FROM USER_CONSTRAINTS; -- 사용자가 작성한 제약조건을 확인하는 뷰

DESC USER_CONS_COLUMNS;
SELECT * FROM USER_CONS_COLUMNS; -- 제약조건이 걸려있는 컬럼을 확인하는 뷰

/*
    <NOT NULL 제약조건>
        해당 컬럼에 반드시 값이 있어야만 하는 경우 사용한다.
        삽입 / 수정 시 NULL 값을 허용하지 않도록 제한한다.
*/
-- 기존 MEMBER 테이블은 값에 NULL이 있어도 삽입 가능하다.
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL);
SELECT * FROM MEMBER;

-- NOT NULL 제약조건을 설정한 테이블 만들기
-- NOT NULL 제약조건은 컬럼 레벨에서만 설정이 가능하다.

DROP TABLE MEMBER;
CREATE TABLE MEMBER (
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    MEMBER_DATE DATE DEFAULT SYSDATE
);

-- NOT NULL 제약 조건에 위배되어 오류 발생
INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL);

-- NOT NULL 제약 조건이 걸려있는 컬럼에는 반드시 값이 있어야 한다.
INSERT INTO MEMBER VALUES('USER2', '1234', '길동이', DEFAULT);

DESC MEMBER;
SELECT * FROM MEMBER;

/*
    <UNIQUE 제약조건>
        컬럼의 입력 값에 중복 값을 제한하는 제약조건이다.
        데이터를 삽입/수정 시 기존에 있는 데이터 값 중에 중복 값이 있을 경우 삽입/수정되지 않는다.
        제약조건 지정 방식으로 컬럼 레벨, 테이블 레벨 방식 모두 사용 가능하다.
*/

-- 아이디가 중복됐음에도 성공적으로 데이터가 삽입된다.
INSERT INTO MEMBER VALUES('USER1', '1234', '아무개', DEFAULT);
INSERT INTO MEMBER VALUES('USER1', '1234', '아무개', DEFAULT);

SELECT * FROM MEMBER;

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MEMBER_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    MEMBER_DATE DATE DEFAULT SYSDATE
);

INSERT INTO MEMBER VALUES('USER1', '1234', '아무개', DEFAULT);
INSERT INTO MEMBER VALUES('USER1', '1234', '아무개', DEFAULT);

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_MEMBER_NAME_NN NOT NULL,
    MEMBER_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_ID)
);

INSERT INTO MEMBER VALUES('USER1', '1234', '아무개', DEFAULT);
INSERT INTO MEMBER VALUES('USER1', '1234', '아무개', DEFAULT);

DROP TABLE MEMBER;

-- 여러 개의 컬럼을 묶어서 하나의 UNIQUE 제약 조건을 설정하는 것도 가능하다.(단, 반드시 테이블 레벨로만 설정이 가능하다.)
CREATE TABLE MEMBER (
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_MEMBER_NAME_NN NOT NULL,
    MEMBER_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_NO, MEMBER_ID)
);

-- 여러 컬럼을 묶어서 UNIQUE 제약 조건이 설정되어 있으면 제약 조건이 설정되어 있는 컬럼 값이 모두 중복되는 경우에만 오류가 발생한다.
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '아무개', DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER1', '1234', '아무개', DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '아무개', DEFAULT);
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '아무개', DEFAULT);

SELECT * FROM MEMBER;

/*
    <CHECK 제약조건>
        컬럼에 기록되는 값에 조건을 설정하고 조건을 만족하는 값만 기록할 수 있다.
        비교 값은 리터럴만 사용 가능하다. (변하는 값이나 함수 사용하지 못한다.)
        
        [표현법]
            CHECK(비교연산자)
                CHECK(컬럼 [NOT] IN(값, 값, ...))
                CHECK(컬럼 = 값)
                CHECK(컬럼 BETWEEN 값 AND 값)
                CHECK(컬럼 LIKE '_문자' OR 컬럼 LIKE '문자%')
                ...
*/
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    MEMBER_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_NO, MEMBER_ID)
);

DESC MEMBER; -- 제약조건 확인

-- 성별, 나이에 유효한 값이 아닌 값들도 INSERT 된다. (제약조건이 없어서)
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '아무개', '남', 25, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '춘향이', '여', 101, DEFAULT);
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '이서희', '강', 26, DEFAULT);
INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '홍길동', '남', -30, DEFAULT);

SELECT * FROM MEMBER;

DROP TABLE MEMBER;

-- CHECH 제약조건 넣기
CREATE TABLE MEMBER (
    MEMBER_NO NUMBER NOT NULL,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    AGE NUMBER CHECK (AGE > 0),
    MEMBER_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_NO, MEMBER_ID)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '아무개', '남', 25, DEFAULT);
-- GENDER 컬럼에 CHECK 제약조건으로 '남' 또는' 여' 만 기록 가능하도록 설정이 되었기 때문에 에러가 발생한다.
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '이서희', '강', 26, DEFAULT); -- check constraint 에러
-- AGE 컬럼에 CHECK 제약 조건으로 0보다 큰 값만 기록 가능하도록 설정이 되었기 때문에 에러가 발생한다.
INSERT INTO MEMBER VALUES(4, 'USER4', '1234', '홍길동', '남', -30, DEFAULT); -- check constraint 에러

/*
    <PRIMARY KEY (기본키) 제약조건>
       테이블에서 한 행의 정보를 식별하기 위해 사용할 컬럼에 부여하는 제약조건이다.
       각 행들을 구분할 수 있는 삭별자 역할(회원 번호, 부서 코드, 직급 코드,...)
       PRIMARY KEY 제약조건을 설정하게 되면 자동으로 해당 컬럼에 NOT NULL + UNIQUE 제약조건이 설정된다.
       한 테이블에 한 개만 설정할 수 있다. (단, 한 개 이상의 컬럼을 묶어서 PRIMARY KEY로 제약조건을 설정할 수 있다.
       컬럼 레벨, 테이블 레벨 방식 모두 설정 가능하다.
*/

DROP TABLE MEMBER;


CREATE TABLE MEMBER (
    MEMBER_NO NUMBER CONSTRAINT MEMBER_MEMBER_NO_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    AGE NUMBER CHECK (AGE > 0),
    MEMBER_DATE DATE DEFAULT SYSDATE,
   -- CONSTRAINT MEMBER_MEMBER_NO_PK PRIMARY KEY(NUMBER_NO),
    CONSTRAINT MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_ID)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '아무개', '남', 25, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '춘향이', '여', 20, DEFAULT);
INSERT INTO MEMBER VALUES(3, 'USER3', '1234', '이서희', '남', 26, DEFAULT);
INSERT INTO MEMBER VALUES(3, 'USER4', '1234', '정재현', '남', 25, DEFAULT);
-- unique constraint KH.MEMBER_MEMBER_NO_PK 기본키 중복으로 에러 발생
INSERT INTO MEMBER VALUES(NULL, 'USER5', '1234', '도경수', '남', 29, DEFAULT);
-- cannot insert NULL into ("KH"."MEMBER"."MEMBER_NO") 기본키 NULL은 INSERT 불가능

SELECT * FROM MEMBER;

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MEMBER_NO NUMBER,
    MEMBER_ID VARCHAR2(20),
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    AGE NUMBER CHECK (AGE > 0),
    MEMBER_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_MEMBER_NO_PK PRIMARY KEY(MEMBER_NO, MEMBER_ID) -- 컬럼을 묶어서 하나의 기본키를 설정하는 것을 복합키라고 한다.
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '아무개', '남', 25, DEFAULT);
INSERT INTO MEMBER VALUES(1, 'USER2', '1234', '춘향이', '여', 20, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '이서희', '남', 26, DEFAULT);
-- 회원번호 , 아이디가 세트로 동일한 값이 이미 존재하기 때문에 에러가 발생한다.
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '정재현', '남', 25, DEFAULT);
-- 기본 키로 설정된 컬럼은 NULL값이 있으면 에러가 발생한다.
INSERT INTO MEMBER VALUES(NULL, 'USER5', '1234', '도경수', '남', 29, DEFAULT);

SELECT * FROM MEMBER;

/*
    <FOREIGN KEY (외래키) 제약조건>
       다른 테이블에 존재하는 값만을 가져야 하는 컬럼에 부여하는 제약조건이다. (단, NULL 값은 가질수 있다)
       즉, 참조된 다른 테이블이 제공하는 값만 기록할 수 있다. 
       (FOREIGN KEY 제약조건에 의해서 테이블간에 관계가 형성된다.)
       
       [표현법]
         1) 컬럼 레벨
              컬럼명 자료형(크기) [CONSTRATINT 제약조건명] REFERENCES 참조할 테이블명 [(기본키)] [삭제룰]
              
         2) 테이블 레벨
              [CONSTRATINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(기본키)] [삭제룰]
*/
-- 회원등급에 대한 데이터를 보관하는 테이블(부모 테이블)
CREATE TABLE MEMBER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');

SELECT * FROM MEMBER_GRADE;

DROP TABLE MEMBER;

-- 자식 테이블
CREATE TABLE MEMBER (
    MEMBER_NO NUMBER CONSTRAINT MEMBER_MEMBER_NO_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) NOT NULL,
    MEMBER_PWD VARCHAR2(20) NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_MEMBER_NAME_NN NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    AGE NUMBER CHECK (AGE > 0),
    GRADE_ID NUMBER REFERENCES MEMBER_GRADE(GRADE_CODE),
    MEMBER_DATE DATE DEFAULT SYSDATE,
   -- CONSTRAINT MEMBER_MEMBER_NO_PK PRIMARY KEY(NUMBER_NO), --> 기본키 제약조건
   -- FOREIGN KEY(GRADE_ID) REFERENCES MEMBER_GRADE(GRADE_CODE), --> 참조키 제약조건
    CONSTRAINT MEMBER_MEMBER_ID_UQ UNIQUE(MEMBER_ID)
);

INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '춘향이', '여', 20, 10, DEFAULT);
-- parent key not found --> 부모테이블의 데이터 값에 50이 없다.
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '이서희', '남', 26, 50, DEFAULT);

-- 작성한 제약조건 확인
SELECT CONSTRAINT_NAME, 
       CONSTRAINT_TYPE, 
       UC.TABLE_NAME, 
       COLUMN_NAME
FROM USER_CONSTRAINTS UC
JOIN USER_CONS_COLUMNS UCC USING (CONSTRAINT_NAME)
WHERE UC.TABLE_NAME = 'MEMBER';


=======
--  2) 3개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_PUBLISHER(
    PUB_NO NUMBER,
    PUB_NAME VARCHAR2(20) CONSTRAINT TB_PUBLISHER_PUB_NAME_NN NOT NULL,
    PHONE VARCHAR2(20),
    CONSTRAINT TB_PUBLISHER_PUB_NO_PK PRIMARY KEY(PUB_NO)    
);

COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '전화번호';

INSERT INTO TB_PUBLISHER VALUES(1, 'KH정보교육원', '02-1111-2222');
INSERT INTO TB_PUBLISHER VALUES(2, '문학동네', '02-3333-4444');
INSERT INTO TB_PUBLISHER VALUES(3, '바람개비', '02-1111-6666');

SELECT * FROM TB_PUBLISHER;
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918



<<<<<<< HEAD
=======
--  2) 5개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_BOOK(
    BK_NO NUMBER,
    BK_TITLE VARCHAR2(100) CONSTRAINT TB_BOOK_BK_TITLE_NN NOT NULL,
    BK_AUTHOR VARCHAR2(20) CONSTRAINT TB_BOOK_BK_AUTHOR_NN NOT NULL,
    BK_PRICE NUMBER,
    BK_PUB_NO NUMBER,
    CONSTRAINT TB_BOOK_BK_NO_PK PRIMARY KEY(BK_NO),
    CONSTRAINT TB_BOOK_BK_PUB_NO_FK FOREIGN KEY(BK_PUB_NO) REFERENCES TB_PUBLISHER ON DELETE CASCADE
);
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

COMMENT ON COLUMN TB_BOOK.BK_NO IS '도서번호';
COMMENT ON COLUMN TB_BOOK.BK_TITLE IS '도서명';
COMMENT ON COLUMN TB_BOOK.BK_AUTHOR IS '저자명';
COMMENT ON COLUMN TB_BOOK.BK_PRICE IS '가격';
COMMENT ON COLUMN TB_BOOK.BK_STOCK IS '재고';
COMMENT ON COLUMN TB_BOOK.BK_PUB_NO IS '출판사번호';

INSERT INTO TB_BOOK VALUES (1, '칭찬은 고래도 춤추게한다.', '고래', 10000, 1);
INSERT INTO TB_BOOK VALUES (2, '자바의 정석', '홍길동', 20000, 2);
INSERT INTO TB_BOOK VALUES (3, 'ORACLE 마스터하기', '오라클', 30000, 2);
INSERT INTO TB_BOOK VALUES (4, '자바 완전 정복하기', '제임스 고슬링', 15000, 1);
INSERT INTO TB_BOOK VALUES (5, 'SQL문 익히기', '문인수', 15000, 3);

SELECT * FROM TB_BOOK;

SELECT * 
FROM TB_BOOK TB
JOIN TB_PUBLISHER TP ON(TB.BK_PUB_NO = TP.PUB_NO);


<<<<<<< HEAD
=======
--  2) 3개 정도의 샘플 데이터 추가하기
CREATE TABLE TB_MEMBER(
    MEMBER_NO NUMBER CONSTRAINT TB_MEMBER_MEMBER_NO_PK PRIMARY KEY,
    MEMBER_ID VARCHAR2(20) CONSTRAINT TB_MEMBER_MEMBER_ID_UQ UNIQUE,
    MEMBER_PWD VARCHAR2(30) CONSTRAINT TB_MEMBER_MEMBER_PWD_NN NOT NULL,
    MEMBER_NAME VARCHAR2(20) CONSTRAINT TB_MEMBER_MEMBER_NAME_NN NOT NULL,
    GENDER VARCHAR2(1) CHECK(GENDER IN ('M', 'F')),
    ADDRESS VARCHAR2(100),
    PHONE VARCHAR2(20),
    STATUS VARCHAR2(1) DEFAULT 'N' CHECK(STATUS IN ('Y', 'N')),
    ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL
);

COMMENT ON COLUMN TB_MEMBER.MEMBER_NO IS '회원번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_ID IS '아이디';
COMMENT ON COLUMN TB_MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN TB_MEMBER.MEMBER_NAME IS '회원명';
COMMENT ON COLUMN TB_MEMBER.GENDER IS '성별';
COMMENT ON COLUMN TB_MEMBER.ADDRESS IS '주소';
COMMENT ON COLUMN TB_MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN TB_MEMBER.STATUS IS '탈퇴여부';
COMMENT ON COLUMN TB_MEMBER.ENROLL_DATE IS '가입일';
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

INSERT INTO TB_MEMBER VALUES(1, 'user01', 'pass01', '홍길동', 'M', '서울시 강서구', '010-1111-2222', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(2, 'user02', 'pass02', '김말똥', 'M', '서울시 강남구', '010-3333-4444', DEFAULT, DEFAULT);
INSERT INTO TB_MEMBER VALUES(3, 'user03', 'pass03', '문인수', 'M', '경기도 광주시', '010-4444-5555', DEFAULT, DEFAULT);

SELECT * FROM TB_MEMBER;


<<<<<<< HEAD
=======
--  2) 샘플 데이터 3개 정도 
CREATE TABLE TB_RENT(
    RENT_NO NUMBER CONSTRAINT TB_RENT_RENT_NO_PK PRIMARY KEY,
    RENT_MEM_NO NUMBER CONSTRAINT TB_RENT_RENT_MEM_NO_FK REFERENCES TB_MEMBER ON DELETE SET NULL,
    RENT_BOOK_NO NUMBER CONSTRAINT TB_RENT_RENT_BOOK_NO_FK REFERENCES TB_BOOK ON DELETE SET NULL,
    RENT_DATE DATE DEFAULT SYSDATE
);
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

COMMENT ON COLUMN TB_RENT.RENT_NO IS '대여번호';
COMMENT ON COLUMN TB_RENT.RENT_MEM_NO IS '대여회원번호';
COMMENT ON COLUMN TB_RENT.RENT_BOOK_NO IS '대여도서번호';
COMMENT ON COLUMN TB_RENT.RENT_DATE IS '대여일';

<<<<<<< HEAD




=======
INSERT INTO TB_RENT VALUES(1, 1, 2, DEFAULT);
INSERT INTO TB_RENT VALUES(2, 1, 3, DEFAULT);
INSERT INTO TB_RENT VALUES(3, 2, 1, DEFAULT);
INSERT INTO TB_RENT VALUES(4, 2, 2, DEFAULT);
INSERT INTO TB_RENT VALUES(5, 1, 5, DEFAULT);

SELECT * FROM TB_RENT;
>>>>>>> 8a36a1dabb93d31bc0c42abb7c047e24bf83f918

-- 4. 2번 도서를 대여한 회원의 이름, 아이디, 대여일, 반납 예정일(대여일 + 7일)을 조회하시오.
SELECT TM.MEMBER_NAME AS "회원 이름", 
       TM.MEMBER_ID AS "아이디", 
       TR.RENT_DATE AS "대여일", 
       TR.RENT_DATE + 7 AS "반납 예정일"
FROM TB_MEMBER TM
JOIN TB_RENT TR ON(TR.RENT_MEM_NO = TM.MEMBER_NO)
WHERE TR.RENT_BOOK_NO = 2;


-- 5. 회원번호가 1번인 회원이 대여한 도서들의 도서명, 출판사명, 대여일, 반납예정일을 조회하시오.
SELECT TB.BK_TITLE AS "도서명", 
       TP.PUB_NAME AS "출판사명", 
       TR.RENT_DATE AS "대여일", 
       TR.RENT_DATE + 7 AS "반납 예정일"
FROM TB_RENT TR
JOIN TB_BOOK TB ON(TR.RENT_BOOK_NO = TB.BK_NO)
JOIN TB_PUBLISHER TP ON(TB.BK_PUB_NO = TP.PUB_NO)
WHERE TR.RENT_MEM_NO = 1;

----------------------------------------------------------------------------------------------------------------