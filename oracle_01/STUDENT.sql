CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2(15) CONSTRAINT PK_MEMBER PRIMARY KEY,
    MEMBER_PWD VARCHAR2(15) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(1) CHECK (GENDER IN ('M','F')),
    AGE NUMBER NOT NULL,
    EMAIL VARCHAR2(30),
    PHONE CHAR(11),
    ADDRESS VARCHAR2(500),
    HOBBY VARCHAR(50),
    ENROLL_DATE DATE DEFAULT SYSDATE
    );


COMMENT ON COLUMN MEMBER.MEMBER_ID IS 'ȸ�����̵�';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS 'ȸ����й�ȣ';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS 'ȸ���̸�';
COMMENT ON COLUMN MEMBER.GENDER IS '����';
COMMENT ON COLUMN MEMBER.AGE IS '����';
COMMENT ON COLUMN MEMBER.EMAIL IS '�̸���';
COMMENT ON COLUMN MEMBER.PHONE IS '��ȭ��ȣ';
COMMENT ON COLUMN MEMBER.ADDRESS IS '�ּ�';
COMMENT ON COLUMN MEMBER.HOBBY IS '���';
COMMENT ON COLUMN MEMBER.ENROLL_DATE IS '���Գ�¥';

SELECT * FROM ALL_COL_COMMENTS WHERE TABLE_NAME='MEMBER'; 
SELECT * FROM USER_TAB_COLUMNS;
    
INSERT INTO MEMBER 
VALUES('admin', 'admin', '������', 'M', 30, 'admin@iei.or.kr', '01012345678', '����� ������ ���ﵿ �����ȣ 7',
       '��Ÿ, ����, �', '16/03/15');
INSERT INTO MEMBER
VALUES('user11', 'pas11', 'ȫ�浿', 'F', 23, 'hong77@kh.org', '01077778888',
       '��⵵ ������ �ȴޱ� �ȴ޵� 77', '�, ���, ��Ÿ', '17/09/21');
INSERT INTO MEMBER
VALUES('user22', 'pass22', '�Ż��Ӵ�', 'F', 48, 'shin50@kh.org', '01050005555',
       '������ ������ ������ 5', '����, �׸�, �丮', '17/05/05');
INSERT INTO MEMBER
VALUES('user77', 'user77', '�̼���', 'M', 50, 'dltjswnh@naver.com', '01021226374',
       '��⵵ �����', '����', '17/12/08');
INSERT INTO MEMBER
VALUES('lsj', 'lsj', '�̼���', 'F', 24, 'dltjswnh@naver.com', '01021226374',
       '��⵵ �Ȼ��', '�, ����, ��', '17/08/25');
INSERT INTO MEMBER
VALUES('seonn', 'seonn', '�����', 'F', 28, 'studyll@naver.com', '01021226374',
       '��⵵ ������', '����, å�б�', '17/11/08');
       
SELECT * FROM MEMBER;