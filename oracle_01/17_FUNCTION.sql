--FUNCTION 
-- : 프로시져와 사용용도가 비슷하다.
--   실행결과를 되돌려받을수 있다 (RETURN)

--[표현법]
/*
CREATE [OR REPLACE] FUNCTION 함수이름(매개변수명, 자료형,...)
RETURN 자료형;
IS
    지역변수선언;
BEGIN
    실행할 SQL문;
    RETURN 데이터;
END;
/

*/
-- 사번을 입력받아 해당사원의 연봉을 계산하여 리턴하는 저장함수 를 만들어 출력하시오
CREATE OR REPLACE FUNCTION BONUS_CALC
(
    V_EMP EMPLOYEE.EMP_ID%TYPE
)
RETURN NUMBER 
IS
    V_SAL EMPLOYEE.SALARY%TYPE;
    V_BONUS EMPLOYEE.BONUS%TYPE;
    CALC_SAL NUMBER;
BEGIN
    SELECT SALARY, NVL(BONUS,0)
    INTO V_SAL,V_BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = V_EMP;
    
    CALC_SAL := (V_SAL + (V_SAL * V_BONUS)) * 12;
    RETURN CALC_SAL;
END;
/

--OUT 바인드 변수
VARIABLE VAR_CALC NUMBER;
EXEC :VAR_CALC := BONUS_CALC('&EMP_ID');

SET AUTOPRINT ON;

PRINT VAR_CALC;

-- 사번을 전달받아 사원에게 보너스를 지급하려고 하는데, 급여의 200% 를 지급하려고 한다.
-- 그 금액을 FUNCTION 을 통해 리턴받아 출력하시오 
-- 저장함수명 : BONUS_CAL

CREATE FUNCTION BONUS_CAL(V_ID IN EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
    VSALARY EMPLOYEE.SALARY%TYPE;
    VBONUS NUMBER;
BEGIN
    SELECT
        SALARY
    INTO
        VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = V_ID;
    
    VBONUS := VSALARY *2;
    RETURN VBONUS;
END;
/

VARIABLE RESULT NUMBER;
EXEC :RESULT := BONUS_CALC('&EMP_ID');

SELECT BONUS_CAL(EMP_ID) VAL FROM EMPLOYEE;

DROP FUNCTION BONUS_CAL;