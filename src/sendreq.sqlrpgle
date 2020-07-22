        
        /INCLUDE './headers/base.rpgle'

        Dcl-Pi SENDREQ;
          pType     Char(5);
          pEndpoint Char(128);
          pHeader   Char(2048) CCSID(1208);
          pBody     Char(16384);
          oStatus   Packed(5)   Options(*NoPass);
        End-Pi;

        Dcl-S BodyClob SQLTYPE(CLOB:16384);
        Dcl-S BodyClobPtr Pointer Inz(%Addr(BodyClob));

        If (pBody <> *Blank);
          EXEC SQL SET :BodyClob = rtrim(:pBody);
        Else;
          BodyClob_Len = 0;
        Endif;

        BASE(
          pType:
          pEndpoint:
          pHeader:
          BodyClobPtr:
          oStatus
        );

        Return;