-- -1. EMPLOYEE_COPY3 테이블에 EMPLOYEE 데이터까지 복사하고 사원명, 부서명과 지역명을 조회하기
DROP TABLE EMPLOYEE_COPY3;

-- EMPLOYEE_COPY3 테이블 생성
CREATE TABLE EMPLOYEE_COPY3
AS
SELECT * FROM EMPLOYEE;

--EMPLOYEE_COPY3 사원명,부서명, 지역명 조회
SELECT 
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 지역명
FROM 
    EMPLOYEE A,
    DEPARTMENT B,
    LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE;


-- -2. EMPLOYEE테이블에서 부서명이 해외영업1부이며, 급여등급이 S6인 사원의 사번, 이름, 부서명, 급여등급 구하기
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    A.SAL_LEVEL 급여등급
FROM 
    EMPLOYEE A,
    DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
AND DEPT_TITLE LIKE '해외영업1부'
AND SAL_LEVEL LIKE 'S6';

-- -3. EMPLOYEE테이블에서 일하는 지역의 국가코드로 묶어 평균 급여를 구하고, 순위를 구하기
--국가코드명, 평균급여, 순위(1위,2위... '위'를 붙이기) 조회하기
SELECT 
    B.NATIONAL_CODE 국가코드명,trunc(AVG(A.salary),2) 평균급여
FROM 
    EMPLOYEE A,
    LOCATION B,
    DEPARTMENT C
WHERE C.LOCATION_ID = B.LOCAL_CODE
GROUP BY B.NATIONAL_CODE
ORDER BY 2 DESC;


-- -4. employee테이블의 데이터를 복사해 EMP_CY 테이블을 만들고 김자바 직원의 정보를 새로 추가하기
--컬럼 데이터 값은 아래의 값으로 넣으세요
--999, 김자바, 940915-2222222, [java@kh.or.kr](mailto:java@kh.or.kr), 010-5362-5555, D1, J2, S1, 7500000, 0.5, 200, 94/09/15, DEFAULT, N
CREATE TABLE EMP_CY
AS
SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_CY;

INSERT INTO EMP_CY
VALUES 
('999','김자바','940915-2222222', 'java@kh.or.kr', '01053625555','D1','J2','S1',7500000,'0.5',200,'94/09/15',DEFAULT,'N');

ROLLBACK;
-- -5. EMP_CY 테이블에서 김자바 직원과 같은 부서에서 일하는 직원들의 이름과 전화번호, 부서명을 조회하기
--단 김자바 직원의 정보는 출력하지 마세요
SELECT
    A.EMP_NAME,
    A.PHONE,
    B.DEPT_TITLE
FROM 
    EMPLOYEE A,
    DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
AND EMP_NAME NOT LIKE '김자바';

-- -6. 선동일이 매니저로 있는 사원들의 보너스를 김자바 사원만큼 올려주려고 한다. 보너스 인상이 적용되는 사원들의 정보를 조회하기
SELECT MANAGER_ID FROM EMP_CY WHERE EMP_NAME = '선동일';

UPDATE EMPLOYEE 
SET BONUS = (SELECT
                BONUS
            FROM EMPLOYEE 
            WHERE EMP_NAME ='김자바')
WHERE MANAGER_ID IN (SELECT 
                       MANAGER_ID
                    FROM EMPLOYEE 
                    WHERE MANAGER_ID = (SELECT
                                            EMP_ID
                                            FROM EMPLOYEE 
                                            WHERE EMP_NAME ='선동일'));
SELECT * FROM EMPLOYEE ;
ROLLBACK;

-- -7. EMP_CY테이블에서 보너스가 김자바 직원보다 적은 여자직원들의 사번과 이름, 입사일을 나이 순서대로 조회하기
SELECT
    EMP_NAME,
    HIRE_DATE,
    EMP_NO
FROM EMP_CY
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
AND BONUS < (SELECT
                A.BONUS
            FROM EMP_CY A
            WHERE EMP_NAME ='김자바')
ORDER BY EMP_NO ASC;


-- -8. EMPLOYEE테이블에서 '회계관리부'와 '해외영업1부' 이고 월급이 300만원 이하인 여자 사원의 사원번호, 사원명, 부서명, 월급을 조회하여, 이름순으로 정렬하여 조회하기

SELECT
    A.EMP_ID 사원번호,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    A.SALARY
FROM 
    EMPLOYEE A,
    DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.DEPT_TITLE IN ('회계관리부','해외영업1부')
AND A.SALARY < 3000000 
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4');




-- -9. EMPLOYEE테이블에서 '관리자' 직원중에서 가장 많은 월급을 받는 사람의 사번, 사원명, 월급을 조회하기
SELECT 
    EMP_ID 사번,
    EMP_NAME 이름,
    SALARY 월급
FROM EMPLOYEE
WHERE SALARY = (SELECT
            MAX(A.SALARY)
         FROM EMPLOYEE A
         WHERE A.MANAGER_ID IS NOT NULL);

-- -10. EMPLOYEE 테이블을 그대로 복사해서 테이블을 생성하고(EMPLOYEE_COPY_HW) 유럽(EU)지역에서 근무하는 직원들의 보너스를 일괄 0.3으로 바꾸고 사원명, 부서명, 바뀐 보너스, 바뀐 연봉을 조회하기
UPDATE EMPLOYEE_COPY_HW
SET BONUS = 0.3
WHERE DEPT_CODE IN (SELECT A.DEPT_CODE
                    FROM EMPLOYEE A
                    JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
                    JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
                    WHERE C.LOCAL_NAME LIKE 'EU');
                    
SELECT * FROM EMPLOYEE_COPY_HW;