-- 1. 직원명과 주민번호를 조회
-- 단, 주민번호 9번째 자리부터 끝까지는 '*' 로 채움
-- EX) 771120-1******

SELECT 
    EMP_NAME 직원명,
    RPAD((SUBSTR(EMP_NO,1,8)),14,'*') 주민번호
FROM EMPLOYEE;

-- 2. 직원명, 직급코드, 보너스포함연봉(원) 조회
--    단, 보너스포함연봉값에 절대 NULL이 나와서는 안됨
--    뿐만아니라 연봉은 \57,000,000원 형식으로 조회되게 함

SELECT 
    EMP_NAME 직원명,
    JOB_CODE 직급코드, 
    TO_CHAR(SALARY*(1 + NVL(BONUS, 0))*12, 'L999,999,999') "보너스포함연봉(원)"
FROM EMPLOYEE;

-- 3. 부서코드가 D5, D9인 직원들 중 2004년에 입사한 직원들의 사번, 사원명, 부서코드, 입사일 조회

SELECT 
    EMP_ID 사번, 
    EMP_NAME 사원명, 
    DEPT_CODE 부서코드, 
    HIRE_DATE 입사일
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5', 'D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

-- 4. 직원명, 입사일, 입사한 달의 근무일수 조회
--    단, 근무일수에 주말도 포함해서

SELECT 
    EMP_NAME 직원명, 
    HIRE_DATE 입사일, 
    FLOOR(SYSDATE-HIRE_DATE) 오늘까지의근무일수 
FROM EMPLOYEE;

-- 5. 직원명, 부서코드, 생년월일 조회
--    단, 생년월일은 XX년 XX월 XX일 형식으로 조회되게 함
--    꼭!!! 사번이 200, 201, 214가 아닌 사원들로만 조회하시오!!

SELECT
    EMP_NAME 직원명,
    DEPT_CODE 부서코드,
    SUBSTR(EMP_NO, 1, 2) 년, 
    SUBSTR(EMP_NO, 3, 2) 월, 
    SUBSTR(EMP_NO, 5, 2) 일 
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('200','201','214')
ORDER BY DEPT_CODE;

-- 6. 직원명, 부서코드, 부서명 조회
--    (부서명은 해당 부서코드가 D5일 경우 총무부, D6일 경우 기획부, D9일 경우 영업부로 조회되게끔)
--    단, 부서코드가 D5, D6, D9인 사원들만 조회하시오.
--   => CASE WHEN도 사용해보고, DECODE도 사용해보세요

SELECT 
    EMP_NAME 이름,
    CASE
    WHEN DEPT_CODE = 'D5' THEN '총무부'
    WHEN DEPT_CODE = 'D6' THEN '기획부'
    WHEN DEPT_CODE = 'D9' THEN '영업부'
    END 부서 
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9') 
ORDER BY DEPT_CODE;
