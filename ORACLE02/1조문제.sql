    

--1팀 서브쿼리 문제
-- EMPLOYEE 테이블 기준
-- 부서코드별 월급평균(ANY) 보다 많이 받는 사원번호, 사원 이름, 부서명, 직급명, 월급 구하기 입니다
SELECT
   DEPT_CODE,
   AVG(SALARY),
   MAX(SALARY),
   MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY AVG(SALARY)DESC;


-- 급여가 4,000,000원 이상인 모든 사람은 급여의 20% 세금으로 내야한다는 법이 생겼다. 
-- 세금을 내야 하는 직원들의 이름, 급여, 세금(원화로 출력할 것)을 출력하자
SELECT 
    EMP_NAME 이름,
    SALARY 급여,
    TO_CHAR(SALARY * 0.4,'999,999,999l') AS "세금"
FROM EMPLOYEE
WHERE SALARY >= 4000000;


-- 직급이 과장이면서 아시아 지역에 근무하는 남직원 조회
-- 사번, 이름, 주민번호, 직급명, 부서명, 근무지역명 조회
-- 주민번호 뒷자리 1자리 이후는 *로 표시되게
-- 오라클, ANSI 둘 다

-- 오라클
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    RPAD(SUBSTR(A.EMP_NO, 1,8),14, '*') 주민번호,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 지역명
FROM 
    EMPLOYEE A,
    JOB B,
    DEPARTMENT C,
    LOCATION D
WHERE A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE
AND A.EMP_NO LIKE '%-1%'
AND D.LOCAL_NAME LIKE 'ASIA%';

-- ANSI
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    RPAD(SUBSTR(A.EMP_NO, 1,8),14, '*') 주민번호,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 지역명
FROM EMPLOYEE A
LEFT JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
LEFT JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
LEFT JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
WHERE A.EMP_NO LIKE '%-1%'
AND D.LOCAL_NAME LIKE 'ASIA%';


-- 직급이 사원이 아니고 급여등급이 S3이상에 해당하는 직원들 조회
-- 사번, 이름, 직급, 급여, 급여등급 조회
-- 오라클, ANSI 둘 다

-- 오라클
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.JOB_NAME 직급,
    A.SALARY 급여,
    A.SAL_LEVEL 급여등급
FROM 
    EMPLOYEE A,
    JOB B
WHERE A.JOB_CODE = B.JOB_CODE
AND A.SAL_LEVEL >= 'S3'
ORDER BY SAL_LEVEL ASC;

--서브쿼리
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.JOB_NAME 직급,
    A.SALARY 급여,
    A.SAL_LEVEL 급여등급
FROM EMPLOYEE A
LEFT JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
WHERE A.SAL_LEVEL >= 'S3'
ORDER BY SAL_LEVEL ASC;

-- EMPLOYEE 테이블 기준
-- 부서코드별 월급평균 보다 많이 받는 사원번호, 사원 이름, 부서명, 직급명, 월급 구하기
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME AS "사원 이름",
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    A.SALARY 월급
FROM 
    EMPLOYEE A,
    DEPARTMENT B,
    JOB C
WHERE A.DEPT_CODE = B.DEPT_ID
AND  A.JOB_CODE = C.JOB_CODE
AND (A.DEPT_CODE, SALARY) IN (
    SELECT A.DEPT_CODE, MAX(A.SALARY)
    FROM EMPLOYEE A
    GROUP BY A.DEPT_CODE)
ORDER BY SALARY DESC;


-- 직원 테이블에서 보너스 포함한 연봉이 낮은 순으로 5위까지
-- 사번, 이름, 부서명, 직급명, 지역명 조회하세요 (공동순위 포함)
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME  이름,
    B.JOB_NAME 직급명,
    D.LOCAL_NAME 지역명,
    DENSE_RANK() OVER(ORDER BY SALARY*12+NVL(BONUS,0) ASC)"낮은 연봉순위"
FROM 
    EMPLOYEE A,
    JOB B,
    DEPARTMENT C,
    LOCATION D
WHERE A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE;

--DDL

-- 1번
-- EMP_COPYTEST 테이블 만들기 (EMPLOYEE를 이용해서 복제)
-- EMP_COPYTEST 테이블에 NEW_ADDRESS , NEW_PHONE 컬럼 추가하고
-- NEW_PHONE 컬럼 삭제
-- EMP_COPYTEST 테이블의 이름을 EMP_TESTCOPY123 으로 변경하기

CREATE TABLE EMP_COPYTEST(
    NEW_ADDRESS VARCHAR2(100),
    NEW_PHONE VARCHAR2(30)
);

 SELECT * FROM EMP_COPYTEST;
COMMENT ON COLUMN EMP_COPYTEST.NEW_ADDRESS IS '주소';
COMMENT ON COLUMN EMP_COPYTEST.NEW_PHONE IS '전화번호';

ALTER TABLE EMP_COPYTEST
DROP COLUMN NEW_PHONE;

SELECT * FROM EMP_COPYTEST;

ALTER TABLE EMP_COPYTEST
RENAME TO EMP_TESTCOPY123;

SELECT * FROM EMP_TESTCOPY123;

-- 2번
-- EMP_TESTCOPY123테이블 사번의 자료형을 VARCHAR(50)으로 바꾸고 사번 컬럼을 삭제
-- UPDATE1 컬럼을 만들고 제약조건을 (A,B)로만 선택되도록 하기

ALTER TABLE EMP_TESTCOPY123
MODIFY NEW_ADDRESS VARCHAR(50);

ALTER TABLE EMP_TESTCOPY123
ADD (UPDATE1 VARCHAR2(20));

SELECT * FROM EMP_TESTCOPY123;

ALTER TABLE EMP_TESTCOPY123
ADD CONSTRAINT UPDATE1 CHECK(UPDATE1 IN ('A', 'B'));

--DML

-- LOCATION 테이블에서 LOCAL_NAME 이 아시아 인 사원의 
-- 이름, 입사일, 부서명, 근무지역명을 조회하여 
-- EMP_ASIA 테이블에 삽입하고
-- 아시아가 아닌 사원은 EMP_OTHER에 삽입하세요

--전체 조회
SELECT
    A.EMP_NAME 이름,
    A.HIRE_DATE 입사일,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM 
    EMPLOYEE A,
    DEPARTMENT B,
    LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE;

--아시아 국가 일하는 정리
CREATE TABLE EMP_ASIA
AS 
SELECT
    A.EMP_NAME 이름,
    A.HIRE_DATE 입사일,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM 
    EMPLOYEE A,
    DEPARTMENT B,
    LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE
AND LOCAL_NAME LIKE 'ASIA%';

SELECT * FROM EMP_ASIA;

--아시아 아닌 국가
CREATE TABLE EMP_OTHER
AS 
SELECT
    A.EMP_NAME 이름,
    A.HIRE_DATE 입사일,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM 
    EMPLOYEE A,
    DEPARTMENT B,
    LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE
AND LOCAL_NAME NOT LIKE 'ASIA%';

SELECT * FROM EMP_OTHER;

--전체 조회
SELECT * FROM EMP_OTHER;
SELECT * FROM EMP_ASIA;

-- EMPLOYEE 테이블을 복사한 EMP_EXAMPLE 테이블을 만든 후
-- 모든 사원의 월급을 전 사원의 월급 평균을 만 단위에서 내림 한 값 으로 바꾸고
-- 입사일을 가장 최근에 입사한 사원의 날짜로 바꾸시오

CREATE TABLE EMP_EXAMPLE
AS SELECT *
FROM EMPLOYEE;

                  
UPDATE EMP_EXAMPLE EE
SET EE.SALARY = (SELECT TRUNC(AVG(SALARY), -4) FROM EMP_EXAMPLE),
    EE.HIRE_DATE = (SELECT MAX(HIRE_DATE) FROM EMP_EXAMPLE);

SELECT * FROM EMP_EXAMPLE;
