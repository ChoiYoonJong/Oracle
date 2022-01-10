--이현규

--1. --EMPLOYEE와 레코드가 모두 같은 EMPLOYEE_COPY3테이블을 만들고
--이 테이블에서 아시아 이외의 지역에서 근무하는 직원들의 BONUS를 10% 인상하여라 (EX : BONUS 0.2 -> 0.3, 만약 이 직원들의 보너스가 없다면 10%로 설정하기)

-- EMPLOYEE_COPY3 테이블
CREATE TABLE EMPLOYEE_COPY3
AS 
SELECT * FROM EMPLOYEE;

-- EMPLOYEE_COPY3 테이블 조회
SELECT * FROM EMPLOYEE_COPY3;

-- 아시사 이외 지역에서 근무하는 직원들 조회
SELECT 
    EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 근무지역명,
    BONUS 보너스,
    SALARY 급여
FROM EMPLOYEE_COPY3 A
JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
WHERE D.LOCAL_NAME NOT LIKE 'ASIA%';

-- 아시아 지역 외 해외에서 일하는 사원 3명 보너스 10% 인상 없으면 0.1로 변경 (적은경우)

UPDATE EMPLOYEE_COPY3 
SET BONUS = NVL(BONUS, 0) + 0.1
WHERE DEPT_CODE IN ('D7','D8');

--되돌리기
ROLLBACK;

--조회
SELECT 
    EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 근무지역명,
    BONUS 보너스,
    SALARY 급여
FROM EMPLOYEE_COPY3 A
JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
WHERE D.LOCAL_NAME NOT LIKE 'ASIA%';

--아시아 지역 외 해외에서 일하는 사원 3명 보너스 10% 인상 없으면 0.1로 변경 
UPDATE EMPLOYEE_COPY3 
SET BONUS = NVL(BONUS, 0) + 0.1
WHERE EMP_NAME IN ( SELECT 
                        EMP_NAME 사원명
                        FROM EMPLOYEE_COPY3 A
                        JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
                        JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
                        JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
                        WHERE D.LOCAL_NAME NOT LIKE 'ASIA%');

-- 변경 완료 조회
SELECT 
    EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 근무지역명,
    BONUS 보너스,
    SALARY 급여
FROM EMPLOYEE_COPY3 A
JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
WHERE D.LOCAL_NAME NOT LIKE 'ASIA%';

-- 이태림 0.35 에서 0.45 변경 완료
-- 장쯔위 0.25 에서 0.35 변경 완료
-- 전형돈 null 에서 0.1 변경 완료
        
--2. -- EMPLOYEE_COPY3테이블에서 부서가 없는 직원들의 부서를 기술지원부로 지정하고 급여를 10% 인상하여라.

--부서 없는 지원 조회
SELECT *
FROM EMPLOYEE_COPY3
WHERE DEPT_CODE IS NULL;

--부서가 없는 직원 2명을 기술지원부로 지정 후 급여 10% 인상
UPDATE EMPLOYEE_COPY3 
SET DEPT_CODE = 'D8', SALARY = SALARY * 1.1
WHERE DEPT_CODE IS NULL;

-- 되돌리기
ROLLBACK;

--부서없는지원 조회 
SELECT *
FROM EMPLOYEE_COPY3
WHERE DEPT_CODE IS NULL;

--부서가 없는 직원 2명을 기술지원부로 지정 후 급여 10% 인상
UPDATE EMPLOYEE_COPY3 
SET DEPT_CODE = 'D8', SALARY = SALARY * 1.1
WHERE DEPT_CODE IS NULL;

--기술지원부 조회
SELECT *
FROM EMPLOYEE_COPY3
WHERE DEPT_CODE LIKE 'D8';




--노한서

--1. --EMPLOYEE 테이블에서 77년생 중에 이메일주소를 hanmail로 바꾸고
    --인사관리부를 제외한 직원의 이름, 사번 , 근무지역, 연봉, 이메일을 출력하세요

-- 전체 직원 조회 (24명)
SELECT 
    EMP_NAME AS "직원의 이름",
    EMP_ID 사번,
    SALARY*12 연봉,
    EMAIL,
    EMP_NO
FROM EMPLOYEE;

-- 77년생만 조회
SELECT 
    EMP_NAME AS "직원의 이름",
    EMP_ID 사번,
    SALARY*12 연봉,
    EMAIL,
    EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) LIKE '77';

--77년 생 이메일 변경
UPDATE EMPLOYEE 
SET EMAIL = REPLACE(EMAIL, SUBSTR(EMAIL,INSTR(EMAIL,'@')+1),'hanmail.com')
WHERE SUBSTR(EMP_NO,1,2) LIKE '77';

--인사관리부를 제외한 직원의 이름, 사번 , 근무지역, 연봉, 이메일을 출력
SELECT 
    A.EMP_NAME AS "직원의 이름",
    A.EMP_ID 사번,
    D.LOCAL_NAME 근무지역,
    A.SALARY*12 연봉,
    A.EMAIL
FROM EMPLOYEE A
JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
WHERE C.DEPT_TITLE NOT LIKE '인사관리부';    
    


--2. --EMPLOYEE테이블에서 사번, 직원명과, 직급명을 출력 단 근무지가 일본인 사람만 
    --사번 내림차순으로 출력
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 직원명,
    B.JOB_NAME 직급명
FROM EMPLOYEE A
JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
WHERE D.NATIONAL_CODE = 'JP'
ORDER BY 1 ASC;

--초기화
ROLLBACK;

--김태연

--1. (EMPLOYEE 테이블을 똑같이 복제하여 EMPOYEE_UPDATE 테이블을 생성하세요)
--전형돈이 새해를 맞이하여 과장으로 직급이 오르면서 급여도 김해술과 같은 급여로 올랐다!
--EMPOYEE_UPDATE 테이블의 컬럼명들을 각각 사번, 이름, 주민번호, 이메일, 전화번호, 부서코드,
--직급코드, 급여, 보너스율, 관리자사번, 입사일, 퇴사일, 퇴사여부로 주석구문을 작성해주고
--EMPOYEE_UPDATE 테이블을 이용하여 김해술과 전형돈의 사번,이름,직급코드,연봉을 조회하세요.

-- EMPLOYEE_UPDATE 테이블 생성
CREATE TABLE EMPOYEE_UPDATE
AS
SELECT * FROM EMPLOYEE;

--전형돈 직급명,급여 변경 
UPDATE EMPOYEE_UPDATE 
SET (SALARY, JOB_CODE) = (
                SELECT
                    A.SALARY,
                    A.JOB_CODE
                FROM EMPOYEE_UPDATE A
                WHERE A.EMP_NAME = '김해술')
WHERE EMP_NAME = '전형돈';
               


--2. --정형돈의 직급이 오른게 부러운 하동운이 선동일과 얘기를 하였지만 직급은 오르지 못했다.
--다만, 급여협상은 성공하여 장쯔위와 같은 급여를 받게 되었다.
--장쯔위와 하동운의 사번, 이름, 보너스를 포함한 연봉을 조회하세요

UPDATE EMPOYEE_UPDATE 
SET SALARY = (SELECT
                    A.SALARY
                FROM EMPOYEE_UPDATE A
                WHERE A.EMP_NAME = '장쯔위'
                )
WHERE EMP_NAME = '하동운';

SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.JOB_NAME,
    TO_CHAR(ROUND(((A.SALARY+(A.SALARY*A.BONUS)))*12, 0),'999,999,999l') 연봉
FROM EMPOYEE_UPDATE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE EMP_NAME IN('장쯔위','하동운');

--조현

--1. -- EMP_EX1 테이블에 EMPLOYEE의 사번, 이름, 이메일, 부서코드, 입사일, 보너스의 틀(껍데기)을 가져오시오
-- EMP_EX1 테이블에 EMPLOYEE테이블에서 이메일 앞부분이 3자리이면서 급여가 3500000이하인
-- 직원을 조회해서 사번, 이름, 이메일, 부서코드, 입사일, 보너스을 삽입하고,
-- EMP_EX1 테이블에서 부서명이 '해외영업'인 직원의 보너스를 0.45로 변경하시오

CREATE TABLE EMP_EX1
AS
SELECT EMP_ID, EMP_NAME, EMAIL, DEPT_CODE, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE 1= 0;

SELECT * FROM EMP_EX1;
DROP TABLE EMP_EX1;

INSERT INTO EMP_EX1
(SELECT
    A.EMP_ID, A.EMP_NAME, A.EMAIL, A.DEPT_CODE, A.HIRE_DATE, A.BONUS
FROM EMPLOYEE A
WHERE A.EMAIL LIKE '___^_%' ESCAPE '^'
AND A.SALARY <= 3500000
);

UPDATE EMP_EX1 
SET BONUS = 0.45
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                    FROM EMPLOYEE A
                    JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
                    WHERE B.DEPT_TITLE LIKE '해외영업%');

--2. -- 1.EMP_EX2의 테이블에는 EMPLOYEE의 사번 , 이름, 부서코드, 직급코드,퇴직 여부의 틀(껍데기)를 가져오시오
-- 2.각 컬럼별로 코멘트 생성해주세요(사번, 이름, 부서코드, 직급코드, 퇴직 여부)
-- 3.EMPLOYEE테이블에서 부서코드가 'D2'와 'D5'인
-- 직원들의 사번 , 이름, 부서코드, 직급코드,퇴직 여부를 조회하여 EMP_EX2 테이블에 삽입해주세요
-- 4.EMP_EX2 테이블에서 직급코드가 'J5'인 직원의 퇴직 여부를 Y로 바꿔주세요

CREATE TABLE EMP_EX2
AS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE 1= 0;

COMMENT ON COLUMN EMP_EX2.EMP_ID IS '사번';
COMMENT ON COLUMN EMP_EX2.EMP_NAME IS '이름';
COMMENT ON COLUMN EMP_EX2.DEPT_CODE IS '부서코드';
COMMENT ON COLUMN EMP_EX2.JOB_CODE IS '직급코드';
COMMENT ON COLUMN EMP_EX2.ENT_YN IS '퇴직 여부';

INSERT INTO EMP_EX2
(SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE DEPT_CODE IN('D2','D5')
);

UPDATE EMP_EX2
SET ENT_YN = 'Y'
WHERE JOB_CODE IN(SELECT JOB_CODE   
                  FROM EMPLOYEE
                  WHERE JOB_CODE = 'J5');
                  
SELECT * FROM EMP_EX2;

--최윤종

--1. --  EMPLOYEE 테이블에서 봉급이 3500000 이상 이하 를 나타내서
-- 사원의 사번, 이름, 입사일, 급여를 조회하여
-- 이상이면 EMP_HIGH 테이블에 삽입하고
-- 이하인 사원은 EMP_LOW 테이블에 삽입하세요

CREATE TABLE EMP_HIGH
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE 1 = 0;

​

CREATE TABLE EMP_LOW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE 1 = 0;

​

INSERT ALL 
WHEN SALARY >= 3500000
THEN INTO EMP_HIGH VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
ELSE INTO EMP_LOW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;

SELECT * FROM EMP_HIGH
ORDER BY HIRE_DATE DESC;

SELECT * FROM EMP_LOW
ORDER BY HIRE_DATE DESC;



--2. -- 99년한해에 입사한 동기 모두 봉급을 2500000 으로 일치
-- 94년한해에 입사한 동기 모두 봉급을 2700000 으로 일치
-- 직원 실수로 유하진의 입사날짜가 실수로 더 일찍 들어온거로 되어있다 원래는 하이유와 같은 입사일이었다.
-- 하이유 와 같은 입사일자로 변경하시요.

UPDATE EMP_LOW
SET SALARY=2500000
WHERE TO_CHAR(HIRE_DATE,'YY/MM/DD') LIKE '99%';

UPDATE EMP_LOW
SET SALARY=2700000
WHERE TO_CHAR(HIRE_DATE,'YY/MM/DD') LIKE '94%';

UPDATE EMP_HIGH
SET SALARY=2500000
WHERE TO_CHAR(HIRE_DATE,'YY/MM/DD') LIKE '99%';

UPDATE EMP_HIGH
SET SALARY=2700000
WHERE TO_CHAR(HIRE_DATE,'YY/MM/DD') LIKE '94%';


UPDATE EMP_LOW
SET (HIRE_DATE) = (SELECT 
                            HIRE_DATE
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '하이유')
WHERE EMP_NAME = '유하진';


SELECT * FROM EMP_HIGH
WHERE TO_CHAR(HIRE_DATE,'YY/MM/DD') LIKE '99%'
UNION
SELECT * FROM EMP_LOW
WHERE TO_CHAR(HIRE_DATE,'YY/MM/DD') LIKE '99%'
UNION
SELECT * FROM EMP_LOW
WHERE TO_CHAR(HIRE_DATE,'YY/MM/DD') LIKE '94%'
ORDER BY 3 DESC;


