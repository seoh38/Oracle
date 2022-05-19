-- 한 줄짜리 주석
/*
    여러줄 주석
*/
-- 사용자 계정 생성하는 구문(관리자 계정만이 할 수 있다.)
-- [표현법] CREATE USER 계정명 IDENTIFIED BY 계정비밀번호;
CREATE USER KH IDENTIFIED BY KH;

-- 위에서 만든 사용자 계정에게 초소한의 권한(데이터관리, 접속) 부여
GRANT RESOURCE, CONNECT TO KH;

GRANT CREATE VIEW TO KH;

SELECT *
FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT';