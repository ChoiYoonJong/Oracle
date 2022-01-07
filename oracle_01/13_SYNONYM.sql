-- 동의어 (SYNONYM)
-- 다른 데이터 베이스가 가진 객체에 대한 별명 혹은 줄임말
-- 여러사용자가 테이블을 공유할경우
-- 다른 사용자가 테이블에 접근할경우 사용자명.테이블명 으로 표현함
-- 동의어를 사용하면 간단하게 접근 가능
-- 삭제 : DROP SYNONYM EMP;

DROP SYNONYM EMP;
SELECT * FROM USER_SYNONYMS;

-- 생성방법
--CREATE SYNONYM 줄임말 FOR 사용자명.객체명;
GRANT CREATE SYNONYM TO EMPLOYEE;
CREATE SYNONYM EMP FOR EMPLOYEE;

SELECT * FROM EMP;

-- 동의어의 구분
--1. 비공개 동의어
-- 객체에대한 접근 권한을 부여 받은 사용자가 정의한 동의어
--2. 공개 동의어
-- 모든 권한을 주는 사용자(DBA)가 정의한 동의어
-- 모든 사용자가 사용할수 있음 (PUBLIC)
-- 예) DUAL

--시스템 계정에서 테스트
SELECT * FROM EMP; -- 시스템 계정에서 에러
SELECT * FROM EMPLOYEE.DEPARTMENT;
CREATE PUBLIC SYNONYM DEPT FOR EMPLOYEE.DEPARTMENT;

SELECT * FROM DEPT; --시스템계정, EMPLOYEE 계정 둘다 조회됨.