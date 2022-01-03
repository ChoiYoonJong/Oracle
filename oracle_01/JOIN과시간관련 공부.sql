--Inner join. Inner join
--Left outer join
--Right outer join
--Full outer join

-- JOIN 한개 이상의 테이블과 테이블을 서로 연결하여 사용하는 기법
-- EQUAL JOIN 조인 조건이 일치하는 경우에 결과를 출력
-- NONE EQUAL JOIN 조인 조건이 일치하지 않는 경우에 결과를 출력
-- OUTER JOIN 조인 조건이 정확히 일치하지 않아도 모든 결과를 출력
-- SELF JOIN 자체 테이블에서 조인하고자 할때 사용

/*
SELECT 테이블 이름 1.열이름1, 테이블 이름 2 . 열이름2, ...
FROM 테이블 이름1, 테이블 이름2
WHERE 테이블1.열이름 1 = 테이블2.열이름2;

SELECT A.열이름1, B. 열이름2, ...
FROM 테이블 이름1 A, 테이블 이름2 B ...
WHERE A.열이름 1 = B.열이름2;  

테이블 이름을 A 혹은 자기가 쉽게 이해 할 수 있게 만들어서 테이블 이름 쓰는곳에 적용해서 사용할 수 있다.
*/



-- 예제문제 EMPLOYEE 테이블과 DEPARTMENT테이블을 조인하여 각지원이 어느부서에 속하는지와 부서의 소재지가 어디인지 조회하시요.

--ORACLE 표준
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.DEPT_TITLE
FROM EMPLOYEE A, DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
ORDER BY 1;


-- ANSI 표준
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.DEPT_TITLE
FROM EMPLOYEE A 
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
ORDER BY 1;

--INNER JOIN :기준 테이블과 조인 테이블 모두 데이터가 존재해야 조회됨

SELECT 
    A.EMP_NO,
    A.EMP_NAME,
    B.DEPT_ID
  FROM EMPLOYEE A
 INNER JOIN DEPARTMENT B
    ON A.DEPT_CODE = B.DEPT_ID;
    
SELECT 
    A.EMP_NAME,
    B.DEPT_TITLE,
    B.DEPT_ID
FROM EMPLOYEE A INNER JOIN DEPARTMENT B
on A.DEPT_CODE = B.DEPT_ID;


--Left outer join

/*
select x.컬럼이름A, 
       y.컬럼이름B,
       z.컬럼이름C, ...
from 테이블이름X x, 테이블이름Y y, 테이블이름Z z, ...
where x.컬럼이름M=y.컬럼이름N(+)
  and y.컬럼이름O=z.컬럼이름Q(+);
*/

--LEFT OUTER JOIN
--ANSI표준
SELECT *
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--RIGHT OUTER JOIN
--ANSI표준
SELECT DISTINCT(DEPT_CODE)
FROM EMPLOYEE;

SELECT  *
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = DEPT_ID;

--오라클 전용구문
SELECT *
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
SELECT *
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;






-- 날짜 형식

--YYYY 연도 4자리 TO_CHAR(SYSDATE , 'YYYY')
--YYY 연도 3자리 TO_CHAR(SYSDATE,'YYY')
--YY 연도 2자리 TO_CHAR(SYSDATE,'YY')
--YEAR 연도 문자 TO_CHAR(SYSDATE,'YEAR')

--MM 월 2자리 TO_CHAR(SYSDATE,'MM')
--MOM 월 이름 TO_CHAR(SYSDATE,'MON')
--RM 월 로마숫자 TO_CHAR(SYSDATE,'RM')

--WW 주 연기준 TO_CHAR(SYSDATE,'WW')
--W 주 월기준 TO_CHAR(SYSDATE,'W')

--DDD 일 연기준 TO_CHAR(SYSDATE,'DDD')
--DD 일 월기준 TO_CHAR(SYSDATE,'DD')
--D 일 주기준 TO_CHAR(SYSDATE,'D')

--DAY 요일 TO_CHAR(SYSDATE,'DAY')
--DY 요일 약어 TO_CHAR(SYSDATE, 'DY')

--현재 날짜, 다음날짜, 어제날짜
SELECT SYSDATE 오늘, SYSDATE + 1 내일, SYSDATE -1 어제
FROM DUAL;

SELECT 
    SYSDATE 현재,
    HIRE_DATE 고용일, 
    ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))일월수
FROM EMPLOYEE;

SELECT --ADD MONTHS 로 더하고 뺄 수 있다.
    HIRE_DATE, 
    ADD_MONTHS(HIRE_DATE, 2),
    ADD_MONTHS(HIRE_DATE,-2)
FROM EMPLOYEE;

SELECT --다음 수요일 을 알아볼때
    HIRE_DATE,
    NEXT_DAY(HIRE_DATE,3), -- 1일 2월 3화 4수 5목 6금 7토
    NEXT_DAY(HIRE_DATE, '수요일'),
    LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

SELECT 
    HIRE_DATE,
    ROUND(HIRE_DATE, 'YEAR'), --반올림
    TRUNC(HIRE_DATE, 'MONTH') --시간을 절삭 한다
FROM EMPLOYEE;

SELECT HIRE_DATE,
    ROUND(HIRE_DATE, 'YEAR'), --반올림
    ROUND(HIRE_DATE, 'MONTH'),
    TRUNC(HIRE_DATE, 'YEAR'), --절삭
    TRUNC(HIRE_DATE, 'MONTH')
FROM EMPLOYEE;

SELECT 1+ '2'
FROM DUAL; 

SELECT TO_CHAR(SYSDATE,'CC AD Q')
FROM DUAL; 
-- CC 세기 AD 서기 Q 쿼터 몇분기인지

SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD')
FROM DUAL; 

-- 월 기준으로 무슨요일인지
SELECT TO_CHAR(SYSDATE,'W DAY') 
FROM DUAL; 

--현재 시간 확인
SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS')
FROM DUAL; 

-- 24시간 현재 시간 확인
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS PM') 
FROM DUAL; 

SELECT TO_CHAR(SYSDATE,'YY"년"MM"월"DD"일"') 
FROM DUAL;

SELECT TO_DATE('20210909', 'YYMMDD')
FROM DUAL;

SELECT 
    TO_CHAR(TO_DATE('20200324', 'YYYYMMDDHH24MISS'), 'YYYY-MM-DD HH24:MI:SS')형식1,
    TO_CHAR(TO_DATE('20200324', 'YYYYMMDDHH24MISS'), 'YYYY/MM/DD HH24:MI:SS')형식2,
    TO_CHAR(TO_DATE('20200324', 'YYYYMMDDHH24MISS'), 'DD/MM/YYYY HH24:MI:SS')형식3,
    TO_DATE('20200324', 'YYYYMMDD')형식4
  FROM DUAL;
  
SELECT 
    TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE('19780124', 'YYYYMMDD')) / 12)) "년",
    TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE('19780124', 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19780124', 'YYYYMMDD')) / 12) * 12)) "개월",
    TRUNC((MONTHS_BETWEEN(SYSDATE, TO_DATE('19780124', 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19780124', 'YYYYMMDD')))) * 30.5) "일"
FROM DUAL;


