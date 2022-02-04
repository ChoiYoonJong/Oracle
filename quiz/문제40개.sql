-- 1. 하이유가 사수인 직원의 사번, 이름, 생년월일을 조회하시오 (주민번호가 이상한 사번 214번은 제외)
SELECT
    EMP_ID 사번,
    EMP_NAME 이름,
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'), 'RR"년 "fmMM"월 "DD"일"') 생년월일
FROM EMPLOYEE
WHERE  MANAGER_ID = 207;

-- 2. 사내 이벤트 당첨자는 이 달에 태어난 사원들이다. 당첨자들의 사번, 이름, 아이디, 부서명을 조회하시오 (단, 사번의 마지막 숫자는 *표시)
SELECT
    DISTINCT
    RPAD(SUBSTR(EMP_ID,1,2),3,'*') 사번,
    EMP_NAME 이름,
    EMP_NO 주민번호,
    DEPT_TITLE 부서명
FROM 
    EMPLOYEE A,
    DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
AND SUBSTR(EMP_NO,3,2) = 01;
    

-- 3. 2000년 이전에 입사한 사람 중, 직급이 대리이거나 급여가 2000000 이하인 사원의  사원번호, 사원명, 부서명, 직급명, 보너스 포함 연봉을 연봉 오름차순으로 조회하시오 (연봉은 원으로 표시)
SELECT
    A.EMP_ID 사원번호,   
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    (SALARY+NVL(BONUS, 0))*12  연봉
FROM
    EMPLOYEE A,
    DEPARTMENT B,
    JOB C
WHERE A.JOB_CODE = C.JOB_CODE
AND A.DEPT_CODE = B.DEPT_ID
AND EXTRACT(YEAR FROM HIRE_DATE) < 2000
AND (C.JOB_NAME LIKE '대리' OR SALARY <= 2000000);

SELECT 
    A.EMP_ID 사원번호,   
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    (A.SALARY*(1+NVL(BONUS, 0)))*12 연봉
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM HIRE_DATE) < 2000
AND (C.JOB_NAME LIKE '대리' OR A.SALARY <= 2000000)
ORDER BY 5;
-- 4. 직급이 사원인 사원들의 사원명, 직급명, 근속년수, 매니저명, 매니저 부서명를 조회하시오 (매니저 없는 사원도 조회) (나이순으로 조회)
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    TO_CHAR((SYSDATE - A.HIRE_DATE)/365, '99')||'년' 근속년수,
    C.EMP_NAME 매니저명,
    D.DEPT_TITLE 매니저부서명
FROM 
    EMPLOYEE A ,
    JOB B,
    EMPLOYEE C,
    DEPARTMENT D
WHERE A.JOB_CODE = B.JOB_CODE
AND A.MANAGER_ID = C.EMP_ID
AND C.DEPT_CODE = D.DEPT_ID
AND B.JOB_NAME LIKE '사원'
ORDER BY A.EMP_NO DESC;


-- 5. 이름이 ‘이’로 시작하는 사원의 이름과 부서명을 조회하시오 (부서명이 NULL인 것도 출력) (1. ANSI 조인, 2. ORACLE 조인)
SELECT
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A
JOIN DEPARTMENT B
    ON A.DEPT_CODE = B.DEPT_ID
WHERE EMP_NAME LIKE '이%';

SELECT
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A,
    DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
AND EMP_NAME LIKE '이%';

-- 6. 직급별 평균 월급 이상의 월급을 받는 직원에게 'GD' / 이하의 월급을 받는 직원은 'NI'등급을 부여. 직원의 사번, 이름, 직급명, 'GD' 등급 / 'NI' 등급을 사번 오름차순으로 조회하시오
--    (단, 월급은 보너스를 포함하며 퇴사한 직원은 제외)(UNION or CASE 사용)
SELECT
    EMP_ID 사번,
    EMP_NAME 이름,
    JOB_NAME 직급명,
    CASE WHEN SALARY > (SELECT
                          AVG(SALARY)
                        FROM EMPLOYEE) THEN 'GD'
                        ELSE 'NI'
                       END 등급
FROM EMPLOYEE
LEFT JOIN JOB USING(JOB_CODE)
WHERE ENT_YN NOT IN 'Y'
ORDER BY 1;


-- 7. 부서별 급여 평균이 3위인 부서들의 부서명과 부서별 급여 평균, 사원수를 조회하고 순위를 붙여 조회하시오 (순위를 오름차순으로 정렬) (부서별 급여 평군은 100000 단위로 표현)
SELECT  
    ROWNUM 순위,
    B.DEPT_TITLE,
    A.부서별급여평균,
    A.사원수
FROM (
         SELECT 
             DEPT_CODE,
             TRUNC(AVG(SALARY), -5) 부서별급여평균,
             COUNT(*) 사원수
         FROM EMPLOYEE
         GROUP BY DEPT_CODE
         ORDER BY AVG(SALARY) DESC
                    ) A
JOIN DEPARTMENT B ON DEPT_CODE = DEPT_ID
WHERE ROWNUM <= 3;


-- 8. EMPLOYEE 테이블에서 ROWNUM(테이블의 일련번호)이 20 이상인 사원이름을 조회하시오
SELECT EMP_NAME
FROM (SELECT ROWNUM NUM, EMP_NAME FROM EMPLOYEE)
WHERE NUM >= 20;


-- 9. 아시아 지역에서 근무하는 사원들을 관리하는 관리자중 보너스를 받는 관리자의 부서별 평균 연봉을 구해 높은 연봉순으로 조회
SELECT
    DEPT_CODE,
   AVG((SALARY + NVL(BONUS,0)*SALARY)*12) 연봉
FROM(
        SELECT
                A.DEPT_CODE,
                A.SALARY,
                A.BONUS,
                E.LOCAL_NAME
              FROM EMPLOYEE A
              JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
              JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
              JOIN EMPLOYEE D ON D.MANAGER_ID = A.EMP_ID
              JOIN LOCATION E ON B.LOCATION_ID = E.LOCAL_CODE
      ) A
WHERE LOCAL_NAME LIKE 'ASIA%'
AND BONUS IS NOT NULL              
GROUP BY DEPT_CODE
ORDER BY 연봉 DESC;


-- 10. D9번 부서의 최소급여를 받는 사원보다 많은 급여를 받는 사원의 사원번호, 이름, 입사일, 급여, 부서번호 조회 (단, D9번 부서는 제외)
SELECT
    EMP_ID 사원번호,
    EMP_NAME 이름,
    HIRE_DATE 입사일,
    SALARY 급여,
    DEPT_CODE 부서번호
FROM EMPLOYEE
WHERE SALARY > (SELECT
                    MIN(SALARY)
                FROM EMPLOYEE
                WHERE DEPT_CODE = 'D9')
AND DEPT_CODE NOT IN 'D9';


-- 11. EMPLOYEE 테이블에서 김씨 성을 가진 사원의 이름과 급여, 입사날짜를 조회하시오(조회하는 컬럼의 별칭을 이름, 급여, 입사날짜로 설정)
SELECT 
    EMP_NAME 이름,
    SALARY 급여,
    HIRE_DATE 입사날짜
FROM EMPLOYEE
WHERE EMP_NAME LIKE '김%';


-- 12. 직원이름, 직원들이 고용된 날짜(요일포함), 고용일에서 수요일과 가장 가까운 날짜, 근무 개월수(오늘날짜기준,소숫점없음)를 구하시오
SELECT
    EMP_NAME 직원이름,
    TO_CHAR(HIRE_DATE, 'DAY') 고용된날짜,
    TO_CHAR(HIRE_DATE, 'DY')요일,
    TRUNC(TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)),12) 근무개월수
FROM EMPLOYEE
WHERE TO_CHAR(HIRE_DATE, 'DY') = '수';


-- 13. 직원 명, 입사 일, 근무 일 수, 연봉, 세율을 구하시오. 이때, 연봉을 오름차순으로 정렬하시오. (CASE 이용)
--     연봉 : (급여+(급여*보너스))*12
--     세율 : 연봉 3000만원 이하는 0.03, 연봉 3000만원 이상 0.05, 연봉 5000만원 초과는 0.07
SELECT
    EMP_NAME 직원명,
    HIRE_DATE 입사일,
    CEIL(SYSDATE-HIRE_DATE) "근무일수",
            TO_CHAR((SALARY + (SALARY * NVL(BONUS, 0)))*12, 'L999,999,999') 연봉,
            CASE
                WHEN (SALARY + (SALARY * NVL(BONUS, 0)))*12 <= 30000000 THEN 0.03
                WHEN (SALARY + (SALARY * NVL(BONUS, 0)))*12 <= 50000000 THEN 0.05
                WHEN (SALARY + (SALARY * NVL(BONUS, 0)))*12 > 50000000 THEN 0.07
            END 세율
        FROM EMPLOYEE
        ORDER BY 4;


-- 14. 매니저가 있는 직원들 중에서 직급코드가 J2 혹은 J4인 직원들의 이름, 보너스포함 연봉, 직급명, 부서명을 조회하시오 (JOIN과 IN 사용)
SELECT
    A.EMP_NAME 사원이름,
    (A.SALARY+NVL(A.BONUS,0))*12 연봉,
    C.JOB_NAME 직급명,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE A.MANAGER_ID IS NOT NULL
AND A.JOB_CODE IN('J2','J4');


-- 15. 주민번호가 60년대 생이고 성별이 남자인 사람중에서, 이름에 '동'이 있는 직원은 제외한 직원들의 사번, 사원명, 주민번호, 부서명, 직급명, 연봉(보너스포함X)을 조회하시오.
--     ANSI표준, 오라클 전용구문 2개 풀이 할 것.
--     JOIN문 사용
   
--ANSI
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    A.SALARY* 12 연봉
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE SUBSTR(EMP_NO,1,1) = '6'
AND SUBSTR(EMP_NO,8,1) = '1'
AND A.EMP_NAME NOT LIKE '%동%';
        
--오라클
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    A.SALARY* 12 연봉
FROM 
    EMPLOYEE A,
    DEPARTMENT B,
    JOB C
WHERE A.DEPT_CODE = B.DEPT_ID
AND A.JOB_CODE = C.JOB_CODE
AND SUBSTR(EMP_NO,1,1) = '6'
AND SUBSTR(EMP_NO,8,1) = '1'
AND A.EMP_NAME NOT LIKE '%동%';


-- 16. 근무 년수가 20년 이상이면서 대표, 부사장, 부장직을 가진 사원들의 사번, 직원명, 직급명, 부서명, 지역명을 출력하시오. 사번으로 오름차순 정렬, JOIN, INTERSECT를 사용
SELECT
    E.EMP_ID 사번,
    E.EMP_NAME 직원명,
    J.JOB_NAME 직급명,
    D.DEPT_TITLE 부서명,
    N.NATIONAL_NAME 지역명
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE E.JOB_CODE IN ('J1','J2','J3')
        
INTERSECT
        
SELECT
    E.EMP_ID,
    E.EMP_NAME,
    J.JOB_NAME,
    D.DEPT_TITLE,
    N.NATIONAL_NAME
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) >= 240
ORDER BY 1;


-- 17. 부서코드 'D5'의 직급별 인원을 조회하시오
 SELECT
    JOB_CODE 부서코드,
    COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
GROUP BY JOB_CODE;


-- 18.  ’심봉선' 사원의 연봉보다 많이 받는 직원의 사번, 이름 , 부서명, 직급명, 연봉을 조회하세요 (연봉은 보너스 포함으로 할 것)
--      ANSI표준, 오라클 전용구문 2개 풀이 할 것.
--ANSI표준
        
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    (SALARY + (SALARY * NVL(BONUS,0)))*12 연봉
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE (SALARY + (SALARY * NVL(BONUS,0)))*12 > (SELECT
                                                (SALARY + (SALARY * NVL(BONUS,0)))*12
                                                FROM EMPLOYEE
                                                WHERE EMP_NAME = '심봉선');
        
--ORACLE
        
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    (SALARY + (SALARY * NVL(BONUS,0)))*12 연봉
FROM 
    EMPLOYEE A,
    DEPARTMENT B,
    JOB C
WHERE A.DEPT_CODE = B.DEPT_ID
AND A.JOB_CODE = C.JOB_CODE
AND (SALARY + (SALARY * NVL(BONUS,0)))*12 > (SELECT
                                                (SALARY + (SALARY * NVL(BONUS,0)))*12
                                            FROM EMPLOYEE
                                            WHERE EMP_NAME = '심봉선');


-- 19. 직원 테이블에서 입사일자가 오래된 순인 5명의 사번, 이름, 부서명을 조회하시오
SELECT
    A.*
FROM (SELECT
        A.EMP_ID 사번,
        A.EMP_NAME 이름,
        B.DEPT_TITLE 부서명
    FROM EMPLOYEE A, DEPARTMENT B
    WHERE A.DEPT_CODE = B.DEPT_ID
    ORDER BY A.HIRE_DATE) A
WHERE ROWNUM <= 5;
        


-- 20. 급여의 합계가 송씨 성을 가진 사람들의 평균보다 많이 받는 사람의 이름과 직책, 부서 조회하시오(송씨 성을 가진 직원 포함) (조회하는 컬럼의 별칭을 이름, 직책, 부서로 설정)
 SELECT
    A.EMP_NAME 이름,
    B.JOB_NAME 직책,
    C.DEPT_TITLE 부서
FROM 
    EMPLOYEE A,
    JOB B,
    DEPARTMENT C
WHERE A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND SALARY > (SELECT
                   AVG(SALARY)
                FROM EMPLOYEE
                WHERE EMP_NAME LIKE '송%'
                        );


-- 21. 각 부서별로 나이가 가장 어린 사람의 사번, 사원명, 부서명, 직급명, 나이 조회
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) 나이
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C USING(JOB_CODE)
JOIN (SELECT 
        MAX(EMP_NO) 주민번호
      FROM EMPLOYEE
GROUP BY DEPT_CODE) D ON A.EMP_NO = D.주민번호
WHERE DEPT_CODE IS NOT NULL;        
    
    
-- 22. 본인의 급여등급 평균보다 급여를 15% 더 받는 직원의 이름, 급여등급, 급여 조회
 SELECT
    A.EMP_NAME 이름,
    A.SAL_LEVEL 급여등급,
    A.SALARY 급여
FROM EMPLOYEE A
WHERE A.SALARY > (SELECT
                    AVG(B.SALARY)*1.15
                FROM EMPLOYEE B 
                WHERE A.SAL_LEVEL=B.SAL_LEVEL);  
        
        
-- 23. 직급이 대리이면서 하이유와 같은 관리자를 가진 사원의 이름,부서명,관리자 사번 조회
 SELECT
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    A.MANAGER_ID 관리자사번
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
WHERE MANAGER_ID = (SELECT
                        MANAGER_ID
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유')
AND A.JOB_CODE = 'J6';  
   
        
-- 24. 직급이 과장 이상이면서 나이가 38세 이상인 사원의 사원명,부서코드,직급명,나이를 조회
 SELECT
    A.EMP_NAME 사원명,
    A.DEPT_CODE 부서코드,
    B.JOB_NAME 직급명,
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) 나이
FROM EMPLOYEE A, JOB B
WHERE A.JOB_CODE = B.JOB_CODE
AND EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) >= 38
AND A.JOB_CODE <='J5';   
    
        
-- 25. 평균급여 이상을 받는 사원에 대해 직원명, 급여,부서명, 직급명과 급여가 많은 순서로 5위까지 추출
 SELECT
    ROWNUM AS 순위,
    A.EMP_NAME AS 직원명,
    A.SALARY AS 급여,
    A.DEPT_TITLE AS 부서명,
    A.JOB_NAME AS 직급명
FROM ( SELECT
            A.EMP_NAME,
        	A.SALARY,
        	B.DEPT_TITLE,
        	C.JOB_NAME
        FROM EMPLOYEE A
        LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
        LEFT JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
        WHERE A.SALARY > ( SELECT
                        AVG(SALARY)
                        FROM EMPLOYEE)
                        ORDER BY A.SALARY DESC)A
        WHERE ROWNUM <=5;   
    
        
-- 26. EMAIL의 ‘_’ 앞이 3글자면서 여성인 사원을 조회하세요.
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '___^_%' ESCAPE '^'
AND SUBSTR(EMP_NO,8,1) ='2';  
   
        
-- 27. 전화번호가 010으로 시작하는 사람들의 이름과 전화번호를 조회하세요.(전화번호는 4번째부터 7번째 까지의 숫자를 ‘*’로 바꾸세요.)
SELECT
    EMP_NAME 이름,
    REPLACE(PHONE,SUBSTR(PHONE,4,4),'****') 전화번호
FROM EMPLOYEE
WHERE SUBSTR(PHONE,1,3) = 010;   
   
        
-- 28. 전사원의 사원명, 부서명을 조회하세요. (부서값이 NULL인 사람은 부서명을 ‘미배정’으로 출력)
SELECT
    EMP_NAME 이름,
    NVL(DEPT_TITLE,'미배정')
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;    
    
        
-- 29. 가장 늦게 입사한 사원의 이름,부서코드,근무년수를 조회하세요.
SELECT
    EMP_NAME 이름,
    DEPT_CODE 부서코드,
    EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM HIRE_DATE)+1||'년' 근무년수
FROM EMPLOYEE
WHERE HIRE_DATE = (SELECT MAX(HIRE_DATE) FROM EMPLOYEE);   
   
        
-- 30. 해외에 근무하는 직원들의 사원명, 부서명, 국가명을 조회하세요.
  SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    D.NATIONAL_NAME 국가명
FROM EMPLOYEE A,
     DEPARTMENT B,
     LOCATION C,
     NATIONAL D
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE
AND C.NATIONAL_CODE = D.NATIONAL_CODE
AND D.NATIONAL_CODE NOT LIKE 'KO';


-- 31. 팀원(직원)이 3명 이상인 부서의 부서 코드, 팀원 수, 부서 별 평균 연봉, 순위(평균 연봉)를 구하시오.
--      이 때 부서 별 평균 연봉의 순위는 가장 큰 3개의 부서만 구하시오.
--      (단, 부서 코드가 없는 직원은 제외한다.)
SELECT 
        A.*,
        ROWNUM AS 순위
    FROM (SELECT 
            DEPT_CODE AS 부서코드,
            COUNT(DEPT_CODE) AS 팀원수, 
            AVG(SALARY*12) AS 평균연봉
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY 평균연봉 DESC) A 
WHERE A.팀원수 >= 3
AND ROWNUM <= 3;


-- 32. 부서 별 직원 소계, 부서 별 각 직급의 인원수, 전체 직원 수를 구하시오. (직급 별 소계는 하지 않는다)
--      비고 컬럼을 만들어 부서 별 소계는 '부서총합계'로 표시하고 직급별 인원수는 '-'로 표시하시오.
--      비고 컬럼에 전 직원 총 합계는 '전직원총합계'로 표시하시오.
--      이 때, 인원수는 숫자(수) 뒤 '명'이 같이 나오도록 하고 부서 명과 직급 명 모두 오름차순으로 하시오.
--      (단, 부서 명과 직급 명이 없는(NULL) 직원도 조회하되 ‘-’로 표시하시오.)
SELECT 
    NVL(B.DEPT_TITLE, '-')  부서명, 
    NVL(C.JOB_NAME, '-')  직급, 
    CONCAT(COUNT(A.JOB_CODE), '명')  인원수,
    CASE WHEN GROUPING(B.DEPT_TITLE) = 1 AND GROUPING(C.JOB_NAME) = 1 THEN '전직원총합계'  
        WHEN GROUPING(B.DEPT_TITLE) = 0 AND GROUPING(C.JOB_NAME) = 1 THEN '부서총합계'  
        ELSE '-' 
        END  비고
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
LEFT JOIN JOB C ON C.JOB_CODE = A.JOB_CODE
GROUP BY ROLLUP(B.DEPT_TITLE, C.JOB_NAME)
ORDER BY B.DEPT_TITLE, C.JOB_NAME;


-- 33. EMPLOYEE 테이블에서 직급 별로 가장 많은 급여를 받는 사원들 중 직급 코드가 'J2' 또는 'J6'인 사원들의
--      사원 명, 부서 명, 직급 코드, 급여, 연봉(보너스 포함, NULL인 수는 0으로)을 구하세요.
SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    A.JOB_CODE 직급코드,
    A.SALARY 급여,
    (SALARY + SALARY * NVL(BONUS,0)) * 12 연봉
FROM EMPLOYEE A,
     DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
AND SALARY IN (SELECT
                    MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY JOB_CODE) 
AND JOB_CODE IN ('J2', 'J6');   


-- 34.EMPLOYEE 테이블에서 이메일의 '_' 앞까지 문자가 네 글자인 사원의 사원 번호, 사원 명, 부서 명, 직급 명, 이메일을 조회하세요.

SELECT
    A.EMP_NO 사원번호,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.JOB_CODE 직급명,
    A.EMAIL 이메일 
FROM 
    EMPLOYEE A, 
    DEPARTMENT B, 
    JOB C
WHERE A.DEPT_CODE = B.DEPT_ID
AND A.JOB_CODE = C.JOB_CODE
AND EMAIL LIKE '____^_%' ESCAPE '^';
    
    
-- 35. 직급 코드와 직급별 급여 합계를 조회 후 급여 합계별 내림차순 정렬 하시오 (GROUP BY)
 SELECT
    JOB_CODE 부서코드,
    SUM(SALARY)급여합계
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 2 DESC;     
   
    
-- 36. 부서별 그룹의 급여 합계중 7백만원을 초과하는 부서코드와 급여합계를 조회하시오 (GROUP BY)
 SELECT
    DEPT_CODE 부서코드,
    SUM(SALARY) 급여합계     
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 7000000
ORDER BY 2 DESC;
    
    
-- 37. 부서별 최소 급여를 받는 직원들보다 높은 급여를 받는 직원들의 이름, 직급코드, 부서코드, 급여를 모두 조회하시오 (SUB QUERY)
--      부서는 총 7 (null  포함)  부서 수를 제외한 인원이 나와야한다.
SELECT 
    EMP_NAME 이름,
    JOB_CODE 직급코드,
    DEPT_CODE 부서코드,
    SALARY 급여
FROM EMPLOYEE
WHERE (DEPT_CODE,SALARY) NOT IN ( SELECT
                              DEPT_CODE,
                              MIN(SALARY)
                              FROM EMPLOYEE
                            GROUP BY DEPT_CODE );    
    
    
-- 38. 휴대폰 번호가 011로 시작하는 사원들의 연봉 순위를 구하고 그 사원들의 사원이름, 직급명, 부서명, 핸드폰 번호, 연봉(보너스포함)을 출력하세요.
 SELECT
        A.*
    FROM (
            SELECT
                A.EMP_NAME,
                B.JOB_NAME,
                C.DEPT_TITLE,
                A.PHONE,
                (A.SALARY + A.SALARY*NVL(BONUS, 0)) * 12 연봉,
                RANK () OVER (ORDER BY (A.SALARY + A.SALARY*NVL(BONUS, 0)) * 12 DESC) RANK -- RANK () OVER 를 사용하여 연봉순위를 구하고 같이 출력해준다
            FROM EMPLOYEE A
            JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
            LEFT JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID) A
    WHERE PHONE LIKE '011%';    
   
    
-- 39. 전형돈과 월급이 같거나 같은부서인 사원의 이름,부서명,급여, 근무일수(뒤에 일을 붙여서)를 추출
SELECT
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    A.SALARY 급여,
    TRUNC(SYSDATE - HIRE_DATE) + 1 || '일' 근무일수
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
WHERE A.SALARY = (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '전형돈')
OR A.DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE = 'D8');    

-- 40. 하이유 사원은 자신보다 늦게 입사한 사람이 궁금해졌다. 하이유 사원보다 입사일이 늦은 사원들의
--      사원명, 직급명, 부서명, 급여를 부서코드 기준으로 오름차순으로 출력하라
SELECT
    A.EMP_NAME,
    B.JOB_NAME,
    C.DEPT_TITLE,
    A.SALARY
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
LEFT JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
WHERE HIRE_DATE > (SELECT
                        HIRE_DATE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유')
ORDER BY A.DEPT_CODE;    

   