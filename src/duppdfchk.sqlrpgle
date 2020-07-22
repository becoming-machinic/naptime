**FREE

Ctl-Opt Copyright('Becoming Machinic 2019');

/INCLUDE './headers/base.rpgle'

Dcl-Pi DUPPDFCHK;
  pFileA      Char(128);
  pFileB      Char(128);
  pUpperLeft  Int(10);
  pUpperRight Int(10);
  pLowerLeft  Int(10);
  pLowerRight Int(10);
  oStatus     Packed(5);
  oStatDesc   Char(100);
End-Pi;

Dcl-S gCommand Varchar(256);
dcl-pr Cmd int(10) extproc('system');
  cmdstring pointer value options(*string);
end-pr;

Dcl-s random Int(5);
Dcl-s regions char(200);

Dcl-Ds RequestData Qualified;
  Type   Char(5) Inz('*POST');
  URL    Char(128);
  Header Char(2048) CCSID(1208);
End-Ds;

Dcl-S BodyClob SQLTYPE(CLOB:5242880);
Dcl-S BodyClobPtr Pointer Inz(%Addr(BodyClob));

Dcl-Ds FileData Qualified;
  FileA   Varchar(128);
  OutputA Varchar(128);
  FileB   Varchar(128);
  OutputB Varchar(128);
End-Ds;

RequestData.URL = 'https://demo.machinic.io/example/endpoint/';
RequestData.Header = '<httpHeader>'
                   +   '<header name="Content-Type" value="application/json"/>'
                   +   '<header name="Authorization" value="Example'
                   +   'Token"/>'
                   + '</httpHeader>';
				   
				   

EXEC SQL
  SET :random = floor(rand() * 100 + 0.99999);

FileData.FileA   = %Trim(pFileA);
FileData.OutputA = '/tmp/filea' + %Char(random) + '.output';
FileData.FileB   = %Trim(pFileB);
FileData.OutputB = '/tmp/fileb' + %Char(random) + '.output';

gCommand = '/QOpenSys/pkgs/bin/base64 -w 0 ' + FileData.FileA + ' > ' + FileData.OutputA;
Cmd('QSH CMD(''' + gCommand + ''')');

gCommand = '/QOpenSys/pkgs/bin/base64 -w 0 ' + FileData.FileB + ' > ' + FileData.OutputB;
Cmd('QSH CMD(''' + gCommand + ''')');

if (pUpperLeft >0 or pUpperRight > 0 or pLowerLeft > 0 or pLowerRight > 0);
regions = %char(pUpperLeft) + ',' + %char(pUpperRight) + ',';
regions = %trim(regions) + %char(pLowerLeft) + ',' + %char(pLowerRight);
EXEC SQL
  SELECT JSON_OBJECT(
                'document1': GET_CLOB_FROM_FILE(:FileData.OutputA, 0),
                'document2': GET_CLOB_FROM_FILE(:FileData.OutputB, 0),
				'regions': rtrim(:regions)
        )
  into :BodyClob
  from sysibm.sysdummy1 WITH CS;

else;
EXEC SQL
  SELECT JSON_OBJECT(
                'document1': GET_CLOB_FROM_FILE(:FileData.OutputA, 0),
                'document2': GET_CLOB_FROM_FILE(:FileData.OutputB, 0))
  into :BodyClob
  from sysibm.sysdummy1 WITH CS;

endif;


BodyClobPtr = %Addr(BodyClob);
BASE(
  RequestData.Type:
  RequestData.URL:
  RequestData.Header:
  BodyClobPtr:
  oStatus
);

EXEC SQL
	SELECT STATUS_DESCRIPTION into :oStatDesc FROM STATUSES WHERE STATUS_CODE = :oStatus;

Cmd('RMVLNK OBJLNK(''' + FileData.OutputA + ''')');
Cmd('RMVLNK OBJLNK(''' + FileData.OutputB + ''')');

Return;
