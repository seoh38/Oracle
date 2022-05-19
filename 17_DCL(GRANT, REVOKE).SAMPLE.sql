-- CREATE TABLE 권한이 없어서 오류 발생
-- CREATE TABLE 권한을 부여해준다!
-- 3. 계정에서 테이블을 생성할 수 있는 CREATE TABLE 권한을 부여
CREATE TABLE TEST(
   TID NUMBER
); -- 테이블을 만들 권한이 없기 때문에 에러발생
   -- 계정에서 테이블등 객체를 생성할 수 있는 룰을 부여해주고 테이블을 생성해야 한다.

-- 본인이 소유하고 있는 테이블들은 바로 조작이 가능하다
SELECT * FROM TEST;

INSERT INTO TEST VALUES(1);

-- 다른 계정의 테이블에 접근할 수 있는 권한이 없기 때문에 오류가 발생한다.
-- 다른 계정에 접근할 수 있는 권한을 부여해주면 된다.
-- 5. KH.EMPLOYEE 테이블을 조회할 수 있는 권한 부여
SELECT * FROM KH.EMPLOYEE;

-- 6. KH.DEPARTMENT 테이블을 조회할 수 있는 권한 부여
SELECT * FROM KH.DEPARTMENT;

-- 7. KH.DEPARTMENT 테이블에 데이터를 삽입할 수 있는 권한 부여
INSERT INTO KH.DEPARTMENT
VALUES('D0', '개발부', 'L2');

-- 8. KH.DEPARTMENT 테이블에 데이터를 삽입할 수 있는 권한 삭제하고 삽입시 에러발생
-- "insufficient privileges" -- 권한 부족!
ROLLBACK;

-- 9. 모든 테이블에 대한 조회 권한 설정
SELECT * FROM KH.LOCATION;

