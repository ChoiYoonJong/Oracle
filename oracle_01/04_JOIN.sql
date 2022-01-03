
-- 연결에 사용할 두컬럼명이 다른경우
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    DEPT_TITLE
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;


--연결에 사용할 두컬럼명이 같은경우

SELECT
    EMPLOYEE.EMP_ID,
    EMPLOYEE.EMP_NAME,
    EMPLOYEE.JOB_CODE,
    JOB.JOB_NAME
FROM EMPLOYEE,
    JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;


SELECT
    EMP_ID,
    EMP_NAME,
    A.JOB_CODE,
    JOB_NAME
FROM EMPLOYEE A,
    JOB B
WHERE A.JOB_CODE = B.JOB_CODE;

--ANSI 표준구문
-- 연결에 사용할 컬럼명이 같은경우에 USING(컬럼명)을 사용함

SELECT
    EMP_ID,
    EMP_NAME,
    JOB_CODE,
    JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);


-- 연결에 사용할 컬럼명이 같을경우 ON(컬럼명)을 사용함

SELECT
    EMP_ID,
    EMP_NAME,
    A.JOB_CODE,
    JOB_NAME
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE;

-- 연결에 사용할 컬럼명이 다를경우 ON(컬럼명)을 사용함

SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    DEPT_TITLE
FROM EMPLOYEE,
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- 부서테이블과 지역테이블을 조인하여 테이블에 모든데이터를 조회하세요
SELECT *
FROM DEPARTMENT A,
    LOCATION B  
WHERE A.LOCATION_ID = B.LOCAL_CODE;

--AMSI 표준
SELECT 
    *
FROM DEPARTMENT A
JOIN LOCATION B ON A.LOCATION_ID = B.LOCAL_CODE;

--조인은 기본이 EQUAL JOIN(등가조인) 이다(=EQU JOIN)
--연결이 되는 컬럼의 값이 일치하는 행들만 조인됨(일치하는 값이 없는 경우는 조인에서 제외되어 출력)

--JOIN 기본은 INNER JOIN(=JOIN) & EQU JOIN

--OUTER JOIN : 두테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
--             반드시 OUTER JOIN 임을 명시해야한다. 

--1. LEFT OUTER JOIN (= LEFT JOIN) : 합치기에 사용된 두테이블중에서 왼편에 기술된 테이블의 행을 기준으로 하여 JOIN

--2. RIGHT OUTER JOIN (= RIGHT JOIN) : 합치기에 사용된 두테이블중에서 오른편에 기술된 테이블의 행을 기준으로 하여 JOIN

--3. FULL OUTER JOIN (= FULL JOIN): 합치기에 사용된 두테이블이 가진 모든행을 결과에 포함하여 JOIN

SELECT
    *
FROM EMPLOYEE;

SELECT 
    *
FROM EMPLOYEE
--INNER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--LEFT OUTER JOIN
--ANSI표준
SELECT 
    *
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--RIGHT OUTER JOIN
--ANSI표준
SELECT DISTINCT(DEPT_CODE)
FROM EMPLOYEE;

SELECT 
    *
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT 
    *
FROM EMPLOYEE
WHERE DEPT_CODE = DEPT_ID;

--오라클 전용구문
SELECT 
    *
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

SELECT
    *
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

--FULL OUTER JOIN
-- ANSI표준
SELECT 
    *
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- 오라클 전용구문
-- 오라클 전용구문으로는 FULL OUTER JOIN 을 할수 없다 -- 에러
SELECT 
    *
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);

--CROSS JOIN : 카테이션 곱이라고도 한다. 
--             조인이 되는 테이블의 각행들이 모두 매핑된 데이터가 검색되는 방법 (곱집합)
-- ANSI표준구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

-- 오라클 전용구문
SELECT 
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE,DEPARTMENT;

--NON EQUAL JOIN(NON EQU JOIN)
--: 지정한 컬럼의 값이 일치하는 경우가 아닌 , 값의 범위에 포함하는 행들을 연결 하는 방식 
--ANSI 표준
SELECT
    A.EMP_NAME,
    A.SALARY,
    A.SAL_LEVEL,
    B.SAL_LEVEL
FROM EMPLOYEE A
JOIN SAL_GRADE B ON A.SALARY BETWEEN B.MIN_SAL AND B.MAX_SAL;

-- 오라클 전용구문
SELECT
    A.EMP_NAME,
    A.SALARY,
    A.SAL_LEVEL,
    B.SAL_LEVEL
FROM EMPLOYEE A ,SAL_GRADE B 
WHERE A.SALARY BETWEEN B.MIN_SAL AND B.MAX_SAL;

-- SELF JOIN : 같은 테이블을 조인하는 경우 자기 자신과 조인을 맺는것
-- 동일한 테이블내에서 원하는 정보를 한번에 가져올수 없을 때 사용

SELECT
    A.EMP_ID,
    A.EMP_NAME 사원이름,
    A.DEPT_CODE,
    A.MANAGER_ID,
    B.EMP_NAME 관리자이름
FROM EMPLOYEE A,
    EMPLOYEE B
WHERE A.MANAGER_ID = B.EMP_ID;

-- 다중조인 : N 개의 테이블을 조회할때 사용 
-- ANSI표준
-- 순서중요
SELECT 
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    B.DEPT_TITLE,
    C.LOCAL_NAME
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID =  C.LOACL_CODE;
WHERE EMP_ID = 200;

--오라클 전용구문
SELECT 
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    B.DEPT_TITLE,
    C.LOCAL_NAME
FROM EMPLOYEE A,
    DEPARTMENT B,
    LOCATION C
WHERE A.DEPT_CODE = DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE
AND A,EMP_ID = 200;


-- 직급이 대리이면서 아시아 지역에 근무하는 직원조회
-- 사번, 이름 , 직급명, 부서명, 근무지역명, 급여를 조회하세요 
-- (조회시에는 모든 컬럼에 테이블 별칭을 사용하는것이 좋다. )

SELECT 
    EMP_ID 사번, 
    EMP_NAME 이름, 
    JOB_NAME 직급명, 
    DEPT_TITLE 부서명, 
    LOCAL_NAME 근무지역, 
    SALARY 급여
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID = D.LOCAL_CODE
WHERE A.JOB_CODE = 'J6' 
AND D.LOCAL_NAME LIKE 'ASIA%';

--오라클전용
SELECT 
    EMP_ID 사번, 
    EMP_NAME 이름, 
    JOB_NAME 직급명, 
    DEPT_TITLE 부서명, 
    LOCAL_NAME 근무지역, 
    SALARY 급여
FROM EMPLOYEE A, 
    JOB B, 
    DEPARTMENT C, 
    LOCATION D
WHERE A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE
AND 
AND D.LOCAL_NAME LIKE 'ASIA%';
