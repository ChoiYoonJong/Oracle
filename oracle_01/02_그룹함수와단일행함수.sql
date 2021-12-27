-- 그룹함수와 단일행함수
--함수(FUNCTION) : 컬럼값을 읽어서 계산한 결과를 리턴함 
--단일행함수 : 컬럼에 기록된 N 개의 값을 읽어서 N 개의 결과를 리턴 
--그룹함수 : 컬럼에 기록된 N 개의 값을 읽어서 한개의 결과를 리턴 

--SELECT 절에 단일행 함수와 그룹함수를 함께 사용하지 못한다.  
--: 결과 행의 갯수가 다르기 때문

-- 함수를 사용할수 있는 위치 : SELECT 절, WHERE 절, GROUP BY 절, HAVING절, ORDER BY 절

-- 단일행 함수
-- 문자관련함수 
-- LENGTH, LENGTHB , SUBSTR,UPPER, LOWER, INSTR....

SELECT
    LENGTH('오라클')
    ,LENGTHB('오라클')
FROM DUAL;


SELECT
    LENGTH(EMAIL)
    ,LENGTHB(EMAIL)
FROM EMPLOYEE;

--DUAL 테이블
-- 한행으로 결과를 출력 하기 위한 산술연산이나 가상컬럼등의 값을 출력하고 싶을때 많이 사용 
--DUMMY : 단하나의 컬럼에 X(아무의미 없는 값 ) 라는 하나의 로우를 저장하고있음
--DB2 : SYSIBM.SYSDUMMY1

SELECT * FROM DUAL;
SELECT SYSDATE FROM DUAL;
SELECT 1+3 VAL FROM DUAL;

DESC DUAL;

--INSTR('문자열' | 컬럼명,'문자', 찾을 위치의 시작값 ,[빈도])
/*파라미터			설명
STRING			문자 타입 컬럼 또는 문자열
STR			찾으려는 문자(열)
POSITION		찾을 위치 시작 값 (기본값 1)
			POSITION > 0 : STRING의 시작부터 끝 방향으로 찾음
			POSITION < 0 : STRING의 끝부터 시작 방향으로 찾음
OCCURRENCE		검색된 STR의 순번(기본값 1), 음수 사용 불가

*/

SELECT
    EMAIL
    , INSTR(EMAIL, '@',-1) VAL
FROM EMPLOYEE


SELECT INSTR('AABAACAABBAA','B') LOC FROM DUAL; --3번째위치
SELECT INSTR('AABAACAABBAA','B',1) LOC FROM DUAL;---1번째 이후에있는 3번째위치
SELECT INSTR('AABAACAABBAA','B',4) LOC FROM DUAL;--4번째 이후에있는 B는 처음부터 9번째
SELECT INSTR('AABAACAABBAA','B',1,2) LOC FROM DUAL;--앞에서부터 1번째 이후에있는 2번째 'B' 의 위치 앞에서부터 세어보면 9번째 
SELECT INSTR('AABAACAABBAA','B',-1,2) LOC FROM DUAL;--뒤에서부터 1번째 이후에있는 2번째 'B' 의 위치 앞에서부터 세어보면 9번째

--뒤에서부터 첫번째있는 h의 위치
SELECT INSTR(EMAIL,'h',-1,1) VAL FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사원명, 이메일,
-- @이후를 제외한 아이디 조회 --SUBSTR('문자열', 시작위치, 자를길이)

SELECT
    EMP_NAME,
    EMAIL,
    SUBSTR(EMAIL, 1 , INSTR(EMAIL,'@')-1) SVAL,
    INSTR(EMAIL, '@')VAL
FROM EMPLOYEE;

-- LPAD / RPAD : 주어진 컬럼 문자열에 임의의 
--               문자열을 덧붙여 길이 N의 문자열을
--               반환하는 함수

SELECT
    LPAD(EMAIL, 20, '#')VAL
FROM EMPLOYEE;

SELECT
    RPAD(EMAIL, 20, '#')VAL
FROM EMPLOYEE;

--LTRIM/ RTRIM : 주어진 컬럼이나 문자열 왼쪽/오른쪽에서 지정한 
--              문자 혹은 문자열을 제거한 나머지를 반환하는 함수

SELECT LTRIM('    KH') FROM DUAL;
SELECT LTRIM('    KH',' ') FROM DUAL;
SELECT LTRIM('000123456','0') FROM DUAL;
SELECT LTRIM('123123KH', '123') FROM DUAL;
SELECT LTRIM('123123KH123','123') FROM DUAL;
SELECT LTRIM('ACABACCKH','ABC') FROM DUAL;
SELECT LTRIM('5782KH','0123445678')FROM DUAL;

SELECT RTRIM('KH    ') FROM DUAL;
SELECT RTRIM('KH    ',' ') FROM DUAL;
SELECT RTRIM('123456000','0') FROM DUAL;
SELECT RTRIM('KH123123', '123') FROM DUAL;
SELECT RTRIM('123123KH123','123') FROM DUAL;
SELECT RTRIM('KHACABACC','ABC') FROM DUAL;
SELECT RTRIM('KH5782','0123445678')FROM DUAL;

-- TRIM : 주어진 컬럼이나 문자열의 앞/뒤에 지정한 문자를 제거
SELECT TRIM('   KH   ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZKHZZZ') FROM DUAL;
SELECT TRIM(LEADING 'Z' FROM 'ZZZ123456ZZZ') FROM DUAL;
SELECT TRIM(TRAILING '3' FROM '33333KH333333') FROM DUAL;
SELECT TRIM(BOTH '3' FROM '333KH33333') FROM DUAL;

-- SUBSTR : 컬럼이나 문자열에서 지정한 위치로부터 지정한
--          갯수의 문자열을 잘라서 리턴하는 함수이다.
-- SUBSTR('문자열', 시작위치, 자를 길이)

SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('쇼우 미 더 머니', 2, 5) FROM DUAL;

SELECT EMP_NAME, SUBSTR(EMP_NO, 8, 1)
FROM EMPLOYEE;

-- SUBSTRB : 바이트 단위로 추출하는 함수
SELECT
    SUBSTR('오라클',2,1),
    SUBSTRB('오라클',1,6)
FROM DUAL;

--LOWER/UPPER/INITCAP : 대소문자 변경해주는 함수
--LOWER(문자열| 컬럼) : 소문자로 변경해주는 함수

SELECT
    LOWER('Welcome To My World') VAL
FROM DUAL;

--UPPER(문자열| 컬럼) : 대문자로 변경해주는 함수
SELECT
    UPPER('Welcome To My World') VAL
FROM DUAL;

--INITCAP : 앞글자만 대문자로 변경해주는 함수
SELECT
    INITCAP('welcome to my world') VAL
FROM DUAL;

--CONCAT : 문자열 혹은 컬럼두개를 입력받아 하나로 합친후 리턴
SELECT
    CONCAT('가나다라', 'ABCD') VAL
FROM DUAL;

SELECT
    '가나다라' || 'ABCD' VAL
FROM DUAL;

-- REPLACE : 컬럼혹은 문자열을 입력받아 변경하고자 하는 문자열을 변경
SELECT
    REPLACE('서울기 강남구 역삼동','역삼동','삼성동')VAL
FROM DUAL;

--1. EMPLOYEE 테이블에서 직원들의 주민번호를 조회하여 
-- 사원명, 생년, 생월,생일 을 각각 분리하여 조회 
-- 단 컬럼의 별칭은 생년, 생월,생일 로 한다.

SELECT 
    EMP_NAME 사원명, 
    SUBSTR(EMP_NO, 1, 2) 생년, 
    SUBSTR(EMP_NO, 3, 2) 생월, 
    SUBSTR(EMP_NO, 5, 2) 생일,
    EMP_NO
FROM EMPLOYEE;

--2. 여직원들의 모든 컬럼정보를 조회
SELECT * 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8,1) = 2;

--3. 직원들의 입사일을 입사년도, 입사월, 입사날짜를 분리하여 조회 (SUBSTR)
-- 단 컬럼의 별칭은 입사년도, 입사월, 입사날짜
SELECT
    EMP_NAME,
    SUBSTR(HIRE_DATE,1,2) 입사년도,
    SUBSTR(HIRE_DATE,4,2) 입사월,
    SUBSTR(HIRE_DATE,7,2) 입사날짜,
    HIRE_DATE 입사정보
FROM EMPLOYEE;

-- 함수 중첩사용 : 함수안에서 함수를 사용할수있음
--EMPLOYEE 테이블에서 사원명, 주민번호 조회
-- 단, 주민번호는 생년월일만 보이게하고 , '-' 다음값은 '*' 로 바꿔서 출력하라
SELECT 
    EMP_NAME 사원명, 
    RPAD(SUBSTR(EMP_NO, 1, 7), 14, '*') 주민번호 
FROM EMPLOYEE;

-- 숫자 처리 함수 : ABS, MOD, ROUND, FLOOR, TRUNC , CEIL
-- ABS(숫자 | 숫자 로 된 컬럼명 ) :절대값 구하는 함수
SELECT
    ABS(-10) COL1,
    ABS(10) COL2
FROM DUAL;

-- MOD(숫자 | 숫자로된 컬럼명, 숫자 | 숫자로된컬럼명) : 두수를 나누어서 나머지를 구하는 함수 
-- 처음인자는 나우어지는 수, 두번째인자는 나눌수
SELECT
    MOD(10,5) COL1,
    MOD(10,3) COL2
FROM DUAL;

-- ROUND( 숫자 | 숫자로된 컬럼명, [위치]) : 반올림해서 리턴하는 함수
SELECT ROUND(123.456)FROM DUAL;
SELECT ROUND(123.456,0)FROM DUAL;
SELECT ROUND(123.456,1)FROM DUAL;
SELECT ROUND(123.456,2)FROM DUAL;
SELECT ROUND(123.456,-2)FROM DUAL;

-- FLOOR(숫자 | 숫자로된 컬럼명)
--: 내림처리 하는 함수 (인자로 전달받은 숫자 혹은 컬럼의 소수점 자리수를 버리는 함수)
SELECT FLOOR(123.456)FROM DUAL;
SELECT FLOOR(123.6789)FROM DUAL;

-- TRUNC(숫자 | 숫자로된 컬럼명 , [위치])
--: 내림처리 (절삭) 함수(인자로 전달받은 숫자 혹은 컬럼의 지정한 위치 이후의 소수점 자리수를 버리는 함수 )
SELECT TRUNC(123.456)FROM DUAL;
SELECT TRUNC(123.6789)FROM DUAL;
SELECT TRUNC(123.456,1)FROM DUAL;
SELECT TRUNC(123.456,2)FROM DUAL;
SELECT TRUNC(123.456,-1)FROM DUAL;

-- CEIL(숫자 | 숫자로된 컬럼명): 올림처리함수(소수점 기준으로 올림처리)
SELECT CEIL(123.456)FROM DUAL;
SELECT CEIL(123.6789)FROM DUAL;

-- 날짜 함수 : SYSDATE, MONTHS_BETWEEN, ADD_MONTH
--            , NEXT_DAY, LAST_DAY, EXTRACT


-- SYSDATE : 시스템에 저장되어있는 날짜를 반환하는함수
SELECT SYSDATE FROM DUAL;

-- MONTHS_BETWEEN(날짜, 날짜) : 두날짜의 개월수 차이를 숫자로 리턴하는 함수
SELECT 
    EMP_NAME,
    HIRE_DATE,
    CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) COL1
FROM EMPLOYEE;


-- ADD_MONTHS(날짜, 숫자): 날짜에 숫자만큼 개월수를 더해서 리턴
SELECT 
    ADD_MONTHS(SYSDATE, - 1) COL1
FROM DUAL;

--EMPLOYEE 테이블에서 사원의 이름,입사일, 입사후 6개월되는 날짜 를 조회
SELECT 
    EMP_NAME,
    HIRE_DATE,
    ADD_MONTHS(HIRE_DATE, 6) COL
FROM EMPLOYEE;

--EMPLOYEE 테이블에서 근무년수가 20년 이상인 직원 조회
SELECT * 
FROM EMPLOYEE
--WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE;
WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;

--NEXT_DAY(기준날짜, 요일(문자|숫자)) : 기준날짜에서 구하려는 요일에 가장가까운 날짜리턴
SELECT SYSDATE, NEXT_DAY(SYSDATE,'목요일') NDAY FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE,5) NDAY FROM DUAL; --구하려는 요일이 숫자인경우 1: 일요일 ~~~ 7:토요일
SELECT SYSDATE, NEXT_DAY(SYSDATE,'목') NDAY FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE,'FRIDAY') NDAY FROM DUAL; --NLS_LANGUAGE 수정

-- NLS(NATIONAL LANGUAGE SUPPORT) : 언어지원과 관련된 파라미터
SELECT *
FROM SYS.NLS_SESSION_PARAMETERS
WHERE PARAMETER IN('NLS_LANGUAGE','NLS_DATE_FORMAT','NLS_DATE_LANGUAGE');

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;


--LAST_DAY(날짜 ) : 해당월의 마지막 날짜를 구하여 리턴
SELECT SYSDATE, LAST_DAY(SYSDATE) LDAY FROM DUAL;

-- EMPLOYEE 테이블에서 사원명, 
-- 입사일 - 오늘, 오늘 - 입사일 조회 :근무일수
SELECT 
    EMP_NAME 사원명, 
    CEIL(ABS(HIRE_DATE - SYSDATE)) COL1,
    CEIL(SYSDATE - HIRE_DATE) COL2
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사원명, 입사일, 
-- 입사한 월의 근무일수를 조회하세요
SELECT 
    EMP_NAME 사원명,
    HIRE_DATE 입사일,
    LAST_DAY(HIRE_DATE) - HIRE_DATE+1 근무일수
FROM EMPLOYEE;

-- EXTRACT : 년, 월,일 정보를 추출하여 리턴 하는 함수 
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만추출
-- EXTRACT(DAY FROM 날짜) : 날짜만 추출
SELECT
　　　　EXTRACT (YEAR FROM SYSDATE) 년도,
　　　　EXTRACT (MONTH FROM SYSDATE) 월,
　　　　EXTRACT (DAY FROM SYSDATE) 일
FROM DUAL;


--EMPLOYEE테이블에서 사원이름, 입사년,입사월, 입사일 을 조회
SELECT 
    EMP_NAME 사원이름,
    EXTRACT (YEAR FROM HIRE_DATE) 입사년,
    EXTRACT (MONTH FROM HIRE_DATE) 입사월,
    EXTRACT (DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
--ORDER BY EMP_NAME DESC;
--ORDER BY 사원이름;
--ORDER BY 1;
ORDER BY 2,3 DESC;

--EMPLOYEE테이블에서 사원이름, 입사일, 근무년수를 조회(단,근무년수는 현재년도 - 입사년도 로 조회)
SELECT
    EMP_NAME 사원이름,
    HIRE_DATE 입사일,
    SYSDATE,
    EXTRACT (YEAR FROM SYSDATE) - EXTRACT (YEAR FROM HIRE_DATE) COL1,
    CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) COL2
FROM EMPLOYEE;

--형변환 함수 
--TO_CHAR(날짜, [포멧]) : 날짜형데이터를 문자형 데이터로 변환
--TO_CHAR(숫자, [포멧]) : 숫자형데이터를 문자형 데이터로 변환

--Format		 예시			설명
--,(comma)	9,999		콤마 형식으로 변환
--.(period)	99.99		소수점 형식으로 변환
--0		09999		왼쪽에 0을 삽입
--$		$9999		$ 통화로 표시
--L		L9999		Local 통화로 표시(한국의 경우 \)
--9:자릿수를 나타내며 ,자릿수가 많지않아도 0으로채우지않는다
--0:자릿수를나타내며, 자릿수가 많지 않을 경우 0으로 채워준다.
--EEEE 과학 지수 표기법

SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '99999') FROM DUAL;
SELECT TO_CHAR(1234, '00000') FROM DUAL;
SELECT TO_CHAR(1234, 'L99999') FROM DUAL;
SELECT TO_CHAR(1234, '$99,999') FROM DUAL;
SELECT TO_CHAR(1234, '00,000') FROM DUAL;
SELECT TO_CHAR(1234, '9.9EEEE') FROM DUAL;
SELECT TO_CHAR(1234, '999') FROM DUAL;

--EMPLOYEE 테이블에서 사원명 급여를 조회 
-- 급여를 ￦9,000,000 형식으로 표현 하시오
SELECT 
    EMP_NAME 사원명, 
    TO_CHAR(SALARY, 'L999,999,999') 급여
FROM EMPLOYEE;

--날짜 데이터 포맷 적용
SELECT TO_CHAR(SYSDATE,'PM HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'AM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'MON DY,YYYY') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY-fmMM-DD DAY') FROM DUAL;
SELECT TO_CHAR(TO_DATE('980630','RRMMDD'),'YYYY-fmMM-DD') FROM DUAL; -- 월앞에 0제거하고 싶을때 fm사용
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YEAR,Q')||'분기' FROM DUAL;

--입사일 YYYY-MM-DD
SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')입사일
FROM EMPLOYEE;

---- 상세입사일 YYYY-MM-DD + 시분초
SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD HH24:MI:SS')상세입사일
FROM EMPLOYEE;

SELECT CURRENT_TIMESTAMP
FROM DUAL;

SELECT TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') COL1,
       TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDDHH24MISS') COL2
FROM EMPLOYEE;

--RR 과 YY 차이 
--RR 은 두자리년도를 네자리로 바꿀대 바꿀년도가
--50년 미만이면 2000년을 적용 
--50년 이상이면 1900년을 적용

-- 년도 바꿀 때(TO_DATE 사용시) Y를 적용하면
-- 현재 세기(2000년)가 적용된다.
-- R은 50년 이상이면 이전 세기(1900년),
-- 50년 미만이면 현재 세기(2000년) 적용


SELECT 
    TO_CHAR(TO_DATE('980630','YYMMDD'), 'YYYY-MM-DD')COL1
FROM DUAL;

SELECT 
    TO_CHAR(TO_DATE('980630','RRMMDD'), 'YYYY-MM-DD')COL1
FROM DUAL;

-- 오늘날짜에서 월만 출력
SELECT 
    TO_CHAR(SYSDATE,'MM')
    ,TO_CHAR(SYSDATE,'MONTH')
    ,TO_CHAR(SYSDATE,'MON')
    ,TO_CHAR(SYSDATE,'RM')--로마문자로 표기
FROM DUAL;

-- 오늘날짜에서 일만 출력
SELECT 
    TO_CHAR(SYSDATE,'"1년기준" DDD "일째"')
    ,TO_CHAR(SYSDATE,'"달기준" DD "일째"')
    ,TO_CHAR(SYSDATE,'"주기준" D "일째"')
FROM DUAL;

-- 오늘 날짜에서 분기와 요일 출력 처리

SELECT
    TO_CHAR(SYSDATE,'Q"분기"')
    ,TO_CHAR(SYSDATE,'DAY')
    ,TO_CHAR(SYSDATE,'DY')
FROM DUAL;

--EMPLOYEE 테이블에서 이름,입사일 조회 (입사일포맷 : '2018년 6월 15일 (수)'형식으로 출력처리하시오
SELECT
    EMP_NAME 이름,
    TO_CHAR(HIRE_DATE, '"입사일포맷 :" YYYY"년" FMMM"월" DD"일" "("DY")"') 입사일조회
FROM EMPLOYEE;

--TO_DATE:문자형 데이터를 날짜형 데이터로 변환하여 리턴
--TO_DATE(문자,[포맷])
SELECT
    TO_DATE('20100101', 'YYYYMMDD')
FROM DUAL;

SELECT
    TO_CHAR(TO_DATE('20100101', 'YYYYMMDD'),'YYYY, MON')COL1
FROM DUAL;

SELECT
    TO_DATE('041030 143000','YYMMDD HH24MISS') COL1
FROM DUAL;

SELECT
    TO_CHAR(TO_DATE('041030 143000','YYMMDD HH24MISS'), 'DD-MON-YY HH:MI:SS PM')COL1
FROM DUAL;

--EMPLOYEE 테이블에서 2000년도 이후에 입사한 사원의 
--사번,이름,입사일을 조회하세요
SELECT
    EMP_ID,
    EMP_NAME,
    HIRE_DATE
FROM EMPLOYEE
--WHERE HIRE_DATE >= '20000101';
--WHERE HIRE_DATE >= TO_DATE('20000101', 'YYYYMMDD');
WHERE TO_CHAR(HIRE_DATE, 'YYYYMMDD')>='20000101';

--TO_NUMBER(문자데이터, [포맷]) : 문자데이터를 숫자로 리턴
SELECT TO_NUMBER('123456789') COL1	
FROM DUAL;

SELECT TO_NUMBER('1,000,000', '9,999,999') - TO_NUMBER('550,000','9,999,999') COL1
FROM DUAL;

--자동형변화
SELECT '123' + '45' FROM DUAL;
SELECT '123' + '456A' FROM DUAL; -- 숫자로된 문자열만 자동형변환 가능

--EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보를 모두 조회 하시오
SELECT *
FROM EMPLOYEE
--WHERE MOD(EMP_ID, 2) = 1;
WHERE MOD(TO_NUMBER(EMP_ID),2) = 1;