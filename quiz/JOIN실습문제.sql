-- 1. 직급이 대리이면서 ASIA지역에 근무하는 직원들의
--    사번, 사원명, 직급명, 부서명, 근무지역명, 급여를 조회하시오

-- ANSI 표준
SELECT 
    EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 근무지역명,
    SALARY 급여
FROM EMPLOYEE A
JOIN JOB B ON (A.JOB_CODE = B.JOB_CODE)
JOIN DEPARTMENT C ON (A.DEPT_CODE = C.DEPT_ID)
JOIN LOCATION D ON (C.LOCATION_ID = D.LOCAL_CODE)
WHERE A.JOB_CODE = 'J6'
AND D.LOCAL_NAME LIKE 'ASIA%';

-- 오라클 전용
SELECT
    EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 근무지역명,
    SALARY 급여
FROM EMPLOYEE A, 
    JOB B, 
    DEPARTMENT C, 
    LOCATION D
WHERE A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE
AND A.JOB_CODE = 'J6'
AND D.LOCAL_NAME LIKE 'ASIA%';

-- 2. 70년대생이면서 여자이고, 성이 전씨인 직원들의
--    사원명, 주민번호, 부서명, 직급명을 조회하시오

-- ANSI 표준
SELECT 
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME

FROM EMPLOYEE A
JOIN DEPARTMENT B ON (A.DEPT_CODE = B.DEPT_ID)
JOIN JOB C ON (A.JOB_CODE = C.JOB_CODE)
WHERE (A.EMP_NO LIKE '%-2%') AND (SUBSTR(EMP_NO,1,2)BETWEEN '70' AND '80') AND (A.EMP_NAME LIKE '전%');

-- 오라클 전용
SELECT 
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME

FROM EMPLOYEE A, DEPARTMENT B, JOB C 
WHERE A.DEPT_CODE = B.DEPT_ID AND A.JOB_CODE = C.JOB_CODE
AND (A.EMP_NO LIKE '%-2%') AND (SUBSTR(EMP_NO,1,2)BETWEEN '70' AND '80') AND (A.EMP_NAME LIKE '전%');


-- 3. 이름에 '형'자가 들어있는 직원들의
--    사번, 사원명, 직급명을 조회하시오

-- ANSI 표준
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명

FROM EMPLOYEE A 
JOIN DEPARTMENT B ON (A.DEPT_CODE = B.DEPT_ID)
WHERE A.EMP_NAME LIKE '%형%';

-- 오라클 전용
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명

FROM EMPLOYEE A , DEPARTMENT B 
WHERE A.DEPT_CODE= B.DEPT_ID
AND A.EMP_NAME LIKE '%형%';

-- 4. 해외영업팀에 근무하는 직원들의
--    사원명, 직급명, 부서코드, 부서명을 조회하시오

-- ANSI 표준
SELECT 
    A.EMP_NAME 사원명,
    C.JOB_NAME 직급명,
    A.DEPT_CODE 부서코드,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON (A.DEPT_CODE = B.DEPT_ID)
JOIN JOB C USING (JOB_CODE) WHERE B.DEPT_TITLE LIKE '해외영업%';



-- 오라클 전용
SELECT 
    A.EMP_NAME 사원명,
    C.JOB_NAME 직급명,
    A.DEPT_CODE 부서코드,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A, DEPARTMENT B, JOB C
WHERE B.DEPT_ID = A.DEPT_CODE AND A.JOB_CODE = C.JOB_CODE 
AND B.DEPT_TITLE LIKE '해외영업%';

-- 5. 보너스를 받는 직원들의
--    사원명, 보너스, 연봉, 부서명, 근무지역명을 조회하시오

-- ANSI 표준
SELECT
    A.EMP_NAME 사원명,
    A.BONUS 보너스,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON DEPT_CODE = DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
WHERE A.BONUS IS NOT NULL;

-- 오라클 전용
SELECT
    A.EMP_NAME 사원명,
    A.BONUS 보너스,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM EMPLOYEE A, DEPARTMENT B, LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID AND B.LOCATION_ID = C.LOCAL_CODE 
AND BONUS IS NOT NULL;

-- 6. 부서가 있는 직원들의
--    사원명, 직급명, 부서명, 근무지역명을 조회하시오

-- ANSI 표준
select 
    A.EMP_NAME 사원명, 
    D.JOB_NAME 직급명 , 
    B.DEPT_TITLE 부서명, 
    C.LOCAL_NAME 근무지역명
from EMPLOYEE A 
JOIN DEPARTMENT B on A.DEPT_CODE = B.DEPT_ID
JOIN JOB D ON A.JOB_CODE = D.JOB_CODE
JOIN LOCATION C ON C.LOCAL_CODE = B.LOCATION_ID;


--ORACLE 방식
SELECT 
    EMP_NAME 사원명,
    JOB_NAME 직급명,
    DEPT_TITLE 부서명,
    LOCAL_NAME 근무지역명
FROM EMPLOYEE A, DEPARTMENT B, JOB C, LOCATION D
WHERE A.DEPT_CODE = B.DEPT_ID AND D.LOCAL_CODE = B.LOCATION_ID AND A.JOB_CODE = C.JOB_CODE;

-- 7. '한국'과 '일본'에 근무하는 직원들의 
--    사원명, 부서명, 근무지역명, 근무국가명을 조회하시오

-- ANSI 표준
SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명,
    D.NATIONAL_NAME 근무국가명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
JOIN NATIONAL D ON C.NATIONAL_CODE = D.NATIONAL_CODE
WHERE C.NATIONAL_CODE IN ('KO','JP');

-- 오라클 전용
SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명,
    D.NATIONAL_NAME 근무국가명
FROM EMPLOYEE A, DEPARTMENT B, LOCATION C, NATIONAL D
WHERE  B.LOCATION_ID = C.LOCAL_CODE
AND A.DEPT_CODE = B.DEPT_ID
AND D.NATIONAL_CODE = C.NATIONAL_CODE
AND C.NATIONAL_CODE IN ('KO','JP');


-- 8. 보너스를 받지 않는 직원들 중 직급코드가 J4 또는 J7인 직원들의
--    사원명, 직급명, 급여를 조회하시오

-- ANSI 표준
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    A.SALARY 급여
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE A.JOB_CODE='J4' OR A.JOB_CODE='J7' AND A.BONUS IS NULL;

-- 오라클 전용
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    A.SALARY 급여
FROM EMPLOYEE A , JOB B 
WHERE A.JOB_CODE = B.JOB_CODE
AND (A.JOB_CODE='J4' OR A.JOB_CODE='J7') 
AND A.BONUS IS NULL;

    

-- 9. 사번, 사원명, 직급명, 급여등급, 구분을 조회하는데
--    이때 구분에 해당하는 값은
--    급여등급이 S1, S2인 경우 '고급'
--    급여등급이 S3, S4인 경우 '중급'
--    급여등급이 S5, S6인 경우 '초급' 으로 조회되게 하시오.

-- ANSI 표준

 SELECT
    A.EMP_ID 사번, 
    A.EMP_NAME 사원명, 
    B.JOB_NAME 직급명, 
    CASE 
        WHEN C.SAL_LEVEL IN('S1','S2') THEN '고급'
        WHEN C.SAL_LEVEL IN('S3','S4') THEN '중급'
        WHEN C.SAL_LEVEL IN('S5','S6') THEN '초급'
        ELSE '없음'
        END 급여등급
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN SAL_GRADE C ON A.SALARY BETWEEN C.MIN_SAL AND C.MAX_SAL;


-- 오라클 전용

SELECT
    A.EMP_ID 사번, 
    A.EMP_NAME 사원명, 
    B.JOB_NAME 직급명,
    CASE 
        WHEN C.SAL_LEVEL IN('S1','S2') THEN '고급'
        WHEN C.SAL_LEVEL IN('S3','S4') THEN '중급'
        WHEN C.SAL_LEVEL IN('S5','S6') THEN '초급'
        ELSE '없음'
        END 급여등급
FROM EMPLOYEE A, JOB B, SAL_GRADE C
WHERE A.JOB_CODE = B.JOB_CODE
AND A.SALARY BETWEEN C.MIN_SAL AND C.MAX_SAL;

-- 10. 각 부서별 총 급여합을 조회하되
--     이때, 총 급여합이 1000만원 이상인 부서명, 급여합을 조회하시오

-- ANSI 표준

 SELECT
    B.DEPT_TITLE 부서명,
    SUM(A.SALARY) 급여합
FROM  EMPLOYEE A
JOIN  DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
GROUP BY B.DEPT_TITLE
HAVING SUM(A.SALARY) >= 10000000;

-- 오라클 전용

SELECT
    B.DEPT_TITLE 부서명,
    SUM(A.SALARY) 급여합
FROM DEPARTMENT B, EMPLOYEE A
WHERE A.DEPT_CODE = B.DEPT_ID
GROUP BY B.DEPT_TITLE
HAVING SUM(A.SALARY) >= 10000000;

-- 11. 각 부서별 평균급여를 조회하여 부서명, 평균급여 (정수처리)로 조회하시오.
--      단, 부서배치가 안된 사원들의 평균도 같이 나오게끔 하시오.

-- ANSI 표준

SELECT
    B.DEPT_TITLE 부서명,
    ROUND(AVG(A.SALARY)) 평균급여
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
GROUP BY B.DEPT_TITLE;  

-- 오라클 전용

SELECT
    B.DEPT_TITLE 부서명,
    ROUND(AVG(A.SALARY)) 평균급여
FROM DEPARTMENT B, EMPLOYEE A
WHERE A.DEPT_CODE = B.DEPT_ID(+)
GROUP BY B.DEPT_TITLE;

