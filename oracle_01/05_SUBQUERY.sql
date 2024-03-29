--@서브쿼리(SubQuery)

/*하나의 SQL 문안에 포함되어있는 또다른 SQL 문
알려지지 않은 조건에 근거한 값들을 검색하는 SELECT 문장을 작성하는데 유용함
메인쿼리가 서브쿼리를 포함하는 종속적인 관계
서브쿼리는 반드시 소괄호 로 묶어야함
-> (SELECT...) 형태
@@@@@서브쿼리 내에서 ORDER BY 문법은 지원안됨@@@@@@
*/

-- 사원명이 노옹철인 사람의 부서 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 부서코드가 D9인 직원을 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

SELECT 
    EMP_NAME
FROM 
    EMPLOYEE
WHERE 
    DEPT_CODE = (SELECT 
                    DEPT_CODE
                FROM 
                    EMPLOYEE
                WHERE EMP_NAME = '노옹철');

-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의
-- 사번, 이름, 직급코드, 급여를 조회하세요
SELECT 
    EMP_ID 사번,
    EMP_NAME 이름,
    JOB_CODE 직급코드,
    SALARY 급여
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                 FROM EMPLOYEE);
                 

--서브쿼리의 유형
--단일행 서브쿼리 : 서브쿼리의 조회 결과값이 1개 행일때
--다중행 서브쿼리 : 서브쿼리의 조회 결과값의 행이 여러개일때
--다중열 서브쿼리 : 서브쿼리의 조회 결과값의 컬럼이 여러개일때
--다중행 다중열 서브쿼리 : 조회경로가 행 수와 열수가 여러개일때
--상(호연)관서브쿼리 : 서브쿼리가 만든 결과값을 메인쿼리가 비교 연산할때 
--                  메인쿼리의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리 
--스칼라 서브쿼리 : 상관쿼리이면서 결과값이 하나인 서브쿼리 

--* 서브쿼리의 유형에 따라 서브쿼리 앞에 붙은 연산자가 다름


--1. 단일행 서브쿼리 
-- 단일행서브쿼리앞에는 일반비교 연산자사용
-- >,<,>=,<=,=, !=,<>,^= (서브쿼리)

--노옹철 사원의 급여보다 많이 받는 직원의 
--사번, 이름 , 부서, 직급, 급여를 조회하세요

SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    A.SALARY 급여
FROM EMPLOYEE A, DEPARTMENT B, JOB C
WHERE A.DEPT_CODE = B.DEPT_ID
AND A.JOB_CODE = C.JOB_CODE
AND SALARY > (SELECT SALARY
              FROM EMPLOYEE
              WHERE EMP_NAME ='노옹철');
              
--서브쿼리는 SELECT ,FROM,WHERE,HAVING,ORDER BY 절에도 사용 할수 있다. 
--부서별 급여의 합계중 가장 큰부서의 부서명 , 급여 합계를 구하세요
SELECT 
    B.DEPT_TITLE 부서명,
    SUM(SALARY) AS "급여 합계"
FROM 
   EMPLOYEE A
LEFT JOIN DEPARTMENT B  ON A.DEPT_CODE = B.DEPT_ID
GROUP BY B.DEPT_TITLE
HAVING SUM(A.SALARY) = (SELECT  MAX(SUM(SALARY))
                      FROM EMPLOYEE 
                      GROUP BY DEPT_CODE);
                      

--2. 다중행 서브쿼리 
-- 다중행 서브쿼리 앞에서는 일반 비교 연산자를 사용 할수 없다
-- IN / NOT IN : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면 , 혹은 없다면 이라는 의미
-- > ANY, < ANY : 여러개의 결과값중에서 한개라도 큰 / 작은 경우 - 가장 작은 값보다 크냐? /가장 큰 값보다 작냐?
-- > ALL, < ALL : 모든값 보다 큰 / 작은 경우 - 가장 큰 값보다 크냐?/가장 작은 값보다 작냐?
-- EXIST / NOT EXIST : 서브쿼리에만 사용하는 연산자로 서브쿼리의 결과중에서 만족하는 값이 하나라도 존재하면 참
--                     값이 존재하는가? / 존재하지않는가?


--부서별 최고 급여를 받는 직원의 이름, 직급, 부서 , 급여 조회
SELECT
    DEPT_CODE,
    MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;


SELECT
    EMP_NAME 이름,
    JOB_CODE 직급,
    DEPT_CODE 부서,
    SALARY AS "급여 조회"
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY) 
               FROM EMPLOYEE 
               GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE; 

-- 관리자에 해당하는 직원에 대한 정보와 관리자가 아닌직원의 정보를 추출하여 조회 
-- 사번, 이름 , 부서명 , 직급, '관리자' AS 구분 / '직원' AS 구분
SELECT
    DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    '관리자' 구분
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
LEFT JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE A.EMP_ID IN (SELECT DISTINCT MANAGER_ID 
                 FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL)
UNION
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    '직급' 구분
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
LEFT JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE A.EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID 
                 FROM EMPLOYEE
                WHERE MANAGER_ID IS NOT NULL);
                

SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID 
                         FROM EMPLOYEE
                         WHERE MANAGER_ID IS NOT NULL) THEN '관리자'
                        ELSE '직원'
                        END 구분
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON(A.DEPT_CODE = B.DEPT_ID)
LEFT JOIN JOB C ON A.JOB_CODE = C.JOB_CODE;

-- ANY : 서브쿼리의 결과중에서  하나라도 참이면 참 
/*  > ANY : 최소값 보다 크면
	>= ANY : 최소값보다 크거나 같으면
	< ANY : 최대값보다 작으면
	<= ANY : 최대값보다 작거나 같으면
	= ANY : IN과 같은 효과
	!= ANY : NOT IN과 같은 효과 */

-- J3 코드를 가진 사람의 급여들을 가지고 비교 할때
SELECT
    SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J3'
ORDER BY SALARY;

-- 3400000 최소값
-- 3900000 최대값

SELECT
    EMP_NAME,SALARY
FROM EMPLOYEE
WHERE SALARY < ANY(SELECT
                        SALARY
                    FROM EMPLOYEE
                    WHERE JOB_CODE = 'J3');
--> 설명 : < ANY 이므로 서브쿼리에서 출력된 결과중 최대 값보다 작으면 출력 
--        하나라도 참이면 되기 때문에 최대값 보다 작으면 된다.

SELECT
    EMP_NAME,SALARY
FROM EMPLOYEE
WHERE SALARY > ANY(SELECT
                        SALARY
                    FROM EMPLOYEE
                    WHERE JOB_CODE = 'J3');
                    
--ALL : 서브 쿼리의 결과중에서 모두 참이면 참 (ANY 와는 약간 다른 개념 ) 
/*  > ALL : 최대값 보다 크면
	>= ALL : 최대값보다 크거나 같으면
	< ALL : 최소값보다 작으면
	<= ALL : 최소값보다 작거나 같으면
	= ALL : SUBSELECT의 결과가 1건이면 상관없지만 여러건이면 오류가 발생
	!= ALL : 위와 마찬가지로 결과가 여러건이면 오류 발생
*/
SELECT
    EMP_NAME,SALARY
FROM EMPLOYEE
WHERE SALARY < ALL(SELECT
                        SALARY
                    FROM EMPLOYEE
                    WHERE JOB_CODE = 'J3');
--> 설명 : < ALL 이므로 서브쿼리에서 출력된 결과중 최소 값보다 작으면 출력 
--        모두 참이어야 하기때문에 작으려면 최소값이 제일 작은 값이므로 최소값 보다 작아야한다.
                
SELECT
    EMP_NAME,SALARY
FROM EMPLOYEE
WHERE SALARY > ALL(SELECT
                        SALARY
                    FROM EMPLOYEE
                    WHERE JOB_CODE = 'J3');
--> 설명 : < ALL 이므로 서브쿼리에서 출력된 결과중 최소 값보다 작으면 출력 
--        모두 참이어야 하기때문에 작으려면 최소값이 제일 작은 값이므로 최소값 보다 작아야한다.

-- 과장직급의 직원들 중에서 차장직급의 최소 급여보다 많이 받는 
-- 직원의 사번, 이름 , 직급명, 급여를 조회하세요 
-- 단, > ANY 혹은 < ANY 연산자 사용


-- 과장직급의 직원들 중에서 차장직급의 최소 급여보다 많이 받는 
-- 직원의 사번, 이름 , 직급명, 급여를 조회하세요 
-- 단, > ANY 혹은 < ANY 연산자 사용

SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.JOB_NAME 직급명,
    A.SALARY 급여
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE A.JOB_CODE ='J5'
AND A.SALARY > ANY(SELECT A.SALARY
                  FROM EMPLOYEE A 
                  JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
                  WHERE B.JOB_CODE = 'J4');
                  

--차장 직급의 급여의 가장큰 값보다 많이 받는 과장직급의 
--사번, 이름 , 직급, 급여 를 조회하세요 
-- 단 > ALL 혹은 < ALL 연산자를 사용
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.JOB_NAME 직급명,
    A.SALARY 급여
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE A.JOB_CODE ='J5'
AND A.SALARY > ALL(SELECT A.SALARY
                  FROM EMPLOYEE A 
                  JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
                  WHERE B.JOB_CODE = 'J4');
                  
--EXISTS : 서브쿼리의 결과 중에서 만족하는 값이 하나라도 존재하면 참
-- 참, 거짓 서브쿼리안에 값이 있는지 없는지 
-- 서브쿼리 결과가 참이면 메인쿼리를 실행, 서브쿼리 결과가 거짓이면 메인쿼리를 실행하지않는다.

SELECT 
    *
FROM EMPLOYEE
WHERE EXISTS(SELECT
                EMP_NAME
            FROM EMPLOYEE
            WHERE NVL(BONUS,0) >=0.5);
            
-- 다중열 서브쿼리 
--> 서브쿼리의 조회결과 컬럼의 개수가 여러개일때 (다중행하고는 다르게 결과값이 컬럼이 여러개!!)


-- 퇴사한 여직원과 같은부서, 같은 직급에 해당하는 사원의 이름 , 직급코드 ,부서코드, 입사일을 조회
SELECT
    EMP_ID 아이디,
    EMP_NAME 이름,
    DEPT_CODE 부서코드,
    JOB_CODE 직급코드
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)='2' 
AND ENT_YN='Y';

SELECT
    EMP_ID 아이디,
    EMP_NAME 이름,
    DEPT_CODE 부서코드,
    JOB_CODE 직급코드
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE 
                    FROM EMPLOYEE
                    WHERE SUBSTR(EMP_NO,8,1)='2' 
                    AND ENT_YN='Y')
AND EMP_ID NOT IN (SELECT EMP_ID 
                    FROM EMPLOYEE
                    WHERE SUBSTR(EMP_NO,8,1)='2' 
                    AND ENT_YN='Y');

-- > 다중열 서브쿼리 적용                    
SELECT
    EMP_ID 아이디,
    EMP_NAME 이름,
    DEPT_CODE 부서코드,
    JOB_CODE 직급코드
FROM EMPLOYEE
WHERE
  (DEPT_CODE,JOB_CODE) = (SELECT
                               DEPT_CODE
                            ,  JOB_CODE
                         FROM 
                               EMPLOYEE
                         WHERE
                               SUBSTR(EMP_NO,8,1)='2' AND ENT_YN='Y');

--다중행다중열 서브쿼리를 이용 
-- 직급별 평균월급이 직급과 월급둘다 일치하는 사원 (만원단위로 계산하세요 TRUNC(컬럼명, -5))
SELECT
    EMP_NAME,
    JOB_CODE,
    SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT
                                JOB_CODE,
                                TRUNC(AVG(SALARY),-5)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE);

-- 상[호연]관 서브쿼리
-- 일반적으로는 서브쿼리가 만든 결과값을 메인쿼리가 비교 연산
-- 메인쿼리가 사용하는 테이블의 값을 서브쿼리가 이용해서 결과를 만듬
-- 메인쿼리의 테이블 값이 변경되면, 서브쿼리의 결과값도 바뀌게 됨

--메인쿼리에 있는것을 서브쿼리에서 가져다쓰면 상관 서브쿼리
--서브쿼리가 독단적으로 사용이 되면 일반서브쿼리


-- 관리자 사번이 EMPLOYEE 테이블에 존재 하는 직원에 대한 조회
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    A.MANAGER_ID
FROM EMPLOYEE A
WHERE EXISTS (SELECT
                B.EMP_ID
              FROM EMPLOYEE B
              WHERE B.MANAGER_ID = A.EMP_ID);

-- 스칼라 서브쿼리
-- 단일행 서브쿼리 + 상관쿼리(-> 상관쿼리 이면서 결과값이 1개인 서브쿼리)
-- SELECT절, WHERE절, ORDER BY절 사용 가능


-- WHERE절에서 스칼라 서브쿼리 이용
-- 동일 직급의 급여 평균보다 급여를 많이 받고 있는 직원의
-- 사번, 직급코드, 급여를 조회하세요

SELECT
    A.EMP_ID 사번,
    A.JOB_CODE 직급코드,
    A.SALARY 급여
FROM EMPLOYEE A
WHERE A.SALARY > (SELECT
                TRUNC(AVG(B.SALARY),-5)
                FROM EMPLOYEE B
                WHERE B.JOB_CODE = A.JOB_CODE);

--SELECT 절에서 스칼라 서브쿼리 이용 
-- 모든 사원의 사번, 이름, 관리자 사번, 관리자명 조회
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    A.MANAGER_ID,
    NVL((SELECT B.EMP_NAME
    FROM EMPLOYEE B
    WHERE B.EMP_ID = A.MANAGER_ID),'없음') 관리자명
FROM EMPLOYEE A;

-- ORDER BY 절에서 스칼라 서브쿼리 이용 

-- 모든 직원의 사번, 이름 , 소속 부서코드 조회
-- 단 부서명 내림차순 정렬

SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE
FROM EMPLOYEE
ORDER BY (SELECT DEPT_TITLE
          FROM DEPARTMENT
          WHERE DEPT_ID = DEPT_CODE)DESC NULLS LAST;
          
-- 서브쿼리의 사용 위치 : 
-- SELECT절, FROM절, WHERE절, HAVING절, GROUP BY절, ORDER BY절
-- DML 구문 : INSERT문, UPDATE문
-- DDL 구문 : CREATE TABLE문, CREATE VIEW문

-- FROM 절에서 서브쿼리를 사용할 수 있다 : 테이블 대신에 사용
-- 인라인 뷰(INLINE VIEW)라고 함
-- : 서브쿼리가 만든 결과집합(RESULT SET)에 대한 출력 화면

--JOB 코드별 월급 평균(TRUNC(AVG(E2.SALARY), -5))을 구하고 월급이 이와 일치하는 사원정보 이름, 직급명,월급 구하기
SELECT
    A.EMP_NAME,
    C.JOB_NAME,
    A.SALARY
FROM EMPLOYEE A
JOIN (SELECT 
        JOB_CODE,
        TRUNC(AVG(SALARY),-5)JOBAVG
      FROM EMPLOYEE
      GROUP BY JOB_CODE) B ON A.JOB_CODE = B.JOB_CODE AND A.SALARY = JOBAVG
JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
ORDER BY A.JOB_CODE;

-- 부서명이 인사관리부인 사원명  , 부서명, 직급이름 을 구하시오 (인라인뷰사용)
SELECT
   *
FROM (
      SELECT
        A.EMP_NAME,
        B.DEPT_TITLE,
        C.JOB_NAME
      FROM EMPLOYEE A
      LEFT OUTER JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
      INNER JOIN JOB C ON A.JOB_CODE = A.JOB_CODE
      )
WHERE DEPT_TITLE = '인사관리부';
      

SELECT 
    EMP_NAME, 
    SALARY 
FROM (SELECT * 
        FROM EMPLOYEE 
        ORDER BY SALARY DESC);
        
SELECT 
    EMP_ID 사원번호,
    EMP_NAME 사원명, 
    DEPT_CODE 부서코드,
    MANAGER_ID 관리자사번
FROM EMPLOYEE A 
WHERE EXISTS (SELECT EMP_ID 
              FROM EMPLOYEE B 
              WHERE A.MANAGER_ID = B.EMP_ID);


SELECT 
    EMP_ID 사원번호,
    EMP_NAME 사원명, 
    JOB_CODE 부서코드, 
    SALARY 봉급
FROM EMPLOYEE 
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE);

/*
# TOP-N 분석이란?
	TOP-N 질의는 columns에서 가장 큰 n개의 값 또는 가장 작은 n개의 값을 요청할 때
	사용됨
	예) 가장 적게 팔린 제품 10가지는? 또는 회사에서 가장 소득이 많은 사람 3명은?
*/
-- 인라인뷰를 활용한 TOP-N분석
-- ORDER BY 한 결과에 ROWNUM을 붙임
-- ROWNUM은 행 번호를 의미함

--ex) --TOP-N 분석 : 회사에서 연봉이 가장 높은 사람 5명은?

SELECT
    ROWNUM,
    EMP_NAME,
    SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

SELECT ROWNUM, A.*
FROM EMPLOYEE A
WHERE SALARY >= 3700000
ORDER BY SALARY DESC;

SELECT
    ROWNUM,
    EMP_NAME,
    SALARY
FROM (
     SELECT A.*
     FROM EMPLOYEE A
     ORDER BY SALARY DESC
     ) A
WHERE ROWNUM <= 5;

-- 급여 평균 3위안에드는 부서의 부서코드와 부서명 , 평균급여를 조회하세요 (인라인뷰를 활용한 TOP-N분석 사용 )
SELECT *
FROM
   (SELECT
      A.DEPT_CODE 부서코드,
      B.DEPT_TITLE 부서명,
      FLOOR(AVG(A.SALARY)) 평균급여
 FROM EMPLOYEE A
    JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
    GROUP BY A.DEPT_CODE, B.DEPT_TITLE
    ORDER BY 평균급여 DESC)
WHERE ROWNUM <= 3;

-- RANK() OVER(정렬기준) / DENSE_RANK() OVER(정렬기준)
--    보다 쉽게 순위 매기는 함수
-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
--               EX) 공동 1위가 2명이면 다음 순위는 2위가 아니라 3위
-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 무조건 1씩 증가시키는
--              EX) 공동 1위가 2명이더라도 다음 순위는 2위

SELECT
    EMP_NAME,
    SALARY,
    DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;

SELECT
    EMP_NAME,
    SALARY,
    RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;



SELECT
    A.*
FROM (
    SELECT
    EMP_NAME,
    SALARY,
    RANK() OVER(ORDER BY SALARY DESC) 순위
    FROM EMPLOYEE
)A
WHERE A.순위 <= 5;

-- 직원 테이블에서 보너스 포함한 연봉이 높은 5명의 RANK() OVER
-- 사번, 이름, 부서명, 직급명, 입사일을 조회하세요

SELECT *
FROM (SELECT A.EMP_ID 사번, A.EMP_NAME 이름, B.DEPT_TITLE 부서명, C.JOB_NAME 직급명, A.HIRE_DATE 입사일, 
              A.SALARY,(A.SALARY + (A.SALARY * NVL(A.BONUS,0))) * 12 연봉,
              RANK() OVER(ORDER BY ((A.SALARY + (A.SALARY * NVL(A.BONUS, 0))) * 12) DESC) 순위
              FROM EMPLOYEE A, DEPARTMENT B, JOB C
              WHERE B.DEPT_ID = A.DEPT_CODE
              AND A.JOB_CODE = C.JOB_CODE)
WHERE 순위 <= 5;

-- WITH 이름 AS (쿼리문)
-- 서브쿼리에 이름을 붙여주고 사용시 이름을 사용하게 됨
-- 인라인뷰로 사용될 서브쿼리에서 이용됨
-- 같은 서브쿼리가 여러번 사용될 경우 중복 작성을 줄일 수 있다.

WITH TOPN_SAL AS
    (
        SELECT
            EMP_ID,
            EMP_NAME,
            SALARY
        FROM EMPLOYEE
        ORDER BY 3 DESC
    )
SELECT
    ROWNUM,
    EMP_NAME,
    SALARY
FROM TOPN_SAL;


-- 부서별 급여 합계가 전체 급여의 총 합의 20%보다 많은
-- 부서의 부서명과, 부서별 급여 합계 조회

--1. HAVING
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY) * 0.2
                                                FROM EMPLOYEE);
                                                
--2. 인라인뷰


--3. WITH

--WITH 절 여러개

WITH TOT_SAL AS
    (
        SELECT SUM(SALARY) SAL1
        FROM EMPLOYEE
    ),
    AVG_SAL AS
    (
        SELECT AVG(SALARY)SAL2
        FROM EMPLOYEE
    )
SELECT
    '합' COL1, ROUND(A.SAL1,0) COL2
FROM TOT_SAL A
UNION ALL
SELECT
    '평균' COL1, ROUND(A.SAL2,0) COL2
FROM AVG_SAL A
UNION ALL
SELECT
    '직원' COL1,SUM(SALARY) COL2
FROM EMPLOYEE
WHERE EMP_ID IN('200','201');


WITH TOT_SAL AS
    (
        SELECT SUM(SALARY) SAL1
        FROM EMPLOYEE
    ),
    AVG_SAL AS
    (
        SELECT AVG(SALARY)SAL2
        FROM EMPLOYEE
    )
SELECT
    A.*,ROUND(SAL1,0) 합, ROUND(SAL2,0) 평균
FROM EMPLOYEE A,TOT_SAL, AVG_SAL;


