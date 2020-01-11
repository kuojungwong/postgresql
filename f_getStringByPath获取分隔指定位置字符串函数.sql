CREATE OR REPLACE FUNCTION f_getStringByPath(str VARCHAR, poi int4, split VARCHAR)
RETURNS "pg_catalog"."text" AS $BODY$ 

DECLARE locat INT;
DECLARE locatstr INT;
DECLARE pstart INT;
DECLARE pnext INT;
DECLARE lsplit INT;
DECLARE pstr VARCHAR;
DECLARE retstr text;

BEGIN 

/* 
 create by kuojunghuang 
 createtime 20190528

 Explain 按位置截取字符串，参数 
                           str=待截取字符串 
                           poi=字符串位置（poi小于分隔位置，则返回第一个位置对应字符串；poi大于分隔位置，则返回末尾位置对应字符串） 
                           split=分隔符
 Example:

SELECT 
      f_getStringByPath('广州有限公司/深圳营业部/深圳分公司/西丽营业所/商场科',-100,'/'),
      f_getStringByPath('广州有限公司/深圳营业部/深圳分公司/西丽营业所/商场科',1,'/'),
      f_getStringByPath('广州有限公司/深圳营业部/深圳分公司/西丽营业所/商场科',2,'/'),
      f_getStringByPath('广州有限公司/深圳营业部/深圳分公司/西丽营业所/商场科',3,'/'),
      f_getStringByPath('广州有限公司/深圳营业部/深圳分公司/西丽营业所/商场科',4,'/'),
      f_getStringByPath('广州有限公司/深圳营业部/深圳分公司/西丽营业所/商场科',5,'/'),
      f_getStringByPath('广州有限公司/深圳营业部/深圳分公司/西丽营业所/商场科',60,'/')
*/ 

pstr := ltrim(rtrim(str));
str := ltrim(rtrim(str));
pstart := 1;
pnext := 1;
lsplit := length(split);
locat :=POSITION(split IN str);

while (locat != 0 and poi > pnext) loop
   pstart := locat+1;
   pstr := substring(pstr,position(split in pstr)+1);
   locatstr := POSITION(split IN pstr)+lsplit;
   locat := locatstr+locat-1;
   pnext := pnext+1;
end loop;

IF locat =0 THEN 
locat :=length(str)+1;
end if;

IF poi>pnext then
  retstr := '';
ELSE
IF pstart>locat THEN
  retstr := SUBSTR(str,locat+1,pstart);
ELSE
  retstr := SUBSTR(str,pstart,locat-pstart);
END IF;
END IF;

RETURN retstr;

END
$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;